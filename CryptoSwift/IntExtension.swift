//
//  IntExtension.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 07/08/14.
//  Copyright (c) 2014 Marcin Krzyzanowski. All rights reserved.
//

import Foundation

extension Int {
    
    /** Array of bytes (little-endian) */
    internal func toBytes() -> Array<Byte> {
        let totalBytes = sizeof(Int)
        var bytes:[Byte] = [Byte](count: totalBytes, repeatedValue: 0)

        // first convert to data
        let data = NSData(bytes: [self] as [Int], length: totalBytes)
        
        // then convert back to bytes, byte by byte
        for i in 0..<data.length {
            var b:Byte = 0
            data.getBytes(&b, range: NSRange(location: i,length: 1))
            bytes[totalBytes - 1 - i] = b
        }
        return bytes
    }
    
    /** Int with array bytes (little-endian) */
    static func withBytes(bytes: Array<Byte>) -> Int {
        var i:Int = 0
        let totalBytes = bytes.count > sizeof(Int) ? sizeof(Int) : bytes.count;
        
        let data = NSData(bytes: bytes, length: totalBytes)
        data.getBytes(&i, length: totalBytes)
        
        return i.byteSwapped
    }
}