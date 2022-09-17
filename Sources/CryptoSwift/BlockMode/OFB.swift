//
//  CryptoSwift
//
//  Copyright (C) 2014-2022 Marcin Krzyżanowski <marcin@krzyzanowskim.com>
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

// Output Feedback (OFB)
//

public struct OFB: BlockMode {
  public enum Error: Swift.Error {
    /// Invalid IV
    case invalidInitializationVector
  }

  public let options: BlockModeOption = [.initializationVectorRequired, .useEncryptToDecrypt]
  private let iv: Array<UInt8>
  public let customBlockSize: Int? = nil

  public init(iv: Array<UInt8>) {
    self.iv = iv
  }

  public func worker(blockSize: Int, cipherOperation: @escaping CipherOperationOnBlock, encryptionOperation: @escaping CipherOperationOnBlock) throws -> CipherModeWorker {
    if self.iv.count != blockSize {
      throw Error.invalidInitializationVector
    }

    return OFBModeWorker(blockSize: blockSize, iv: self.iv.slice, cipherOperation: cipherOperation)
  }
}

struct OFBModeWorker: BlockModeWorker {
  let cipherOperation: CipherOperationOnBlock
  let blockSize: Int
  let additionalBufferSize: Int = 0
  private let iv: ArraySlice<UInt8>
  private var prev: ArraySlice<UInt8>?

  init(blockSize: Int, iv: ArraySlice<UInt8>, cipherOperation: @escaping CipherOperationOnBlock) {
    self.blockSize = blockSize
    self.iv = iv
    self.cipherOperation = cipherOperation
  }

  @inlinable
  mutating func encrypt(block plaintext: ArraySlice<UInt8>) -> Array<UInt8> {
    guard let ciphertext = cipherOperation(prev ?? iv) else {
      return Array(plaintext)
    }
    self.prev = ciphertext.slice
    return xor(plaintext, ciphertext)
  }

  @inlinable
  mutating func decrypt(block ciphertext: ArraySlice<UInt8>) -> Array<UInt8> {
    guard let decrypted = cipherOperation(prev ?? iv) else {
      return Array(ciphertext)
    }
    let plaintext: Array<UInt8> = xor(decrypted, ciphertext)
    prev = decrypted.slice
    return plaintext
  }
}
