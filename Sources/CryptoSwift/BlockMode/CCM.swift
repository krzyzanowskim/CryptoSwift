////  CryptoSwift
//
//  Copyright (C) 2014-2018 Marcin Krzyżanowski <marcin@krzyzanowskim.com>
//  This software is provided 'as-is', without any express or implied warranty.
//
//  In no event will the authors be held liable for any damages arising from the use of this software.
//
//  Permission is granted to anyone to use this software for any purpose,including commercial applications, and to alter it and redistribute it freely, subject to the following restrictions:
//
//  - The origin of this software must not be misrepresented; you must not claim that you wrote the original software. If you use this software in a product, an acknowledgment in the product documentation is required.
//  - Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.
//  - This notice may not be removed or altered from any source or binary distribution.
//

// CCM mode combines the well known CBC-MAC with the well known counter mode of encryption.
// https://tools.ietf.org/html/rfc3610
// https://csrc.nist.gov/publications/detail/sp/800-38c/final

#if canImport(Darwin)
  import Darwin
#else
  import Glibc
#endif

/// Counter with Cipher Block Chaining-Message Authentication Code
public struct CCM: StreamMode {
  public enum Error: Swift.Error {
    /// Invalid IV
    case invalidInitializationVector
    case invalidParameter
    case fail
  }

  public let options: BlockModeOption = [.initializationVectorRequired, .useEncryptToDecrypt]
  private let nonce: Array<UInt8>
  private let additionalAuthenticatedData: Array<UInt8>?
  private let tagLength: Int
  private let messageLength: Int // total message length. need to know in advance

  // `authenticationTag` nil for encryption, known tag for decryption
  /// For encryption, the value is set at the end of the encryption.
  /// For decryption, this is a known Tag to validate against.
  public var authenticationTag: Array<UInt8>?

  /// Initialize CCM
  ///
  /// - Parameters:
  ///   - iv: Initialization vector. Nonce. Valid length between 7 and 13 bytes.
  ///   - tagLength: Authentication tag length, in bytes. Value of {4, 6, 8, 10, 12, 14, 16}.
  ///   - messageLength: Plaintext message length (excluding tag if attached). Length have to be provided in advance.
  ///   - additionalAuthenticatedData: Additional authenticated data.
  public init(iv: Array<UInt8>, tagLength: Int, messageLength: Int, additionalAuthenticatedData: Array<UInt8>? = nil) {
    self.nonce = iv
    self.tagLength = tagLength
    self.additionalAuthenticatedData = additionalAuthenticatedData
    self.messageLength = messageLength // - tagLength
  }

  /// Initialize CCM
  ///
  /// - Parameters:
  ///   - iv: Initialization vector. Nonce. Valid length between 7 and 13 bytes.
  ///   - tagLength: Authentication tag length, in bytes. Value of {4, 6, 8, 10, 12, 14, 16}.
  ///   - messageLength: Plaintext message length (excluding tag if attached). Length have to be provided in advance.
  ///   - authenticationTag: Authentication Tag value if not concatenated to ciphertext.
  ///   - additionalAuthenticatedData: Additional authenticated data.
  public init(iv: Array<UInt8>, tagLength: Int, messageLength: Int, authenticationTag: Array<UInt8>, additionalAuthenticatedData: Array<UInt8>? = nil) {
    self.init(iv: iv, tagLength: tagLength, messageLength: messageLength, additionalAuthenticatedData: additionalAuthenticatedData)
    self.authenticationTag = authenticationTag
  }

  public func worker(blockSize: Int, cipherOperation: @escaping CipherOperationOnBlock, encryptionOperation: @escaping CipherOperationOnBlock) throws -> CipherModeWorker {
    if self.nonce.isEmpty {
      throw Error.invalidInitializationVector
    }

    return CCMModeWorker(blockSize: blockSize, nonce: self.nonce.slice, messageLength: self.messageLength, additionalAuthenticatedData: self.additionalAuthenticatedData, tagLength: self.tagLength, cipherOperation: cipherOperation)
  }
}

class CCMModeWorker: StreamModeWorker, SeekableModeWorker, CounterModeWorker, FinalizingEncryptModeWorker, FinalizingDecryptModeWorker {
  typealias Counter = Int
  var counter = 0

  let cipherOperation: CipherOperationOnBlock
  let blockSize: Int
  private let tagLength: Int
  private let messageLength: Int // total message length. need to know in advance
  private let q: UInt8

  let additionalBufferSize: Int
  private var keystreamPosIdx = 0
  private let nonce: Array<UInt8>
  private var last_y: ArraySlice<UInt8> = []
  private var keystream: Array<UInt8> = []
  // Known Tag used to validate during decryption
  private var expectedTag: Array<UInt8>?

  public enum Error: Swift.Error {
    case invalidParameter
  }

