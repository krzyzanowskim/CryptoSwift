// Playground - noun: a place where people can play

import Foundation

protocol Initiable  {
    init(_ v: Int)
}

func integerFromBitsArray<T: IntegerLiteralConvertible where T: UnsignedIntegerType, T: Initiable>(bits: [Bit]) -> T
{
    var bitPattern:T = 0
    for (idx,b) in enumerate(bits) {
        if (b == Bit.One) {
            let bit = T(1 << idx)
            bitPattern = bitPattern | bit
        }
    }
    return bitPattern
}

extension UInt:Initiable {}
extension UInt8:Initiable {}
extension UInt16:Initiable {}
extension UInt32:Initiable {}
extension UInt64:Initiable {}

let i = integerFromBitsArray([Bit.One, Bit.Zero]) as UInt8
