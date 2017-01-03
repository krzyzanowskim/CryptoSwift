//
//  UInt32Extension.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 02/09/14.
//  Copyright (c) 2014 Marcin Krzyzanowski. All rights reserved.
//

#if os(Linux) || os(Android) || os(FreeBSD)
    import Glibc
#else
    import Darwin
#endif

protocol _UInt32Type {}
extension UInt32: _UInt32Type {}

/** array of bytes */
extension UInt32 {

    @_specialize(ArraySlice<UInt8>)
    init<T: Collection>(bytes: T) where T.Iterator.Element == UInt8, T.Index == Int {
        self = UInt32(bytes: bytes, fromIndex: bytes.startIndex)
    }

    @_specialize(ArraySlice<UInt8>)
    init<T: Collection>(bytes: T, fromIndex index: T.Index) where T.Iterator.Element == UInt8, T.Index == Int {
        let val0 = UInt32(bytes[index.advanced(by: 0)]) << 24
        let val1 = UInt32(bytes[index.advanced(by: 1)]) << 16
        let val2 = UInt32(bytes[index.advanced(by: 2)]) << 8
        let val3 = UInt32(bytes[index.advanced(by: 3)])

        self = val0 | val1 | val2 | val3
    }

    func bytes(totalBytes: Int = MemoryLayout<UInt32>.size) -> Array<UInt8> {
        return arrayOfBytes(value: self, length: totalBytes)
    }
}
