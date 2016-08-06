//
//  UInt16+Extension.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 06/08/16.
//  Copyright © 2016 Marcin Krzyzanowski. All rights reserved.
//

/** array of bytes */
extension UInt16 {
    public func bytes(totalBytes: Int = MemoryLayout<UInt16>.size) -> Array<UInt8> {
        return arrayOfBytes(value: self, length: totalBytes)
    }

    /** Int with array bytes (little-endian) */
    public static func with<T: Collection>(_ bytes: T) -> UInt32 where T.Iterator.Element == UInt8, T.Index == Int {
        return bytes.toInteger()
    }
}
