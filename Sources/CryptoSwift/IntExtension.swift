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

#if os(Linux)
    import Glibc
#else
    import Darwin
#endif


/* array of bits */
extension Int {
    init(bits: [Bit]) {
        self.init(bitPattern: integerFromBitsArray(bits) as UInt)
    }
}

/* array of bytes */
extension Int {
    /** Array of bytes with optional padding (little-endian) */
    public func bytes(totalBytes: Int = sizeof(Int)) -> [UInt8] {
        return arrayOfBytes(self, length: totalBytes)
    }

    public static func withBytes(bytes: ArraySlice<UInt8>) -> Int {
        return Int.withBytes(Array(bytes))
    }

    /** Int with array bytes (little-endian) */
    public static func withBytes(bytes: [UInt8]) -> Int {
        return integerWithBytes(bytes)
    }
}



/** Shift bits */
extension Int {
    
    /** Shift bits to the left. All bits are shifted (including sign bit) */
    private mutating func shiftLeft(count: Int) -> Int {
        self = CryptoSwift.shiftLeft(self, count: count) //FIXME: count:
        return self
    }
    
    /** Shift bits to the right. All bits are shifted (including sign bit) */
    private mutating func shiftRight(count: Int) -> Int {
        if (self == 0) {
            return self;
        }
        
        let bitsCount = sizeofValue(self) * 8

        if (count >= bitsCount) {
            return 0
        }

        let maxBitsForValue = Int(floor(log2(Double(self)) + 1))
        let shiftCount = Swift.min(count, maxBitsForValue - 1)
        var shiftedValue:Int = 0;
        
        for bitIdx in 0..<bitsCount {
            // if bit is set then copy to result and shift left 1
            let bit = 1 << bitIdx
            if ((self & bit) == bit) {
                shiftedValue = shiftedValue | (bit >> shiftCount)
            }
        }
        self = Int(shiftedValue)
        return self
    }
}

// Left operator

/** shift left and assign with bits truncation */
public func &<<= (inout lhs: Int, rhs: Int) {
    lhs.shiftLeft(rhs)
}

/** shift left with bits truncation */
public func &<< (lhs: Int, rhs: Int) -> Int {
    var l = lhs;
    l.shiftLeft(rhs)
    return l
}

// Right operator

/** shift right and assign with bits truncation */
func &>>= (inout lhs: Int, rhs: Int) {
    lhs.shiftRight(rhs)
}

/** shift right and assign with bits truncation */
func &>> (lhs: Int, rhs: Int) -> Int {
    var l = lhs;
    l.shiftRight(rhs)
    return l
}
