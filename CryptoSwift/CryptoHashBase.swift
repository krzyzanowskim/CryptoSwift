//
//  Hash.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 17/08/14.
//  Copyright (c) 2014 Marcin Krzyzanowski. All rights reserved.
//

import Foundation

class HashBase {
    
    var message: NSData
    
    init(_ message: NSData) {
        self.message = message
    }
    
    /** Common part for hash calculation. Prepare header data. */
    func prepare(_ len:Int = 64) -> NSMutableData {
        var tmpMessage: NSMutableData = NSMutableData(data: self.message)
        
        // Step 1. Append Padding Bits
        tmpMessage.appendBytes([0x80]) // append one bit (Byte with one bit) to message
        
        // append "0" bit until message length in bits ≡ 448 (mod 512)
        while tmpMessage.length % len != (len - 8) {
            tmpMessage.appendBytes([0x00])
        }
        
        return tmpMessage
    }
}