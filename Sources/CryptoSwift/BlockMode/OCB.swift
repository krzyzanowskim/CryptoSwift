//
//  CryptoSwift
//
//  Copyright (C) Marcin Krzyżanowski <marcin@krzyzanowskim.com>
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

//  The OCB Authenticated-Encryption Algorithm
//  https://tools.ietf.org/html/rfc7253
//

public final class OCB: BlockMode {

  public enum Mode {
    /// In combined mode, the authentication tag is directly appended to the encrypted message. This is usually what you want.
    case combined
    /// Some applications may need to store the authentication tag and the encrypted message at different locations.
    case detached
  }

  public let options: BlockModeOption = [.initializationVectorRequired]

  public enum Error: Swift.Error {
    case invalidNonce
    case fail
  }

  private let N: Array<UInt8>
  private let additionalAuthenticatedData: Array<UInt8>?
  private let mode: Mode
  public let customBlockSize: Int? = nil

  /// Length of authentication tag, in bytes.
  /// For encryption, the value is given as init parameter.
  /// For decryption, the length of given authentication tag is used.
  private let tagLength: Int

  // `authenticationTag` nil for encryption, known tag for decryption
  /// For encryption, the value is set at the end of the encryption.
  /// For decryption, this is a known Tag to validate against.
  public var authenticationTag: Array<UInt8>?

  // encrypt
  public init(nonce N: Array<UInt8>, additionalAuthenticatedData: Array<UInt8>? = nil, tagLength: Int = 16, mode: Mode = .detached) {
    self.N = N
    self.additionalAuthenticatedData = additionalAuthenticatedData
    self.mode = mode
    self.tagLength = tagLength
  }

  // decrypt
  @inlinable
  public convenience init(nonce N: Array<UInt8>, authenticationTag: Array<UInt8>, additionalAuthenticatedData: Array<UInt8>? = nil, mode: Mode = .detached) {
    self.init(nonce: N, additionalAuthenticatedData: additionalAuthenticatedData, tagLength: authenticationTag.count, mode: mode)
    self.authenticationTag = authenticationTag
  }

  public func worker(blockSize: Int, cipherOperation: @escaping CipherOperationOnBlock, encryptionOperation: @escaping CipherOperationOnBlock) throws -> CipherModeWorker {
    if self.N.isEmpty || self.N.count > 15 {
      throw Error.invalidNonce
    }

    let worker = OCBModeWorker(N: N.slice, aad: self.additionalAuthenticatedData?.slice, expectedTag: self.authenticationTag, tagLength: self.tagLength, mode: self.mode, cipherOperation: cipherOperation, encryptionOperation: encryptionOperation)
    worker.didCalculateTag = { [weak self] tag in
      self?.authenticationTag = tag
    }
    return worker
  }
}

// MARK: - Worker

final class OCBModeWorker: BlockModeWorker, FinalizingEncryptModeWorker, FinalizingDecryptModeWorker {

  let cipherOperation: CipherOperationOnBlock
  var hashOperation: CipherOperationOnBlock!

  // Callback called when authenticationTag is ready
  var didCalculateTag: ((Array<UInt8>) -> Void)?

  private let tagLength: Int

  let blockSize = 16 // 128 bit
  var additionalBufferSize: Int
  private let mode: OCB.Mode

  // Additional authenticated data
  private let aad: ArraySlice<UInt8>?
  // Known Tag used to validate during decryption
  private var expectedTag: Array<UInt8>?

  /*
   * KEY-DEPENDENT
   */
  // NOTE: elements are lazily calculated
  private var l = [Array<UInt8>]()
  private var lAsterisk: Array<UInt8>
  private var lDollar: Array<UInt8>

  /*
   * PER-ENCRYPTION/DECRYPTION
   */
  private var mainBlockCount: UInt64
  private var offsetMain: Array<UInt8>
  private var checksum: Array<UInt8>

