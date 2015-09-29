//
//  UInt32Extension.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 02/09/14.
//  Copyright (c) 2014 Marcin Krzyzanowski. All rights reserved.
//

import Darwin

protocol _UInt32Type { }
extension UInt32: _UInt32Type {}

/** array of bytes */
extension UInt32 {
    public func bytes(totalBytes: Int = sizeof(UInt32)) -> [UInt8] {
        return arrayOfBytes(self, length: totalBytes)
    }

    public static func withBytes(bytes: ArraySlice<UInt8>) -> UInt32 {
        return UInt32.withBytes(Array(bytes))
    }

    /** Int with array bytes (little-endian) */
    public static func withBytes(bytes: [UInt8]) -> UInt32 {
        return integerWithBytes(bytes)
    }
}

/** Shift bits */
extension UInt32 {
    
    /** Shift bits to the left. All bits are shifted (including sign bit) */
    private mutating func shiftLeft(count: UInt32) -> UInt32 {
        if (self == 0) {
            return self;
        }
        
        let bitsCount = UInt32(sizeof(UInt32) * 8)
        let shiftCount = Swift.min(count, bitsCount - 1)
        var shiftedValue:UInt32 = 0;
        
        for bitIdx in 0..<bitsCount {
            // if bit is set then copy to result and shift left 1
            let bit = 1 << bitIdx
            if ((self & bit) == bit) {
                shiftedValue = shiftedValue | (bit << shiftCount)
            }
        }
        
        if (shiftedValue != 0 && count >= bitsCount) {
            // clear last bit that couldn't be shifted out of range
            shiftedValue = shiftedValue & (~(1 << (bitsCount - 1)))
        }

        self = shiftedValue
        return self
    }
    
    /** Shift bits to the right. All bits are shifted (including sign bit) */
    private mutating func shiftRight(count: UInt32) -> UInt32 {
        if (self == 0) {
            return self;
        }
        
        let bitsCount = UInt32(sizeofValue(self) * 8)

        if (count >= bitsCount) {
            return 0
        }

        let maxBitsForValue = UInt32(floor(log2(Double(self)) + 1))
        let shiftCount = Swift.min(count, maxBitsForValue - 1)
        var shiftedValue:UInt32 = 0;
        
        for bitIdx in 0..<bitsCount {
            // if bit is set then copy to result and shift left 1
            let bit = 1 << bitIdx
            if ((self & bit) == bit) {
                shiftedValue = shiftedValue | (bit >> shiftCount)
            }
        }
        self = shiftedValue
        return self
    }

}

/** shift left and assign with bits truncation */
public func &<<= (inout lhs: UInt32, rhs: UInt32) {
    lhs.shiftLeft(rhs)
}

/** shift left with bits truncation */
public func &<< (lhs: UInt32, rhs: UInt32) -> UInt32 {
    var l = lhs;
    l.shiftLeft(rhs)
    return l
}

/** shift right and assign with bits truncation */
func &>>= (inout lhs: UInt32, rhs: UInt32) {
    lhs.shiftRight(rhs)
}

/** shift right and assign with bits truncation */
func &>> (lhs: UInt32, rhs: UInt32) -> UInt32 {
    var l = lhs;
    l.shiftRight(rhs)
    return l
}