  init(blockSize: Int, nonce: ArraySlice<UInt8>, messageLength: Int, additionalAuthenticatedData: [UInt8]?, expectedTag: Array<UInt8>? = nil, tagLength: Int, cipherOperation: @escaping CipherOperationOnBlock) {
    self.blockSize = 16 // CCM is defined for 128 block size
    self.tagLength = tagLength
    self.additionalBufferSize = tagLength
    self.messageLength = messageLength
    self.expectedTag = expectedTag
    self.cipherOperation = cipherOperation
    self.nonce = Array(nonce)
    self.q = UInt8(15 - nonce.count) // n = 15-q

    let hasAssociatedData = additionalAuthenticatedData != nil && !additionalAuthenticatedData!.isEmpty
    self.processControlInformation(nonce: self.nonce, tagLength: tagLength, hasAssociatedData: hasAssociatedData)

    if let aad = additionalAuthenticatedData, hasAssociatedData {
      self.process(aad: aad)
    }
  }

  // For the very first time setup new IV (aka y0) from the block0
  private func processControlInformation(nonce: [UInt8], tagLength: Int, hasAssociatedData: Bool) {
    let block0 = try! format(nonce: nonce, Q: UInt32(self.messageLength), q: self.q, t: UInt8(tagLength), hasAssociatedData: hasAssociatedData).slice
    let y0 = self.cipherOperation(block0)!.slice
    self.last_y = y0
  }

  private func process(aad: [UInt8]) {
    let encodedAAD = format(aad: aad)

    for block_i in encodedAAD.batched(by: 16) {
      let y_i = self.cipherOperation(xor(block_i, self.last_y))!.slice
      self.last_y = y_i
    }
  }

  private func S(i: Int) throws -> [UInt8] {
    let ctr = try format(counter: i, nonce: nonce, q: q)
    return self.cipherOperation(ctr.slice)!
  }

  func seek(to position: Int) throws {
    self.counter = position
    self.keystream = try self.S(i: position)
    let offset = position % self.blockSize
    self.keystreamPosIdx = offset
  }

  func encrypt(block plaintext: ArraySlice<UInt8>) -> Array<UInt8> {
    var result = Array<UInt8>(reserveCapacity: plaintext.count)

    var processed = 0
    while processed < plaintext.count {
      // Need a full block here to update keystream and do CBC
      if self.keystream.isEmpty || self.keystreamPosIdx == self.blockSize {
        // y[i], where i is the counter. Can encrypt 1 block at a time
        self.counter += 1
        guard let S = try? S(i: counter) else { return Array(plaintext) }
        let plaintextP = addPadding(Array(plaintext), blockSize: blockSize)
        guard let y = cipherOperation(xor(last_y, plaintextP)) else { return Array(plaintext) }
        self.last_y = y.slice

        self.keystream = S
        self.keystreamPosIdx = 0
      }

      let xored: Array<UInt8> = xor(plaintext[plaintext.startIndex.advanced(by: processed)...], keystream[keystreamPosIdx...])
      keystreamPosIdx += xored.count
      processed += xored.count
      result += xored
    }
    return result
  }

  func finalize(encrypt ciphertext: ArraySlice<UInt8>) throws -> ArraySlice<UInt8> {
    // concatenate T at the end
    guard let S0 = try? S(i: 0) else { return ciphertext }

    let computedTag = xor(last_y.prefix(self.tagLength), S0) as ArraySlice<UInt8>
    return ciphertext + computedTag
  }

  // Decryption is stream
  // CBC is block
  private var accumulatedPlaintext: [UInt8] = []

  func decrypt(block ciphertext: ArraySlice<UInt8>) -> Array<UInt8> {
    var output = Array<UInt8>(reserveCapacity: ciphertext.count)

    do {
      var currentCounter = self.counter
      var processed = 0
      while processed < ciphertext.count {
        // Need a full block here to update keystream and do CBC
        // New keystream for a new block
        if self.keystream.isEmpty || self.keystreamPosIdx == self.blockSize {
          currentCounter += 1
          guard let S = try? S(i: currentCounter) else { return Array(ciphertext) }
          self.keystream = S
          self.keystreamPosIdx = 0
        }

        let xored: Array<UInt8> = xor(ciphertext[ciphertext.startIndex.advanced(by: processed)...], keystream[keystreamPosIdx...]) // plaintext
        keystreamPosIdx += xored.count
        processed += xored.count
        output += xored
        self.counter = currentCounter
      }
    }

    // Accumulate plaintext for the MAC calculations at the end.
    // It would be good to process it together though, here.
    self.accumulatedPlaintext += output

    // Shouldn't return plaintext until validate tag.
    // With incremental update, can't validate tag until all block are processed.
    return output
  }

  func finalize(decrypt plaintext: ArraySlice<UInt8>) throws -> ArraySlice<UInt8> {
    // concatenate T at the end
    let computedTag = Array(last_y.prefix(self.tagLength))
    guard let expectedTag = self.expectedTag, expectedTag == computedTag else {
      throw CCM.Error.fail
    }

    return plaintext
  }

