//
//  UInt64Extension.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 02/09/14.
//  Copyright (c) 2014 Marcin Krzyzanowski. All rights reserved.
//

/** array of bytes */
extension UInt64 {
    public func bytes(totalBytes: Int = sizeof(UInt64)) -> [UInt8] {
        return arrayOfBytes(self, length: totalBytes)
    }

    public static func withBytes(bytes: ArraySlice<UInt8>) -> UInt64 {
        return UInt64.withBytes(Array(bytes))
    }

    /** Int with array bytes (little-endian) */
    public static func withBytes(bytes: [UInt8]) -> UInt64 {
        return integerWithBytes(bytes)
    }
}