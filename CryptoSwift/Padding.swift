//
//  Padding.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 27/02/15.
//  Copyright (c) 2015 Marcin Krzyzanowski. All rights reserved.
//

import Foundation

public protocol Padding {
    static func add(data: NSData, blockSize:Int) -> NSData;
    static func remove(data: NSData, blockSize:Int?) -> NSData;
}

public struct PKCS7: Padding {
    
    public static func add(data: NSData , blockSize:Int) -> NSData {
        var padding = UInt8(blockSize) - (UInt8(data.length) % UInt8(blockSize))
        var withPadding = NSMutableData(data: data)
        if (padding == 0) {
            // If the original data is a multiple of N bytes, then an extra block of bytes with value N is added.
            for i in 0..<blockSize {
                withPadding.appendBytes([UInt8(blockSize)])
            }
        } else {
            // The value of each added byte is the number of bytes that are added
            for i in 0..<padding {
                withPadding.appendBytes([padding])
            }
        }
        return withPadding
    }
    
    public static func remove(data: NSData, blockSize:Int? = nil) -> NSData
    {
        var padding:UInt8 = 0
        data.subdataWithRange(NSRange(location: data.length - 1, length: 1)).getBytes(&padding, length: 1)
        
        if padding >= 1 {
            return data.subdataWithRange(NSRange(location: 0, length: data.length - Int(padding)))
        }
        return data
    }
}