  init(N: ArraySlice<UInt8>, aad: ArraySlice<UInt8>? = nil, expectedTag: Array<UInt8>? = nil, tagLength: Int, mode: OCB.Mode, cipherOperation: @escaping CipherOperationOnBlock, encryptionOperation: @escaping CipherOperationOnBlock) {

    self.cipherOperation = cipherOperation
    self.hashOperation = encryptionOperation
    self.mode = mode
    self.aad = aad
    self.expectedTag = expectedTag
    self.tagLength = tagLength

    if mode == .combined {
      self.additionalBufferSize = tagLength
    } else {
      self.additionalBufferSize = 0
    }

    /*
     * KEY-DEPENDENT INITIALIZATION
     */

    let zeros = Array<UInt8>(repeating: 0, count: self.blockSize)
    self.lAsterisk = self.hashOperation(zeros.slice)! /// L_* = ENCIPHER(K, zeros(128))
    self.lDollar = double(self.lAsterisk) /// L_$ = double(L_*)
    self.l.append(double(self.lDollar)) /// L_0 = double(L_$)

    /*
     * NONCE-DEPENDENT AND PER-ENCRYPTION/DECRYPTION INITIALIZATION
     */

    /// Nonce = num2str(TAGLEN mod 128,7) || zeros(120-bitlen(N)) || 1 || N
    var nonce = Array<UInt8>(repeating: 0, count: blockSize)
    nonce[(nonce.count - N.count)...] = N
    nonce[0] = UInt8(tagLength) << 4
    nonce[blockSize - 1 - N.count] |= 1

    /// bottom = str2num(Nonce[123..128])
    let bottom = nonce[15] & 0x3F

    /// Ktop = ENCIPHER(K, Nonce[1..122] || zeros(6))
    nonce[15] &= 0xC0
    let Ktop = self.hashOperation(nonce.slice)!

    /// Stretch = Ktop || (Ktop[1..64] xor Ktop[9..72])
    let Stretch = Ktop + xor(Ktop[0..<8], Ktop[1..<9])

    /// Offset_0 = Stretch[1+bottom..128+bottom]
    var offsetMAIN_0 = Array<UInt8>(repeating: 0, count: blockSize)
    let bits = bottom % 8
    let bytes = Int(bottom / 8)
    if bits == 0 {
      offsetMAIN_0[0..<blockSize] = Stretch[bytes..<(bytes + blockSize)]
    } else {
      for i in 0..<self.blockSize {
        let b1 = Stretch[bytes + i]
        let b2 = Stretch[bytes + i + 1]
        offsetMAIN_0[i] = ((b1 << bits) | (b2 >> (8 - bits)))
      }
    }

    self.mainBlockCount = 0
    self.offsetMain = Array<UInt8>(offsetMAIN_0.slice)
    self.checksum = Array<UInt8>(repeating: 0, count: self.blockSize) /// Checksum_0 = zeros(128)
  }

  /// L_i = double(L_{i-1}) for every integer i > 0
  func getLSub(_ n: Int) -> Array<UInt8> {
    while n >= self.l.count {
      self.l.append(double(self.l.last!))
    }
    return self.l[n]
  }

  func computeTag() -> Array<UInt8> {

    let sum = self.hashAAD()

    ///  Tag = ENCIPHER(K, Checksum_* xor Offset_* xor L_$) xor HASH(K,A)
    return xor(self.hashOperation(xor(xor(self.checksum, self.offsetMain).slice, self.lDollar))!, sum)
  }

  func hashAAD() -> Array<UInt8> {
    var sum = Array<UInt8>(repeating: 0, count: blockSize)

    guard let aad = self.aad else {
      return sum
    }

    var offset = Array<UInt8>(repeating: 0, count: blockSize)
    var blockCount: UInt64 = 1
    for aadBlock in aad.batched(by: self.blockSize) {

      if aadBlock.count == self.blockSize {

        /// Offset_i = Offset_{i-1} xor L_{ntz(i)}
        offset = xor(offset, self.getLSub(ntz(blockCount)))

        /// Sum_i = Sum_{i-1} xor ENCIPHER(K, A_i xor Offset_i)
        sum = xor(sum, self.hashOperation(xor(aadBlock, offset))!)
      } else {
        if !aadBlock.isEmpty {

          /// Offset_* = Offset_m xor L_*
          offset = xor(offset, self.lAsterisk)

          /// CipherInput = (A_* || 1 || zeros(127-bitlen(A_*))) xor Offset_*
          let cipherInput: Array<UInt8> = xor(extend(aadBlock, size: blockSize), offset)

          /// Sum = Sum_m xor ENCIPHER(K, CipherInput)
          sum = xor(sum, self.hashOperation(cipherInput.slice)!)
        }
      }
      blockCount += 1
    }

    return sum
  }

  func encrypt(block plaintext: ArraySlice<UInt8>) -> Array<UInt8> {

    if plaintext.count == self.blockSize {
      return self.processBlock(block: plaintext, forEncryption: true)
    } else {
      return self.processFinalBlock(block: plaintext, forEncryption: true)
    }
  }

  func finalize(encrypt ciphertext: ArraySlice<UInt8>) throws -> ArraySlice<UInt8> {

    let tag = self.computeTag()

    self.didCalculateTag?(tag)

    switch self.mode {
      case .combined:
        return ciphertext + tag
      case .detached:
        return ciphertext
    }
  }

