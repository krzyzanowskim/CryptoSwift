//
//  Collection+Extension.swift
//  CryptoSwift
//
//  Copyright (C) 2014-2017 Krzyżanowski <marcin@krzyzanowskim.com>
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
extension Collection where Self.Iterator.Element == UInt8, Self.Index == Int {

    func toUInt32Array() -> Array<UInt32> {
        let count = self.count
        var result = Array<UInt32>()
        result.reserveCapacity(16)
        for idx in stride(from: self.startIndex, to: self.endIndex, by: 4) {
            var val: UInt32 = 0
            val |= count > 3 ? UInt32(self[idx.advanced(by: 3)]) << 24 : 0
            val |= count > 2 ? UInt32(self[idx.advanced(by: 2)]) << 16 : 0
            val |= count > 1 ? UInt32(self[idx.advanced(by: 1)]) << 8 : 0
            val |= count > 0 ? UInt32(self[idx]) : 0
            result.append(val)
        }

        return result
    }

    func toUInt64Array() -> Array<UInt64> {
        let count = self.count
        var result = Array<UInt64>()
        result.reserveCapacity(32)
        for idx in stride(from: self.startIndex, to: self.endIndex, by: 8) {
            var val: UInt64 = 0
            val |= count > 7 ? UInt64(self[idx.advanced(by: 7)]) << 56 : 0
            val |= count > 6 ? UInt64(self[idx.advanced(by: 6)]) << 48 : 0
            val |= count > 5 ? UInt64(self[idx.advanced(by: 5)]) << 40 : 0
            val |= count > 4 ? UInt64(self[idx.advanced(by: 4)]) << 32 : 0
            val |= count > 3 ? UInt64(self[idx.advanced(by: 3)]) << 24 : 0
            val |= count > 2 ? UInt64(self[idx.advanced(by: 2)]) << 16 : 0
            val |= count > 1 ? UInt64(self[idx.advanced(by: 1)]) << 8 : 0
            val |= count > 0 ? UInt64(self[idx.advanced(by: 0)]) << 0 : 0
            result.append(val)
        }

        return result
    }

    /// Initialize integer from array of bytes. Caution: may be slow!
    @available(*, deprecated: 0.6.0, message: "Dont use it. Too generic to be fast")
    func toInteger<T>() -> T where T: FixedWidthInteger {
        if self.count == 0 {
            return 0
        }

        let size = MemoryLayout<T>.size
        var bytes = self.reversed() // FIXME: check it this is equivalent of Array(...)
        if bytes.count < size {
            let paddingCount = size - bytes.count
            if (paddingCount > 0) {
                bytes += Array<UInt8>(repeating: 0, count: paddingCount)
            }
        }

        if size == 1 {
            return T(truncatingIfNeeded: UInt64(bytes[0]))
        }

        var result: T = 0
        for byte in bytes.reversed() {
            result = result << 8 | T(byte)
        }
        return result
    }
}
