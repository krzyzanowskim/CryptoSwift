//
//  PKCS7.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 27/12/14.
//  Copyright (c) 2014 Marcin Krzyzanowski. All rights reserved.
//

import Foundation

public struct PKCS7 {
    let data:NSData
    
    public init(data:NSData) {
        self.data = data;
    }
    
    public func addPadding(blockSizeBytes:UInt8) -> NSData {
        var padding = blockSizeBytes - (data.length % Int(blockSizeBytes))
        var withPadding = NSMutableData(data: data)
        if (padding == 0) {
            // If the original data is a multiple of N bytes, then an extra block of bytes with value N is added.
            for i in 0..<blockSizeBytes {
                withPadding.appendBytes([blockSizeBytes])
            }
        } else {
            // The value of each added byte is the number of bytes that are added
            for i in 0..<padding {
                withPadding.appendBytes([padding])
            }
        }
        return withPadding
    }
    
    public func removePadding() -> NSData {
        var padding:Byte = 0
        data.subdataWithRange(NSRange(location: data.length - 1, length: 1)).getBytes(&padding, length: 1)
        
        if padding >= 1 {
            return data.subdataWithRange(NSRange(location: 0, length: data.length - Int(padding)))
        }
        return data
    }
}
