// Playground - noun: a place where people can play

import Foundation

extension Byte {
    mutating func shiftRight(count: Byte) -> Byte {
        if (self == 0) {
            return self;
        }

        var bitsCount = Byte(sizeof(Byte) * 8)

        if (count >= bitsCount) {
            return 0
        }

        var maxBitsForValue = Byte(floor(log2(Double(self) + 1)))
        var shiftCount = Swift.min(count, maxBitsForValue - 1)
        var shiftedValue:Byte = 0;
        
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

var b:Byte = 255
b >> 7
b.shiftRight(8)

//
///** Bit operations */
//extension Int {
//    /** Shift bits to the right. All bits are shifted (including sign bit) */
//    private mutating func shiftRight(count: Int) -> Int {
//        if (self == 0) {
//            return self;
//        }
//        
//        var bitsCount = sizeof(Int) * 8
//        var maxBitsForValue = Int(floor(log2(Double(self)) + 1)) - 1
//        var shiftCount = Swift.min(count, maxBitsForValue)
//        var shiftedValue:Int = 0;
//        
//        for bitIdx in 0..<bitsCount {
//            // if bit is set then copy to result and shift left 1
//            var bit = 1 << bitIdx
//            if ((self & bit) == bit) {
//                shiftedValue = shiftedValue | (bit >> shiftCount)
//            }
//        }
//        self = Int(shiftedValue)
//        return self
//    }
//}
//
//var a:Int = 9223372036854775807
//a >> 63
//a.shiftRight(63)


