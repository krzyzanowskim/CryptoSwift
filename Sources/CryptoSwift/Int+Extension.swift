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
        self.init(bitPattern: integerFrom(bits) as UInt)
    }
}

/* array of bytes */
extension Int {
    /** Int with collection of bytes (little-endian) */
    init<T: Collection>(bytes: T) where T.Iterator.Element == UInt8, T.Index == Int {
        self = bytes.toInteger()
    }

    /** Array of bytes with optional padding (little-endian) */
    func bytes(totalBytes: Int = MemoryLayout<Int>.size) -> Array<UInt8> {
        return arrayOfBytes(value: self, length: totalBytes)
    }
}



/** Shift bits */
extension Int {
    
    /** Shift bits to the left. All bits are shifted (including sign bit) */
    mutating func shiftLeft(by count: Int) {
        self = CryptoSwift.shiftLeft(self, by: count) //FIXME: count:
    }
    
    /** Shift bits to the right. All bits are shifted (including sign bit) */
    mutating func shiftRight(by count: Int) {
        if (self == 0) {
            return
        }
        
        let bitsCount = MemoryLayout<Int>.size * 8

        if (count >= bitsCount) {
            return
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
    }
}

// Left operator

/** shift left and assign with bits truncation */
func &<<= (lhs: inout Int, rhs: Int) {
    lhs.shiftLeft(by: rhs)
}

/** shift left with bits truncation */
func &<< (lhs: Int, rhs: Int) -> Int {
    var l = lhs;
    l.shiftLeft(by: rhs)
    return l
}

// Right operator

/** shift right and assign with bits truncation */
func &>>= (lhs: inout Int, rhs: Int) {
    lhs.shiftRight(by: rhs)
}

/** shift right and assign with bits truncation */
func &>> (lhs: Int, rhs: Int) -> Int {
    var l = lhs;
    l.shiftRight(by: rhs)
    return l
}
