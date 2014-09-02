//
//  UInt32Extension.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 02/09/14.
//  Copyright (c) 2014 Marcin Krzyzanowski. All rights reserved.
//

import Foundation

/* bytes of array */
extension UInt32 {
    public func bytes(_ totalBytes: Int = sizeof(UInt32)) -> [Byte] {
        return bytesArray(self, totalBytes)
    }

    public static func withBytes(bytes: Slice<Byte>) -> UInt32 {
        return UInt32.withBytes(Array(bytes))
    }

    /** Int with array bytes (little-endian) */
    public static func withBytes(bytes: [Byte]) -> UInt32 {
        var i:UInt32 = 0
        var totalBytes = Swift.min(bytes.count, sizeofValue(i))
        
        // get slice of Int
        var start = Swift.max(bytes.count - sizeofValue(i),0)
        var intarr = [Byte](bytes[start..<(start + totalBytes)])
        
        // extend to Int size if necessary
        while (intarr.count < sizeofValue(i)) {
            intarr.insert(0 as Byte, atIndex: 0)
        }
        
        var data = NSData(bytes: intarr, length: intarr.count)
        data.getBytes(&i, length: sizeofValue(i));
        return i.byteSwapped
    }
}

/** Bit operations */
extension UInt32 {
    
    /** Shift bits to the left. All bits are shifted (including sign bit) */
    private mutating func shiftLeft(count: UInt32) -> UInt32 {
        if (self == 0) {
            return self;
        }
        
        var bitsCount = UInt32(sizeof(UInt32) * 8)
        var shiftCount = Swift.min(count, bitsCount - 1)
        var shiftedValue:UInt32 = 0;
        
        for bitIdx in 0..<bitsCount {
            // if bit is set then copy to result and shift left 1
            var bit = 1 << bitIdx
            if ((self & bit) == bit) {
                shiftedValue = shiftedValue | (bit << shiftCount)
            }
        }
        self = shiftedValue
        return self
    }
    
    /** Shift bits to the right. All bits are shifted (including sign bit) */
    private mutating func shiftRight(count: UInt32) -> UInt32 {
        if (self == 0) {
            return self;
        }
        
        var bitsCount = UInt32(sizeofValue(self) * 8)

        if (count >= bitsCount) {
            return 0
        }

        var maxBitsForValue = UInt32(floor(log2(Double(self)) + 1))
        var shiftCount = Swift.min(count, maxBitsForValue - 1)
        var shiftedValue:UInt32 = 0;
        
        for bitIdx in 0..<bitsCount {
            // if bit is set then copy to result and shift left 1
            var bit = 1 << bitIdx
            if ((self & bit) == bit) {
                shiftedValue = shiftedValue | (bit >> shiftCount)
            }
        }
        self = shiftedValue
        return self
    }

}

/** shift left and assign with bits truncation */
func &<<= (inout lhs: UInt32, rhs: UInt32) {
    lhs.shiftLeft(rhs)
}

/** shift left with bits truncation */
func &<< (lhs: UInt32, rhs: UInt32) -> UInt32 {
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