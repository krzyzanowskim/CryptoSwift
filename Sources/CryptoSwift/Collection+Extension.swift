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
extension Collection where Self.Element == UInt8, Self.Index == Int {

    // Big endian order
    func toUInt32Array() -> Array<UInt32> {
        if isEmpty {
            return []
        }

        var result = Array<UInt32>(reserveCapacity: 16)
        for idx in stride(from: startIndex, to: endIndex, by: 4) {
            let val = UInt32(bytes: self, fromIndex: idx).bigEndian
            result.append(val)
        }

        return result
    }

    // Big endian order
    func toUInt64Array() -> Array<UInt64> {
        if isEmpty {
            return []
        }

        var result = Array<UInt64>(reserveCapacity: 32)
        for idx in stride(from: startIndex, to: endIndex, by: 8) {
            let val = UInt64(bytes: self, fromIndex: idx).bigEndian
            result.append(val)
        }

        return result
    }
}
