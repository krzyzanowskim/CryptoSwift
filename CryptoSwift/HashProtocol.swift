//
//  HashProtocol.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 17/08/14.
//  Copyright (c) 2014 Marcin Krzyzanowski. All rights reserved.
//

import Foundation

internal protocol HashProtocol {
    var message: NSData { get }

    /** Common part for hash calculation. Prepare header data. */
    func prepare(len:Int) -> NSMutableData
}

extension HashProtocol {

    func prepare(len:Int) -> NSMutableData {
        let tmpMessage: NSMutableData = NSMutableData(data: self.message)
        
        // Step 1. Append Padding Bits
        tmpMessage.appendBytes([0x80]) // append one bit (UInt8 with one bit) to message
        
        // append "0" bit until message length in bits ≡ 448 (mod 512)
        var msgLength = tmpMessage.length
        var counter = 0
        
        while msgLength % len != (len - 8) {
            counter++
            msgLength++
        }
        
        let bufZeros = UnsafeMutablePointer<UInt8>(calloc(counter, sizeof(UInt8)))
        
        tmpMessage.appendBytes(bufZeros, length: counter)
        
        bufZeros.destroy()
        bufZeros.dealloc(1)
        
        return tmpMessage
    }
}