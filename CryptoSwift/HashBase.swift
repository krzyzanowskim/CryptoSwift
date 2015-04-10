//
//  Hash.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 17/08/14.
//  Copyright (c) 2014 Marcin Krzyzanowski. All rights reserved.
//

import Foundation

protocol _Hash {
    var size:Int { get }
    func prepare(len:Int) -> NSMutableData;
}

internal class HashBase {
    
    var message: NSData
    
    internal init(_ message: NSData) {
        self.message = message
    }
    
    /** Common part for hash calculation. Prepare header data. */
    internal func prepare(_ len:Int = 64) -> NSMutableData {
        var tmpMessage: NSMutableData = NSMutableData(data: self.message)
        
        // Step 1. Append Padding Bits
        tmpMessage.appendBytes([0x80]) // append one bit (UInt8 with one bit) to message
        
        // append "0" bit until message length in bits ≡ 448 (mod 512)
        var msgLength = tmpMessage.length
        var counter = 0
      
        while msgLength % len != (len - 8) {
            counter++
            msgLength++
        }
      
        var bufZeros = UnsafeMutablePointer<UInt8>(calloc(counter, sizeof(UInt8)))
      
        tmpMessage.appendBytes(bufZeros, length: counter)
      
        bufZeros.destroy()
        bufZeros.dealloc(1)
      
        return tmpMessage
    }
}