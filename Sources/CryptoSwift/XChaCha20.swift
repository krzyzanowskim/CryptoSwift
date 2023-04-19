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

/// XChaCha20 is a Swift implementation of the XChaCha20 stream cipher, which is an extension of the ChaCha20 cipher
/// that uses a 192-bit nonce instead of the original 64-bit nonce. XChaCha20 provides a higher security level by
/// allowing a larger number of safe random nonces, reducing the risk of nonce reuse.
///
/// For more information about the XChaCha20 algorithm, refer to the IETF draft: https://datatracker.ietf.org/doc/html/draft-irtf-cfrg-xchacha
public final class XChaCha20: BlockCipher, BlockMode {

  public enum Error: Swift.Error {
    case invalidKeyOrInitializationVector
    case notSupported
  }

  fileprivate var chacha20: ChaCha20

  // MARK: BlockCipher

  public static let blockSize = 64 // 512 / 8

  // MARK: Cipher

  public let keySize: Int

  /// Initializes a new instance of XChaCha20 with the provided key, nonce, and optional block counter.
  /// - Parameters:
  ///   - key: A 256-bit (32-byte) key for the XChaCha20 cipher.
  ///   - nonce: A 192-bit (24-byte) nonce for the XChaCha20 cipher.
  ///   - blockCounter: An optional initial block counter value, defaulting to 0.
  /// - Throws: Error.invalidKeyOrInitializationVector if the key or nonce lengths are not valid.
  public init(key: Array<UInt8>, iv nonce: Array<UInt8>, blockCounter: UInt32 = 0) throws {
    guard key.count == 32 && nonce.count == 24 else {
      throw Error.invalidKeyOrInitializationVector
    }

    self.keySize = key.count

    // From https://datatracker.ietf.org/doc/html/draft-irtf-cfrg-xchacha#section-2.3
    //  XChaCha20 can be constructed from an existing ChaCha20 implementation
    //   and HChaCha20.  All one needs to do is:
    //
    //   1.  Pass the key and the first 16 bytes of the 24-byte nonce to
    //       HChaCha20 to obtain the subkey.
    //
    //   2.  Use the subkey and remaining 8 byte nonce with ChaCha20 as normal
    //       (prefixed by 4 NUL bytes, since [RFC8439] specifies a 12-byte
    //       nonce).
    self.chacha20 = try .init(
      key: XChaCha20.hChaCha20(key: key, nonce: Array(nonce[0..<16])),
      iv: [0, 0, 0, 0] + Array(nonce[16..<24]),
      blockCounter: blockCounter
    )
  }

  // MARK: BlockMode

  /// Options specific to the block mode.
  public let options: BlockModeOption = [.none]
  /// The custom block size for the block mode, if any. XChaCha20 does not have a custom block size.
  public let customBlockSize: Int? = nil

  public func worker(blockSize: Int, cipherOperation: @escaping CipherOperationOnBlock, encryptionOperation: @escaping CipherOperationOnBlock) throws -> CipherModeWorker {
    return XChaCha20Worker(
      blockSize: blockSize,
      cipherOperation: cipherOperation,
      xChaCha20: self
    )
  }

  /// Computes the HChaCha20 function on the provided key and nonce.
  ///
  /// See: https://datatracker.ietf.org/doc/html/draft-irtf-cfrg-xchacha#section-2.2
  ///
  /// - Parameters:
  ///   - key: A 256-bit (32-byte) key.
  ///   - nonce: A 128-bit (16-byte) nonce.
  /// - Returns: A 256-bit (32-byte) derived key.
  static func hChaCha20(key: [UInt8], nonce: [UInt8]) -> [UInt8] {
    precondition(key.count == 32)
    precondition(nonce.count == 16)

    // HChaCha20 is initialized the same way as the ChaCha cipher, except
    // that HChaCha20 uses a 128-bit nonce and has no counter.  Instead, the
    // block counter is replaced by the first 32 bits of the nonce.

    var state = Array<UInt32>(repeating: 0, count: 16)

    state[0] = 0x61707865
    state[1] = 0x3320646e
    state[2] = 0x79622d32
    state[3] = 0x6b206574
    for i in 0..<8 {
      state[4 + i] = UInt32(bytes: key[i * 4..<(i + 1) * 4]).bigEndian
    }
    for i in 0..<4 {
      state[12 + i] = UInt32(bytes: nonce[i * 4..<(i + 1) * 4]).bigEndian
    }

    // After initialization, proceed through the ChaCha rounds as usual.

    for _ in 1...10 {
      self.innerBlock(&state)
    }

    // Once the 20 ChaCha rounds have been completed, the first 128 bits and
    // last 128 bits of the ChaCha state (both little-endian) are
    // concatenated, and this 256-bit subkey is returned.

    var output = Array<UInt8>()
    for i in 0..<4 {
      output += state[i].bigEndian.bytes()
    }
    for i in 0..<4 {
      output += state[12 + i].bigEndian.bytes()
    }

    return output
  }

