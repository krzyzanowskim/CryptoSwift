//
//  UInt64Extension.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 02/09/14.
//  Copyright (c) 2014 Marcin Krzyzanowski. All rights reserved.
//

/** array of bytes */
extension UInt64 {
    public func bytes(totalBytes: Int = sizeof(UInt64.self)) -> Array<UInt8> {
        return arrayOfBytes(value: self, length: totalBytes)
    }

    /** Int with array bytes (little-endian) */
    public static func with<T: Collection>(_ bytes: T) -> UInt64 where T.Iterator.Element == UInt8, T.Index == Int {
        return bytes.toInteger()
    }
}
