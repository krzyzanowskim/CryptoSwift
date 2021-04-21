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

#if canImport(Darwin)
import Darwin
#elseif canImport(Glibc)
import Glibc
#elseif canImport(ucrt)
import ucrt
#endif

protocol _UInt32Type {}
extension UInt32: _UInt32Type {}

/** array of bytes */
extension UInt32 {
  @_specialize(where T == ArraySlice<UInt8>)
  init<T: Collection>(bytes: T) where T.Element == UInt8, T.Index == Int {
    self = UInt32(bytes: bytes, fromIndex: bytes.startIndex)
  }

  @_specialize(where T == ArraySlice<UInt8>)
  @inlinable
  init<T: Collection>(bytes: T, fromIndex index: T.Index) where T.Element == UInt8, T.Index == Int {
    if bytes.isEmpty {
      self = 0
      return
    }

    let count = bytes.count

    let val0 = count > 0 ? UInt32(bytes[index.advanced(by: 0)]) << 24 : 0
    let val1 = count > 1 ? UInt32(bytes[index.advanced(by: 1)]) << 16 : 0
    let val2 = count > 2 ? UInt32(bytes[index.advanced(by: 2)]) << 8 : 0
    let val3 = count > 3 ? UInt32(bytes[index.advanced(by: 3)]) : 0

    self = val0 | val1 | val2 | val3
  }
}
