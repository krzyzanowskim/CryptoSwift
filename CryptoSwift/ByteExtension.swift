//
//  ByteExtension.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 07/08/14.
//  Copyright (c) 2014 Marcin Krzyzanowski. All rights reserved.
//

import Foundation

extension Byte {
    
    /** array of bits */
    internal func bits() -> Array<Bool> {
        let totalBitsCount = sizeof(Byte) * 8
        
        var bitsArray:[Bool] = [Bool](count: totalBitsCount, repeatedValue: false)
        
        for j in 0..<totalBitsCount {
            let bitVal:Byte = 1 << UInt8(totalBitsCount - 1 - j)
            let check = self & bitVal
            
            if (check != 0) {
                bitsArray[j] = 1;
            }
        }
        return bitsArray
    }
}