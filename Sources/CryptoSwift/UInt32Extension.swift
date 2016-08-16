//
//  UInt32Extension.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 02/09/14.
//  Copyright (c) 2014 Marcin Krzyzanowski. All rights reserved.
//

#if os(Linux)
    import Glibc
#else
    import Darwin
#endif


protocol _UInt32Type { }
extension UInt32: _UInt32Type {}

/** array of bytes */
extension UInt32 {
    public func bytes(totalBytes: Int = MemoryLayout<UInt32>.size) -> Array<UInt8> {
        return arrayOfBytes(value: self, length: totalBytes)
    }

    public static func with(bytes: ArraySlice<UInt8>) -> UInt32 {
        return integerWith(Array(bytes))
    }

    /** Int with array bytes (little-endian) */
    public static func with(bytes: Array<UInt8>) -> UInt32 {
        return integerWith(bytes)
    }
}

/** Shift bits */
extension UInt32 {
    
    /** Shift bits to the left. All bits are shifted (including sign bit) */
    fileprivate mutating func shiftLeft(by count: UInt32) {
        if (self == 0) {
            return
        }
        
        let bitsCount = UInt32(MemoryLayout<UInt32>.size * 8)
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
    }
    
    /** Shift bits to the right. All bits are shifted (including sign bit) */
    fileprivate mutating func shiftRight(by count: UInt32) {
        if (self == 0) {
            return
        }
        
        let bitsCount = UInt32(MemoryLayout<UInt32>.size * 8)

        if (count >= bitsCount) {
            return
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
    }

}

/** shift left and assign with bits truncation */
public func &<<= (lhs: inout UInt32, rhs: UInt32) {
    lhs.shiftLeft(by: rhs)
}

/** shift left with bits truncation */
public func &<< (lhs: UInt32, rhs: UInt32) -> UInt32 {
    var l = lhs;
    l.shiftLeft(by: rhs)
    return l
}

/** shift right and assign with bits truncation */
func &>>= (lhs: inout UInt32, rhs: UInt32) {
    lhs.shiftRight(by: rhs)
}

/** shift right and assign with bits truncation */
func &>> (lhs: UInt32, rhs: UInt32) -> UInt32 {
    var l = lhs;
    l.shiftRight(by: rhs)
    return l
}
