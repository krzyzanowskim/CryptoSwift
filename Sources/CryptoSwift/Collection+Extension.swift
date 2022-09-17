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
extension Collection where Self.Element == UInt8, Self.Index == Int {
  // Big endian order
  @inlinable
  func toUInt32Array() -> Array<UInt32> {
    guard !isEmpty else {
      return []
    }

    let c = strideCount(from: startIndex, to: endIndex, by: 4)
    return Array<UInt32>(unsafeUninitializedCapacity: c) { buf, count in
      var counter = 0
      for idx in stride(from: startIndex, to: endIndex, by: 4) {
        let val = UInt32(bytes: self, fromIndex: idx).bigEndian
        buf[counter] = val
        counter += 1
      }
      count = counter
      assert(counter == c)
    }
  }

  // Big endian order
  @inlinable
  func toUInt64Array() -> Array<UInt64> {
    guard !isEmpty else {
      return []
    }

    let c = strideCount(from: startIndex, to: endIndex, by: 8)
    return Array<UInt64>(unsafeUninitializedCapacity: c) { buf, count in
      var counter = 0
      for idx in stride(from: startIndex, to: endIndex, by: 8) {
        let val = UInt64(bytes: self, fromIndex: idx).bigEndian
        buf[counter] = val
        counter += 1
      }
      count = counter
      assert(counter == c)
    }
  }
}

@usableFromInline
func strideCount(from: Int, to: Int, by: Int) -> Int {
    let count = to - from
    return count / by + (count % by > 0 ? 1 : 0)
}
