//
//  UInt64Extension.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 02/09/14.
//  Copyright (c) 2014 Marcin Krzyzanowski. All rights reserved.
//

/** array of bytes */
extension UInt64 {

    @_specialize(ArraySlice<UInt8>)
    init<T: Collection>(bytes: T) where T.Iterator.Element == UInt8, T.Index == Int {
        self = UInt64(bytes: bytes, fromIndex: bytes.startIndex)
    }

    @_specialize(ArraySlice<UInt8>)
    init<T: Collection>(bytes: T, fromIndex index: T.Index) where T.Iterator.Element == UInt8, T.Index == Int {
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