  @discardableResult
  func willDecryptLast(bytes ciphertext: ArraySlice<UInt8>) throws -> ArraySlice<UInt8> {
    // get tag of additionalBufferSize size
    // `ciphertext` contains at least additionalBufferSize bytes
    // overwrite expectedTag property used later for verification
    guard let S0 = try? S(i: 0) else { return ciphertext }
    self.expectedTag = xor(ciphertext.suffix(self.tagLength), S0) as [UInt8]
    return ciphertext[ciphertext.startIndex..<ciphertext.endIndex.advanced(by: -Swift.min(tagLength, ciphertext.count))]
  }

  func didDecryptLast(bytes plaintext: ArraySlice<UInt8>) throws -> ArraySlice<UInt8> {

    // Calculate Tag, from the last CBC block, for accumulated plaintext.
    var processed = 0
    for block in self.accumulatedPlaintext.batched(by: self.blockSize) {
      let blockP = addPadding(Array(block), blockSize: blockSize)
      guard let y = cipherOperation(xor(last_y, blockP)) else { return plaintext }
      self.last_y = y.slice
      processed += block.count
    }
    self.accumulatedPlaintext.removeFirst(processed)
    return plaintext
  }
}

// Q - octet length of P
// q - octet length of Q. Maximum length (in octets) of payload. An element of {2,3,4,5,6,7,8}
// t - octet length of T (MAC length). An element of {4,6,8,10,12,14,16}
private func format(nonce N: [UInt8], Q: UInt32, q: UInt8, t: UInt8, hasAssociatedData: Bool) throws -> [UInt8] {
  var flags0: UInt8 = 0

  if hasAssociatedData {
    // 7 bit
    flags0 |= (1 << 6)
  }

  // 6,5,4 bit is t in 3 bits
  flags0 |= (((t - 2) / 2) & 0x07) << 3

  // 3,2,1 bit is q in 3 bits
  flags0 |= ((q - 1) & 0x07) << 0

  var block0: [UInt8] = Array<UInt8>(repeating: 0, count: 16)
  block0[0] = flags0

  // N in 1...(15-q) octets, n = 15-q
  // n is an element of {7,8,9,10,11,12,13}
  let n = 15 - Int(q)
  guard (n + Int(q)) == 15 else {
    // n+q == 15
    throw CCMModeWorker.Error.invalidParameter
  }
  block0[1...n] = N[0...(n - 1)]

  // Q in (16-q)...15 octets
  block0[(16 - Int(q))...15] = Q.bytes(totalBytes: Int(q)).slice

  return block0
}

/// Formatting of the Counter Blocks. Ctr[i]
/// The counter generation function.
/// Q - octet length of P
/// q - octet length of Q. Maximum length (in octets) of payload. An element of {2,3,4,5,6,7,8}
private func format(counter i: Int, nonce N: [UInt8], q: UInt8) throws -> [UInt8] {
  var flags0: UInt8 = 0

  // bit 8,7 is Reserved
  // bit 4,5,6 shall be set to 0
  // 3,2,1 bit is q in 3 bits
  flags0 |= ((q - 1) & 0x07) << 0

  var block = Array<UInt8>(repeating: 0, count: 16) // block[0]
  block[0] = flags0

  // N in 1...(15-q) octets, n = 15-q
  // n is an element of {7,8,9,10,11,12,13}
  let n = 15 - Int(q)
  guard (n + Int(q)) == 15 else {
    // n+q == 15
    throw CCMModeWorker.Error.invalidParameter
  }
  block[1...n] = N[0...(n - 1)]

  // [i]8q in (16-q)...15 octets
  block[(16 - Int(q))...15] = i.bytes(totalBytes: Int(q)).slice

  return block
}

/// Resulting can be partitioned into 16-octet blocks
private func format(aad: [UInt8]) -> [UInt8] {
  let a = aad.count

  switch Double(a) {
    case 0..<65280: // 2^16-2^8
      // [a]16
      return addPadding(a.bytes(totalBytes: 2) + aad, blockSize: 16)
    case 65280..<4_294_967_296: // 2^32
      // [a]32
      return addPadding([0xFF, 0xFE] + a.bytes(totalBytes: 4) + aad, blockSize: 16)
    case 4_294_967_296..<pow(2, 64): // 2^64
      // [a]64
      return addPadding([0xFF, 0xFF] + a.bytes(totalBytes: 8) + aad, blockSize: 16)
    default:
      // Reserved
      return addPadding(aad, blockSize: 16)
  }
}

// If data is not a multiple of block size bytes long then the remainder is zero padded
// Note: It's similar to ZeroPadding, but it's not the same.
private func addPadding(_ bytes: Array<UInt8>, blockSize: Int) -> Array<UInt8> {
  if bytes.isEmpty {
    return Array<UInt8>(repeating: 0, count: blockSize)
  }

  let remainder = bytes.count % blockSize
  if remainder == 0 {
    return bytes
  }

  let paddingCount = blockSize - remainder
  if paddingCount > 0 {
    return bytes + Array<UInt8>(repeating: 0, count: paddingCount)
  }
  return bytes
}
