//
//  ByteExtension.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 07/08/14.
//  Copyright (c) 2014 Marcin Krzyzanowski. All rights reserved.
//

import Darwin

public protocol _UInt8Type { }
extension UInt8: _UInt8Type {}

extension _UInt8Type {
    static func Zero() -> Self {
        return 0 as! Self
    }
}


/** casting */
extension UInt8 {
    
    /** cast because UInt8(<UInt32>) because std initializer crash if value is > byte */
    static func withValue(v:UInt64) -> UInt8 {
        let tmp = v & 0xFF
        return UInt8(tmp)
    }

    static func withValue(v:UInt32) -> UInt8 {
        let tmp = v & 0xFF
        return UInt8(tmp)
    }
    
    static func withValue(v:UInt16) -> UInt8 {
        let tmp = v & 0xFF
        return UInt8(tmp)
    }

}

/** Bits */
extension UInt8 {

    init(bits: [Bit]) {
        self.init(integerFromBitsArray(bits) as UInt8)
    }
    
    /** array of bits */
    func bits() -> [Bit] {
        let totalBitsCount = sizeofValue(self) * 8
        
        var bitsArray = [Bit](count: totalBitsCount, repeatedValue: Bit.Zero)
        
        for j in 0..<totalBitsCount {
            let bitVal:UInt8 = 1 << UInt8(totalBitsCount - 1 - j)
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
        for (idx,b) in arr.enumerate() {
            s += (b == Bit.One ? "1" : "0")
            if ((idx + 1) % 8 == 0) { s += " " }
        }
        return s
    }
}

/** Shift bits */
extension UInt8 {
    /** Shift bits to the right. All bits are shifted (including sign bit) */
    mutating func shiftRight(count: UInt8) -> UInt8 {
        if (self == 0) {
            return self;
        }

        let bitsCount = UInt8(sizeof(UInt8) * 8)

        if (count >= bitsCount) {
            return 0
        }

        let maxBitsForValue = UInt8(floor(log2(Double(self) + 1)))
        let shiftCount = Swift.min(count, maxBitsForValue - 1)
        var shiftedValue:UInt8 = 0;
        
        for bitIdx in 0..<bitsCount {
            let byte = 1 << bitIdx
            if ((self & byte) == byte) {
                shiftedValue = shiftedValue | (byte >> shiftCount)
            }
        }
        self = shiftedValue
        return self
    }
}

/** shift right and assign with bits truncation */
func &>> (lhs: UInt8, rhs: UInt8) -> UInt8 {
    var l = lhs;
    l.shiftRight(rhs)
    return l
}