  /// Performs the "quarter round" operation on the provided state at the specified indices.
  /// - Parameters:
  ///   - state: The state on which to perform the operation.
  ///   - a: The index of the first element in the state.
  ///   - b: The index of the second element in the state.
  ///   - c: The index of the third element in the state.
  ///   - d: The index of the fourth element in the state.
  static func qRound(_ state: inout [UInt32], _ a: Int, _ b: Int, _ c: Int, _ d: Int) {
    state[a] = state[a] &+ state[b]
    state[d] ^= state[a]
    state[d] = (state[d] << 16) | (state[d] >> 16)
    state[c] = state[c] &+ state[d]
    state[b] ^= state[c]
    state[b] = (state[b] << 12) | (state[b] >> 20)
    state[a] = state[a] &+ state[b]
    state[d] ^= state[a]
    state[d] = (state[d] << 8) | (state[d] >> 24)
    state[c] = state[c] &+ state[d]
    state[b] ^= state[c]
    state[b] = (state[b] << 7) | (state[b] >> 25)
  }

  /// Performs the inner block operation on the provided state.
  /// - Parameter state: The state on which to perform the operation.
  static func innerBlock(_ state: inout [UInt32]) {
    self.qRound(&state, 0, 4, 8, 12)
    self.qRound(&state, 1, 5, 9, 13)
    self.qRound(&state, 2, 6, 10, 14)
    self.qRound(&state, 3, 7, 11, 15)
    self.qRound(&state, 0, 5, 10, 15)
    self.qRound(&state, 1, 6, 11, 12)
    self.qRound(&state, 2, 7, 8, 13)
    self.qRound(&state, 3, 4, 9, 14)
  }
}

// MARK: Cipher

extension XChaCha20: Cipher {
  public func encrypt(_ bytes: ArraySlice<UInt8>) throws -> Array<UInt8> {
    try self.chacha20.encrypt(bytes)
  }

  public func decrypt(_ bytes: ArraySlice<UInt8>) throws -> Array<UInt8> {
    try self.encrypt(bytes)
  }
}

// MARK: Cryptors

extension XChaCha20: Cryptors {

  public func makeEncryptor() throws -> Cryptor & Updatable {
    return try BlockEncryptor(
      blockSize: XChaCha20.blockSize,
      padding: .noPadding,
      self.worker(
        blockSize: XChaCha20.blockSize,
        cipherOperation: { _ in nil },
        encryptionOperation: { _ in nil }
      )
    )
  }

  public func makeDecryptor() throws -> Cryptor & Updatable {
    return try BlockDecryptor(
      blockSize: XChaCha20.blockSize,
      padding: .noPadding,
      self.worker(
        blockSize: XChaCha20.blockSize,
        cipherOperation: { _ in nil },
        encryptionOperation: { _ in nil }
      )
    )
  }
}

class XChaCha20Worker: CipherModeWorker {
  let blockSize: Int
  let cipherOperation: CipherOperationOnBlock
  let xChaCha20: XChaCha20

  init(blockSize: Int, cipherOperation: @escaping CipherOperationOnBlock, xChaCha20: XChaCha20) {
    self.blockSize = blockSize
    self.cipherOperation = cipherOperation
    self.xChaCha20 = xChaCha20
  }

  var additionalBufferSize: Int {
    return 0
  }

  func encrypt(block plaintext: ArraySlice<UInt8>) -> Array<UInt8> {
    return (try? self.xChaCha20.encrypt(plaintext)) ?? .init()
  }

  func decrypt(block ciphertext: ArraySlice<UInt8>) -> Array<UInt8> {
    return (try? self.xChaCha20.decrypt(ciphertext)) ?? .init()
  }
}
