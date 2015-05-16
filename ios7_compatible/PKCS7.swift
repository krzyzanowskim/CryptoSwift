//
//  PKCS7.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 28/02/15.
//  Copyright (c) 2015 Marcin Krzyzanowski. All rights reserved.
//
//  PKCS is a group of public-key cryptography standards devised
//  and published by RSA Security Inc, starting in the early 1990s.
//

import Foundation

public struct PKCS7: Padding {
    
    public init() {
        
    }
    
    public func add(bytes: [UInt8] , blockSize:Int) -> [UInt8] {
        var padding = UInt8(blockSize - (bytes.count % blockSize))
        var withPadding = bytes
        if (padding == 0) {
            // If the original data is a multiple of N bytes, then an extra block of bytes with value N is added.
            for i in 0..<blockSize {
                withPadding.extend([UInt8(blockSize)])
            }
        } else {
            // The value of each added byte is the number of bytes that are added
            for i in 0..<padding {
                withPadding.extend([UInt8(padding)])
            }
        }
        return withPadding
    }
    
    public func remove(bytes: [UInt8], blockSize:Int? = nil) -> [UInt8] {
        var padding = Int(bytes.last!) // last byte
        
        if padding >= 1 { //TODO: need test for that, what about empty padding
            return Array(bytes[0..<(bytes.count - padding)])
        }
        return bytes
    }
}