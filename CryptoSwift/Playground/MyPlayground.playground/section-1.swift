// Playground - noun: a place where people can play

import UIKit

extension Int {
    
    private init(bits: [Bool]) {
        var bitPattern:UInt = 0
        for (idx,b) in enumerate(bits) {
            if (b == true) {
                let bit:UInt = UInt(1) << UInt(idx)
                bitPattern = bitPattern | bit
            }
        }
        
        self.init(bitPattern: bitPattern)
    }
    
    /** Array of bytes with optional padding (little-endian) */
    public func bytes(_ totalBytes: Int = sizeof(Int)) -> [Byte] {
        var bytes:[Byte] = [Byte](count: totalBytes, repeatedValue: 0)
        
        // first convert to data
        let data = NSData(bytes: [self] as [Int], length: totalBytes)
        
        // then convert back to bytes, byte by byte
        for i in 0..<Swift.min(sizeof(Int),totalBytes) {
            var b:Byte = 0
            data.getBytes(&b, range: NSRange(location: i,length: 1))
            bytes[totalBytes - 1 - i] = b
        }
        return bytes
    }
    
    /** Int with array bytes (little-endian) */
    public static func withBytes(bytes: [Byte]) -> Int {
        var i:Int = 0
        let totalBytes = Swift.min(bytes.count, sizeof(Int))
        
        // get slice of Int
        let start = Swift.max(bytes.count - sizeof(Int),0)
        var intarr = Array<Byte>(bytes[start..<(start + totalBytes)])
        
        // extend to Int size if necessary
        while (intarr.count < sizeof(Int)) {
            intarr.insert(0 as Byte, atIndex: 0)
        }
        
        let data = NSData(bytes: intarr, length: intarr.count)
        data.getBytes(&i, length: sizeof(Int));
        return i.byteSwapped
    }
    
    /** Shift bits to the left. All bits are shifted (including sign bit) */
    private mutating func shiftLeft(count: Int) -> Int {
        let bitsCount = sizeof(Int) * 8
        let shiftCount = Swift.min(count, bitsCount - 1)
        var shiftedValue:Int = 0;
        
        for bitIdx in 0..<bitsCount {
            // if bit is set then copy to result and shift left 1
            let bit = 1 << bitIdx
            if ((self & bit) == bit) {
                shiftedValue = shiftedValue | (bit << shiftCount)
            }
        }
        self = shiftedValue
        return self
    }
    
    /** Shift bits to the right. All bits are shifted (including sign bit) */
    private mutating func shiftRight(count: Int) -> Int {
        let bitsCount = sizeof(Int) * 8
        let maxBitsForValue = Int(floor(log2(Double(self)) + 1))
        let shiftCount = Swift.min(count, maxBitsForValue)
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


var four:Byte = 128
var shifted = four << 24

//let four:Int = 0b00000100
//let shifted:Int = four &<< 64

shifted

//var i:Int = 9223372036854775808
//
//var i:Int = 9
//var shifted1 = i &<< 61 //  i &<<= 61

//
//var i:UInt = UInt(4) << UInt(61)


//var i = 9
//i &<< 8
//
