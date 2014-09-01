//
//  ByteExtension.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 07/08/14.
//  Copyright (c) 2014 Marcin Krzyzanowski. All rights reserved.
//

import Foundation

extension Byte {

    init(bits: [Bit]) {
        var bitPattern:Byte = 0
        for (idx,b) in enumerate(bits) {
            if (b == Bit.Zero) {
                var bit:Byte = Byte(1) << Byte(idx)
                bitPattern = bitPattern | bit
            }
        }
        
        self.init(bitPattern)
    }
    
    /** array of bits */
    func bits() -> [Bit] {
        let totalBitsCount = sizeofValue(self) * 8
        
        var bitsArray = [Bit](count: totalBitsCount, repeatedValue: Bit.Zero)
        
        for j in 0..<totalBitsCount {
            let bitVal:Byte = 1 << Byte(totalBitsCount - 1 - j)
            let check = self & bitVal
            
            if (check != 0) {
                bitsArray[j] = Bit.One;
            }
        }
        return bitsArray
    }

    func bits() -> String {
        var s = String()
        let arr:[Bit] = self.bits()
        for (idx,b) in enumerate(arr) {
            s += (b == Bit.One ? "1" : "0")
            if ((idx + 1) % 8 == 0) { s += " " }
        }
        return s
    }
}