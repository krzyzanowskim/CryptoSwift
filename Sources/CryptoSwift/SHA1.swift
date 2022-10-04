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

public final class SHA1: DigestType {

  @usableFromInline
  static let digestLength: Int = 20 // 160 / 8

  @usableFromInline
  static let blockSize: Int = 64

  @usableFromInline
  static let hashInitialValue: ContiguousArray<UInt32> = [0x67452301, 0xefcdab89, 0x98badcfe, 0x10325476, 0xc3d2e1f0]

  @usableFromInline
  var accumulated = Array<UInt8>()

  @usableFromInline
  var processedBytesTotalCount: Int = 0

  @usableFromInline
  var accumulatedHash: ContiguousArray<UInt32> = SHA1.hashInitialValue

  public init() {
  }

  @inlinable
  public func calculate(for bytes: Array<UInt8>) -> Array<UInt8> {
    do {
      return try update(withBytes: bytes.slice, isLast: true)
    } catch {
      return []
    }
  }

  public func callAsFunction(_ bytes: Array<UInt8>) -> Array<UInt8> {
    calculate(for: bytes)
  }

  @usableFromInline
  func process(block chunk: ArraySlice<UInt8>, currentHash hh: inout ContiguousArray<UInt32>) {
    // break chunk into sixteen 32-bit words M[j], 0 ≤ j ≤ 15, big-endian
    // Extend the sixteen 32-bit words into eighty 32-bit words:
    let M = UnsafeMutablePointer<UInt32>.allocate(capacity: 80)
    M.initialize(repeating: 0, count: 80)
    defer {
      M.deinitialize(count: 80)
      M.deallocate()
    }

    for x in 0..<80 {
      switch x {
        case 0...15:
          let start = chunk.startIndex.advanced(by: x * 4) // * MemoryLayout<UInt32>.size
          M[x] = UInt32(bytes: chunk, fromIndex: start)
        default:
          M[x] = rotateLeft(M[x - 3] ^ M[x - 8] ^ M[x - 14] ^ M[x - 16], by: 1)
      }
    }

    var A = hh[0]
    var B = hh[1]
    var C = hh[2]
    var D = hh[3]
    var E = hh[4]

    // Main loop
    for j in 0...79 {
      var f: UInt32 = 0
      var k: UInt32 = 0

      switch j {
        case 0...19:
          f = (B & C) | ((~B) & D)
          k = 0x5a827999
        case 20...39:
          f = B ^ C ^ D
          k = 0x6ed9eba1
        case 40...59:
          f = (B & C) | (B & D) | (C & D)
          k = 0x8f1bbcdc
        case 60...79:
          f = B ^ C ^ D
          k = 0xca62c1d6
        default:
          break
      }

      let temp = rotateLeft(A, by: 5) &+ f &+ E &+ M[j] &+ k
      E = D
      D = C
      C = rotateLeft(B, by: 30)
      B = A
      A = temp
    }

    hh[0] = hh[0] &+ A
    hh[1] = hh[1] &+ B
    hh[2] = hh[2] &+ C
    hh[3] = hh[3] &+ D
    hh[4] = hh[4] &+ E
  }
}

extension SHA1: Updatable {
  @discardableResult @inlinable
  public func update(withBytes bytes: ArraySlice<UInt8>, isLast: Bool = false) throws -> Array<UInt8> {
    self.accumulated += bytes

    if isLast {
      let lengthInBits = (processedBytesTotalCount + self.accumulated.count) * 8
      let lengthBytes = lengthInBits.bytes(totalBytes: 64 / 8) // A 64-bit representation of b

      // Step 1. Append padding
      bitPadding(to: &self.accumulated, blockSize: SHA1.blockSize, allowance: 64 / 8)

      // Step 2. Append Length a 64-bit representation of lengthInBits
      self.accumulated += lengthBytes
    }

    var processedBytes = 0
    for chunk in self.accumulated.batched(by: SHA1.blockSize) {
      if isLast || (self.accumulated.count - processedBytes) >= SHA1.blockSize {
        self.process(block: chunk, currentHash: &self.accumulatedHash)
        processedBytes += chunk.count
      }
    }
    self.accumulated.removeFirst(processedBytes)
    self.processedBytesTotalCount += processedBytes

    // output current hash
    var result = Array<UInt8>(repeating: 0, count: SHA1.digestLength)
    var pos = 0
    for idx in 0..<self.accumulatedHash.count {
      let h = self.accumulatedHash[idx]
      result[pos + 0] = UInt8((h >> 24) & 0xff)
      result[pos + 1] = UInt8((h >> 16) & 0xff)
      result[pos + 2] = UInt8((h >> 8) & 0xff)
      result[pos + 3] = UInt8(h & 0xff)
      pos += 4
    }

    // reset hash value for instance
    if isLast {
      self.accumulatedHash = SHA1.hashInitialValue
    }

    return result
  }
}
