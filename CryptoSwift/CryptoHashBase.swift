//
//  Hash.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 17/08/14.
//  Copyright (c) 2014 Marcin Krzyzanowski. All rights reserved.
//

import Foundation

public class CryptoHashBase {
    
    internal var message: NSData
    
    //MARK: Public
    
    public init(_ message: NSData) {
        self.message = message
    }
    
    /** Common part for hash calculation. Prepare header data. */
    internal func prepare() -> NSMutableData {
        var tmpMessage: NSMutableData = NSMutableData(data: self.message)
        
        // Step 1. Append Padding Bits
        tmpMessage.appendBytes([0x80]) // append one bit (Byte with one bit) to message
        
        // append "0" bit until message length in bits ≡ 448 (mod 512)
        while tmpMessage.length % 64 != 56 {
            tmpMessage.appendBytes([0x00])
        }
        
        return tmpMessage
    }
    
    internal func reverseByte(value: UInt32) -> UInt32 {
        // rdar://18060945 - not working since Xcode6-Beta6, need to split in two variables
        // return = ((value & 0x000000FF) << 24) | ((value & 0x0000FF00) << 8) | ((value & 0x00FF0000) >> 8)  | ((value & 0xFF000000) >> 24);
        
        // workaround
        var tmp1 = ((value & 0x000000FF) << 24) | ((value & 0x0000FF00) << 8)
        var tmp2 = ((value & 0x00FF0000) >> 8)  | ((value & 0xFF000000) >> 24)
        return tmp1 | tmp2
    }
    
    internal func rotateLeft(x:UInt32, _ n:UInt32) -> UInt32 {
        return ((x &<< n) & 0xffffffff) | (x &>> (32 - n))
    }
    
    internal func rotateRight(x:UInt32, _ n:UInt32) -> UInt32 {
        return ((x &>> n) & 0xffffffff) | (x &<< (32 - n))
    }

}