//
//  UInt16+Extension.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 06/08/16.
//  Copyright © 2016 Marcin Krzyzanowski. All rights reserved.
//

/** array of bytes */
extension UInt16 {

    @_specialize(ArraySlice<UInt8>)
    init<T: Collection>(bytes: T) where T.Iterator.Element == UInt8, T.Index == Int {
        self = UInt16(bytes: bytes, fromIndex: bytes.startIndex)
    }

    @_specialize(ArraySlice<UInt8>)
    init<T: Collection>(bytes: T, fromIndex index: T.Index) where T.Iterator.Element == UInt8, T.Index == Int {
        let val0 = UInt16(bytes[index.advanced(by: 0)]) << 8
        let val1 = UInt16(bytes[index.advanced(by: 1)])

        self = val0 | val1
    }

    func bytes(totalBytes: Int = MemoryLayout<UInt16>.size) -> Array<UInt8> {
        return arrayOfBytes(value: self, length: totalBytes)
    }
}
