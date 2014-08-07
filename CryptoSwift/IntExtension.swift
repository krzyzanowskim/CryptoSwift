//
//  IntExtension.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 07/08/14.
//  Copyright (c) 2014 Marcin Krzyzanowski. All rights reserved.
//

import Foundation

extension Int {
    
    /** Array of bytes with optional padding (little-endian) */
    public func toBytes(_ totalBytes: Int = sizeof(Int)) -> Array<Byte> {
        var bytes:[Byte] = [Byte](count: totalBytes, repeatedValue: 0)
        
        // first convert to data
        let data = NSData(bytes: [self] as [Int], length: totalBytes)
        
        // then convert back to bytes, byte by byte
        for i in 0..<Swift.min(sizeof(Int),totalBytes) {
            var b:Byte = 0
            data.getBytes(&b, range: NSRange(location: i,length: 1))
            bytes[totalBytes - 1 - i] = b
        }
        return bytes
    }
    
    /** Int with array bytes (little-endian) */
    public static func withBytes(bytes: Array<Byte>) -> Int {
        var i:Int = 0
        let totalBytes = Swift.min(bytes.count, sizeof(Int))
        
        // get slice of Int
        let start = Swift.max(bytes.count - sizeof(Int),0)
        var intarr = Array<Byte>(bytes[start..<(start + totalBytes)])
        // extend to Int size if necessary
        while (intarr.count < sizeof(Int)) {
            intarr.insert(0 as Byte, atIndex: 0)
        }
        
        let data = NSData(bytes: intarr, length: intarr.count)
        data.getBytes(&i, length: sizeof(Int));
        return i.byteSwapped
    }
}