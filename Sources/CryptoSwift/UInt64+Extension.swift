//
//  UInt64Extension.swift
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

/** array of bytes */
extension UInt64 {

//    init<T: Collection>(bytes: T) where T.Iterator.Element == UInt8, T.Index == Int {
//        self = 0
//    }

    @_specialize(where T == ArraySlice<UInt8>)
    init<T: Collection>(bytes: T) where T.Iterator.Element == UInt8, T.IndexDistance == Int, T.Index == Int {
        self = UInt64(bytes: bytes, fromIndex: bytes.startIndex)
    }

    @_specialize(where T == ArraySlice<UInt8>)
    init<T: Collection>(bytes: T, fromIndex index: T.Index) where T.Iterator.Element == UInt8, T.IndexDistance == Int, T.Index == Int {
        let val0 = UInt64(bytes[index.advanced(by: 0)]) << 56
        let val1 = UInt64(bytes[index.advanced(by: 1)]) << 48
        let val2 = UInt64(bytes[index.advanced(by: 2)]) << 40
        let val3 = UInt64(bytes[index.advanced(by: 3)]) << 32
        let val4 = UInt64(bytes[index.advanced(by: 4)]) << 24
        let val5 = UInt64(bytes[index.advanced(by: 5)]) << 16
        let val6 = UInt64(bytes[index.advanced(by: 6)]) << 8
        let val7 = UInt64(bytes[index.advanced(by: 7)])

        self = val0 | val1 | val2 | val3 | val4 | val5 | val6 | val7
    }

    func bytes(totalBytes: Int = MemoryLayout<UInt64>.size) -> Array<UInt8> {
        return arrayOfBytes(value: self, length: totalBytes)
    }
}
