//
//  CryptoSwift
//
//  Copyright (C) 2014-2017 Marcin Krzyżanowski <marcin@krzyzanowskim.com>
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

//  Counter (CTR)

public struct CTR: StreamMode {
  public enum Error: Swift.Error {
    /// Invalid IV
    case invalidInitializationVector
  }

  public let options: BlockModeOption = [.initializationVectorRequired, .useEncryptToDecrypt]
  private let iv: Array<UInt8>
  private let counter: Int
  public let customBlockSize: Int? = nil

  public init(iv: Array<UInt8>, counter: Int = 0) {
    self.iv = iv
    self.counter = counter
  }

  public func worker(blockSize: Int, cipherOperation: @escaping CipherOperationOnBlock, encryptionOperation: @escaping CipherOperationOnBlock) throws -> CipherModeWorker {
    if self.iv.count != blockSize {
      throw Error.invalidInitializationVector
    }

    return CTRModeWorker(blockSize: blockSize, iv: self.iv.slice, counter: self.counter, cipherOperation: cipherOperation)
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

struct CTRModeWorker: StreamModeWorker, SeekableModeWorker, CounterModeWorker {
  typealias Counter = CTRCounter

  final class CTRCounter {
    private let constPrefix: Array<UInt8>
    private var value: UInt64
    //TODO: make it an updatable value, computing is too slow
    var bytes: Array<UInt8> {
      self.constPrefix + self.value.bytes()
    }

    @inlinable
    init(_ initialValue: Array<UInt8>) {
      let halfIndex = initialValue.startIndex.advanced(by: initialValue.count / 2)
      self.constPrefix = Array(initialValue[initialValue.startIndex..<halfIndex])

      let suffixBytes = Array(initialValue[halfIndex...])
      value = UInt64(bytes: suffixBytes)
    }

    convenience init(nonce: Array<UInt8>, startAt index: Int) {
      self.init(buildCounterValue(nonce, counter: UInt64(index)))
    }

    static func += (lhs: CTRCounter, rhs: Int) {
      lhs.value += UInt64(rhs)
    }
  }

  let cipherOperation: CipherOperationOnBlock
  let additionalBufferSize: Int = 0
  let iv: Array<UInt8>
  var counter: CTRCounter

  private let blockSize: Int

  // The same keystream is used for the block length plaintext
  // As new data is added, keystream suffix is used to xor operation.
  private var keystream: Array<UInt8>
  private var keystreamPosIdx = 0

  init(blockSize: Int, iv: ArraySlice<UInt8>, counter: Int, cipherOperation: @escaping CipherOperationOnBlock) {
    self.cipherOperation = cipherOperation
    self.blockSize = blockSize
    self.iv = Array(iv)

    // the first keystream is calculated from the nonce = initial value of counter
    self.counter = CTRCounter(nonce: Array(iv), startAt: counter)
    self.keystream = Array(cipherOperation(self.counter.bytes.slice)!)
  }

  @inlinable
  mutating func seek(to position: Int) throws {
    let offset = position % self.blockSize
    self.counter = CTRCounter(nonce: self.iv, startAt: position / self.blockSize)
    self.keystream = Array(self.cipherOperation(self.counter.bytes.slice)!)
    self.keystreamPosIdx = offset
  }

  // plaintext is at most blockSize long
  @inlinable
  mutating func encrypt(block plaintext: ArraySlice<UInt8>) -> Array<UInt8> {
    var result = Array<UInt8>(reserveCapacity: plaintext.count)

    var processed = 0
    while processed < plaintext.count {
      // Update keystream
      if self.keystreamPosIdx == self.blockSize {
        self.counter += 1
        self.keystream = Array(self.cipherOperation(self.counter.bytes.slice)!)
        self.keystreamPosIdx = 0
      }

      let xored: Array<UInt8> = xor(plaintext[plaintext.startIndex.advanced(by: processed)...], keystream[keystreamPosIdx...])
      keystreamPosIdx += xored.count
      processed += xored.count
      result += xored
    }

    return result
  }

  mutating func decrypt(block ciphertext: ArraySlice<UInt8>) -> Array<UInt8> {
    self.encrypt(block: ciphertext)
  }
}

private func buildCounterValue(_ iv: Array<UInt8>, counter: UInt64) -> Array<UInt8> {
  let noncePartLen = iv.count / 2
  let noncePrefix = iv[iv.startIndex..<iv.startIndex.advanced(by: noncePartLen)]
  let nonceSuffix = iv[iv.startIndex.advanced(by: noncePartLen)..<iv.startIndex.advanced(by: iv.count)]
  let c = UInt64(bytes: nonceSuffix) + counter
  return noncePrefix + c.bytes()
}
