//
//  Generics.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 02/09/14.
//  Copyright (c) 2014 Marcin Krzyzanowski. All rights reserved.
//

import Foundation

/** Protocol and extensions for integerFromBitsArray. Bit hakish for me, but I can't do it in any other way */
protocol Initiable  {
    init(_ v: Int)
    init(_ v: UInt)
}

extension Int:Initiable {}
extension UInt:Initiable {}
extension UInt8:Initiable {}
extension UInt16:Initiable {}
extension UInt32:Initiable {}
extension UInt64:Initiable {}

/** build bit pattern from array of bits */
func integerFromBitsArray<T: UnsignedIntegerType>(bits: [Bit]) -> T
{
    var bitPattern:T = 0
    for (idx,b) in enumerate(bits) {
        if (b == Bit.One) {
            let bit = T(UIntMax(1) << UIntMax(idx))
            bitPattern = bitPattern | bit
        }
    }
    return bitPattern
}

/** initialize integer from array of bytes */
func integerWithBytes<T: IntegerType>(bytes: [UInt8]) -> T {
    var totalBytes = Swift.min(bytes.count, sizeof(T))
    // get slice of Int
    var start = Swift.max(bytes.count - sizeof(T),0)
    var intarr = [UInt8](bytes[start..<(start + totalBytes)])
    
    // pad size if necessary
    while (intarr.count < sizeof(T)) {
        intarr.insert(0 as UInt8, atIndex: 0)
    }
    intarr = intarr.reverse()
    
    var i:T = 0
    var data = NSData(bytes: intarr, length: intarr.count)
    data.getBytes(&i, length: sizeofValue(i));
    return i
}

/** array of bytes, little-endian representation */
func arrayOfBytes<T>(value:T, length:Int? = nil) -> [UInt8] {
    let totalBytes = length ?? (sizeofValue(value) * 8)
    var v = value
    
    var valuePointer = UnsafeMutablePointer<T>.alloc(1)
    valuePointer.memory = value
    
    var bytesPointer = UnsafeMutablePointer<UInt8>(valuePointer)
    var bytes = [UInt8](count: totalBytes, repeatedValue: 0)
    for j in 0..<min(sizeof(T),totalBytes) {
        bytes[totalBytes - 1 - j] = (bytesPointer + j).memory
    }
    
    valuePointer.destroy()
    valuePointer.dealloc(1)
    
    return bytes
}

// MARK: - shiftLeft

// helper to be able tomake shift operation on T
func <<<T:SignedIntegerType>(lhs: T, rhs: Int) -> Int {
    let a = lhs as! Int
    let b = rhs
    return a << b
}

func <<<T:UnsignedIntegerType>(lhs: T, rhs: Int) -> UInt {
    let a = lhs as! UInt
    let b = rhs
    return a << b
}

// Generic function itself
// FIXME: this generic function is not as generic as I would. It crashes for smaller types
func shiftLeft<T: SignedIntegerType where T: Initiable>(value: T, count: Int) -> T {
    if (value == 0) {
        return 0;
    }
    
    var bitsCount = (sizeofValue(value) * 8)
    var shiftCount = Int(Swift.min(count, bitsCount - 1))
    
    var shiftedValue:T = 0;
    for bitIdx in 0..<bitsCount {
        var bit = T(IntMax(1 << bitIdx))
        if ((value & bit) == bit) {
            shiftedValue = shiftedValue | T(bit << shiftCount)
        }
    }
    
    if (shiftedValue != 0 && count >= bitsCount) {
        // clear last bit that couldn't be shifted out of range
        shiftedValue = shiftedValue & T(~(1 << (bitsCount - 1)))
    }
    return shiftedValue
}

// for any f*** other Integer type - this part is so non-Generic
func shiftLeft(value: UInt, count: Int) -> UInt {
    return UInt(shiftLeft(Int(value), count))
}

func shiftLeft(value: UInt8, count: Int) -> UInt8 {
    return UInt8(shiftLeft(UInt(value), count))
}

func shiftLeft(value: UInt16, count: Int) -> UInt16 {
    return UInt16(shiftLeft(UInt(value), count))
}

func shiftLeft(value: UInt32, count: Int) -> UInt32 {
    return UInt32(shiftLeft(UInt(value), count))
}

func shiftLeft(value: UInt64, count: Int) -> UInt64 {
    return UInt64(shiftLeft(UInt(value), count))
}

func shiftLeft(value: Int8, count: Int) -> Int8 {
    return Int8(shiftLeft(Int(value), count))
}

func shiftLeft(value: Int16, count: Int) -> Int16 {
    return Int16(shiftLeft(Int(value), count))
}

func shiftLeft(value: Int32, count: Int) -> Int32 {
    return Int32(shiftLeft(Int(value), count))
}

func shiftLeft(value: Int64, count: Int) -> Int64 {
    return Int64(shiftLeft(Int(value), count))
}