  func decrypt(block ciphertext: ArraySlice<UInt8>) -> Array<UInt8> {

    if ciphertext.count == self.blockSize {
      return self.processBlock(block: ciphertext, forEncryption: false)
    } else {
      return self.processFinalBlock(block: ciphertext, forEncryption: false)
    }
  }

  func finalize(decrypt plaintext: ArraySlice<UInt8>) throws -> ArraySlice<UInt8> {
    // do nothing
    plaintext
  }

  private func processBlock(block: ArraySlice<UInt8>, forEncryption: Bool) -> Array<UInt8> {

    /*
     * OCB-ENCRYPT/OCB-DECRYPT: Process any whole blocks
     */

    self.mainBlockCount += 1

    /// Offset_i = Offset_{i-1} xor L_{ntz(i)}
    self.offsetMain = xor(self.offsetMain, self.getLSub(ntz(self.mainBlockCount)))

    /// C_i = Offset_i xor ENCIPHER(K, P_i xor Offset_i)
    /// P_i = Offset_i xor DECIPHER(K, C_i xor Offset_i)
    var mainBlock = Array<UInt8>(block)
    mainBlock = xor(mainBlock, offsetMain)
    mainBlock = self.cipherOperation(mainBlock.slice)!
    mainBlock = xor(mainBlock, self.offsetMain)

    /// Checksum_i = Checksum_{i-1} xor P_i
    if forEncryption {
      self.checksum = xor(self.checksum, block)
    } else {
      self.checksum = xor(self.checksum, mainBlock)
    }

    return mainBlock
  }

  private func processFinalBlock(block: ArraySlice<UInt8>, forEncryption: Bool) -> Array<UInt8> {

    let out: Array<UInt8>

    if block.isEmpty {
      /// C_* = <empty string>
      /// P_* = <empty string>
      out = []

    } else {

      /// Offset_* = Offset_m xor L_*
      self.offsetMain = xor(self.offsetMain, self.lAsterisk)

      /// Pad = ENCIPHER(K, Offset_*)
      let Pad = self.hashOperation(self.offsetMain.slice)!

      /// C_* = P_* xor Pad[1..bitlen(P_*)]
      /// P_* = C_* xor Pad[1..bitlen(C_*)]
      out = xor(block, Pad[0..<block.count])

      /// Checksum_* = Checksum_m xor (P_* || 1 || zeros(127-bitlen(P_*)))
      let plaintext = forEncryption ? block : out.slice
      self.checksum = xor(self.checksum, extend(plaintext, size: self.blockSize))
    }
    return out
  }

  // The authenticated decryption operation has five inputs: K, IV , C, A, and T. It has only a single
  // output, either the plaintext value P or a special symbol FAIL that indicates that the inputs are not
  // authentic.
  @discardableResult
  func willDecryptLast(bytes ciphertext: ArraySlice<UInt8>) throws -> ArraySlice<UInt8> {
    // Validate tag
    switch self.mode {
      case .combined:
        // overwrite expectedTag property used later for verification
        self.expectedTag = Array(ciphertext.suffix(self.tagLength))
        return ciphertext[ciphertext.startIndex..<ciphertext.endIndex.advanced(by: -Swift.min(tagLength, ciphertext.count))]
      case .detached:
        return ciphertext
    }
  }

  func didDecryptLast(bytes plaintext: ArraySlice<UInt8>) throws -> ArraySlice<UInt8> {
    // Calculate MAC tag.
    let computedTag = self.computeTag()

    // Validate tag
    guard let expectedTag = self.expectedTag, computedTag == expectedTag else {
      throw OCB.Error.fail
    }

    return plaintext
  }
}

// MARK: - Local utils

private func ntz(_ x: UInt64) -> Int {
  if x == 0 {
    return 64
  }

  var xv = x
  var n = 0
  while (xv & 1) == 0 {
    n += 1
    xv = xv >> 1
  }
  return n
}

private func double(_ block: Array<UInt8>) -> Array<UInt8> {
  var ( carry, result) = shiftLeft(block)

  /*
   * NOTE: This construction is an attempt at a constant-time implementation.
   */
  result[15] ^= (0x87 >> ((1 - carry) << 3))

  return result
}

private func shiftLeft(_ block: Array<UInt8>) -> (UInt8, Array<UInt8>) {
  var output = Array<UInt8>(repeating: 0, count: block.count)

  var bit: UInt8 = 0

  for i in 0..<block.count {
    let b = block[block.count - 1 - i]
    output[block.count - 1 - i] = ((b << 1) | bit)
    bit = (b >> 7) & 1
  }
  return (bit, output)
}

private func extend(_ block: ArraySlice<UInt8>, size: Int) -> Array<UInt8> {
  var output = Array<UInt8>(repeating: 0, count: size)
  output[0..<block.count] = block
  output[block.count] |= 0x80
  return output
}
