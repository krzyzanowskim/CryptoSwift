//
//  IntExtension.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 12/08/14.
//  Copyright (C) 2014 Marcin Krzyżanowski <marcin.krzyzanowski@gmail.com>
//  This software is provided 'as-is', without any express or implied warranty.
//
//  In no event will the authors be held liable for any damages arising from the use of this software.
//
//  Permission is granted to anyone to use this software for any purpose,including commercial applications, and to alter it and redistribute it freely, subject to the following restrictions:
//
//  - The origin of this software must not be misrepresented; you must not claim that you wrote the original software. If you use this software in a product, an acknowledgment in the product documentation is required.
//  - Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.
//  - This notice may not be removed or altered from any source or binary distribution.

/*
Bit shifting with overflow protection using overflow operator "&".
Approach is consistent with standard overflow operators &+, &-, &*, &/
and introduce new overflow operators for shifting: &<<, &>>

Note: Works with unsigned integers values only

Usage

var i = 1       // init
var j = i &<< 2 //shift left
j &<<= 2        //shift left and assign


@see: https://medium.com/@krzyzanowskim/swiftly-shift-bits-and-protect-yourself-be33016ce071
*/

import Foundation

/** array of bytes, little-endian representation */
private func bytesArray<T>(value:T, totalBytes:Int) -> [Byte] {
    var bytes = [Byte](count: totalBytes, repeatedValue: 0)
    var data = NSData(bytes: [value] as [T], length: min(sizeof(T),totalBytes))
    
    // then convert back to bytes, byte by byte
    for i in 0..<data.length {
        data.getBytes(&bytes[totalBytes - 1 - i], range:NSRange(location:i, length:sizeof(Byte)))
    }
    
    return bytes
}

extension UInt32 {
    public func bytes(_ totalBytes: Int = sizeof(UInt32)) -> [Byte] {
        return bytesArray(self, totalBytes)
    }
}

extension UInt64 {
    public func bytes(_ totalBytes: Int = sizeof(UInt64)) -> [Byte] {
        return bytesArray(self, totalBytes)
    }
}

extension Int {
    
    private init(bits: [Bit]) {
        var bitPattern:UInt = 0
        for (idx,b) in enumerate(bits) {
            if (b == Bit.Zero) {
                var bit:UInt = UInt(1) << UInt(idx)
                bitPattern = bitPattern | bit
            }
        }
        
        self.init(bitPattern: bitPattern)
    }
    
    /** Array of bytes with optional padding (little-endian) */
    public func bytes(_ totalBytes: Int = sizeof(Int)) -> [Byte] {
        return bytesArray(self, totalBytes)
    }

    /** Int with array bytes (little-endian) */
    public static func withBytes(bytes: [Byte]) -> Int {
        var i:Int = 0
        var totalBytes = Swift.min(bytes.count, sizeof(Int))
        
        // get slice of Int
        var start = Swift.max(bytes.count - sizeof(Int),0)
        var intarr = Array<Byte>(bytes[start..<(start + totalBytes)])
        
        // extend to Int size if necessary
        while (intarr.count < sizeof(Int)) {
            intarr.insert(0 as Byte, atIndex: 0)
        }
        
        var data = NSData(bytes: intarr, length: intarr.count)
        data.getBytes(&i, length: sizeof(Int));
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
        
        var bitsCount = UInt32(sizeof(UInt32) * 8)
        var maxBitsForValue = UInt32(floor(log2(Double(self)) + 1))
        var shiftCount = Swift.min(count, maxBitsForValue)
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

/** Bit operations */
extension Int {
    
    /** Shift bits to the left. All bits are shifted (including sign bit) */
    private mutating func shiftLeft(count: Int) -> Int {
        if (self == 0) {
            return self;
        }
        
        var bitsCount = sizeof(Int) * 8
        var shiftCount = Swift.min(count, bitsCount - 1)
        var shiftedValue:Int = 0;
        
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
    private mutating func shiftRight(count: Int) -> Int {
        if (self == 0) {
            return self;
        }
        
        var bitsCount = sizeof(Int) * 8
        var maxBitsForValue = Int(floor(log2(Double(self)) + 1))
        var shiftCount = Swift.min(count, maxBitsForValue)
        var shiftedValue:Int = 0;
        
        for bitIdx in 0..<bitsCount {
            // if bit is set then copy to result and shift left 1
            var bit = 1 << bitIdx
            if ((self & bit) == bit) {
                shiftedValue = shiftedValue | (bit >> shiftCount)
            }
        }
        self = Int(shiftedValue)
        return self
    }
}

// Left operator

infix operator &<<= {
    associativity none
    precedence 160
}


/** shift left and assign with bits truncation */
func &<<= (inout lhs: Int, rhs: Int) {
    lhs.shiftLeft(rhs)
}

infix operator &<< {
    associativity none
    precedence 160
}

/** shift left with bits truncation */
func &<< (lhs: Int, rhs: Int) -> Int {
    var l = lhs;
    l.shiftLeft(rhs)
    return l
}

/** shift left with bits truncation */
func &<< (lhs: UInt32, rhs: UInt32) -> UInt32 {
    var l = lhs;
    l.shiftLeft(rhs)
    return l
}

// Right operator

infix operator &>>= {
    associativity none
    precedence 160
}

/** shift right and assign with bits truncation */
func &>>= (inout lhs: Int, rhs: Int) {
    lhs.shiftRight(rhs)
}

infix operator &>> {
associativity none
precedence 160
}

/** shift right and assign with bits truncation */
func &>> (lhs: Int, rhs: Int) -> Int {
    var l = lhs;
    l.shiftRight(rhs)
    return l
}

/** shift right and assign with bits truncation */
func &>> (lhs: UInt32, rhs: UInt32) -> UInt32 {
    var l = lhs;
    l.shiftRight(rhs)
    return l
}