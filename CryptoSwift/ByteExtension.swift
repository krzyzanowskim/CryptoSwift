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
    internal func bits() -> [Bit] {
        let totalBitsCount = sizeof(Byte) * 8
        
        var bitsArray:[Bit] = [Bit](count: totalBitsCount, repeatedValue: Bit.zero)
        
        for j in 0..<totalBitsCount {
            let bitVal:Byte = 1 << UInt8(totalBitsCount - 1 - j)
            let check = self & bitVal
            
            if (check != 0) {
                bitsArray[j] = Bit.one;
            }
        }
        return bitsArray
    }
    
    internal func bits() -> String {
        var s = String()
        let arr:[Bit] = self.bits()
        for (idx,b) in enumerate(arr) {
            s += (b == Bit.one ? "1" : "0")
            if ((idx + 1) % 8 == 0) { s += " " }
        }
        return s
    }
}