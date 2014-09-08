//
//  UInt64Extension.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 02/09/14.
//  Copyright (c) 2014 Marcin Krzyzanowski. All rights reserved.
//

import Foundation

/** array of bytes */
extension UInt64 {
    public func bytes(_ totalBytes: Int = sizeof(UInt64)) -> [Byte] {
        return arrayOfBytes(self, length: totalBytes)
    }

    public static func withBytes(bytes: Slice<Byte>) -> UInt64 {
        return UInt64.withBytes(Array(bytes))
    }

    /** Int with array bytes (little-endian) */
    public static func withBytes(bytes: [Byte]) -> UInt64 {
        return integerWithBytes(bytes)
    }
}