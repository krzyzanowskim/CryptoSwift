//
//  UInt16Extension.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 02/09/14.
//  Copyright (c) 2014 Marcin Krzyzanowski. All rights reserved.
//

import Foundation

/** Shift bits */
extension UInt16 {
    /** Shift bits to the right. All bits are shifted (including sign bit) */
    mutating func shiftRight(count: UInt16) -> UInt16 {
        if (self == 0) {
            return self;
        }

        var bitsCount = UInt16(sizeofValue(self) * 8)

        if (count >= bitsCount) {
            return 0
        }

        var maxBitsForValue = UInt16(floor(log2(Double(self) + 1)))
        var shiftCount = Swift.min(count, maxBitsForValue - 1)
        var shiftedValue:UInt16 = 0;
        
        for bitIdx in 0..<bitsCount {
            var byte = 1 << bitIdx
            if ((self & byte) == byte) {
                shiftedValue = shiftedValue | (byte >> shiftCount)
            }
        }
        self = shiftedValue
        return self
    }
}

/** shift right and assign with bits truncation */
func &>> (lhs: UInt16, rhs: UInt16) -> UInt16 {
    var l = lhs;
    l.shiftRight(rhs)
    return l
}