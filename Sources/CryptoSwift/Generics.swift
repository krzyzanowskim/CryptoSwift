//
//  Generics.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 02/09/14.
//  Copyright (c) 2014 Marcin Krzyzanowski. All rights reserved.
//

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
func integerFromBitsArray<T: UnsignedInteger>(_ bits: [Bit]) -> T
{
    var bitPattern:T = 0
    for (idx,b) in bits.enumerated() {
        if (b == Bit.One) {
            let bit = T(UIntMax(1) << UIntMax(idx))
            bitPattern = bitPattern | bit
        }
    }
    return bitPattern
}

/// Initialize integer from array of bytes.
/// This method may be slow
func integerWithBytes<T: Integer where T:ByteConvertible, T: BitshiftOperationsType>(_ bytes: [UInt8]) -> T {
    var bytes = bytes.reversed() as Array<UInt8> //FIXME: check it this is equivalent of Array(...)
    if bytes.count < sizeof(T) {
        let paddingCount = sizeof(T) - bytes.count
        if (paddingCount > 0) {
            bytes += [UInt8](repeating: 0, count: paddingCount)
        }
    }
    
    if sizeof(T) == 1 {
        return T(truncatingBitPattern: UInt64(bytes.first!))
    }
    
    var result: T = 0
    for byte in bytes.reversed() {
        result = result << 8 | T(byte)
    }
    return result
}

/// Array of bytes, little-endian representation. Don't use if not necessary.
/// I found this method slow
func arrayOfBytes<T>(_ value:T, length:Int? = nil) -> [UInt8] {
    let totalBytes = length ?? sizeof(T)
    
    let valuePointer = UnsafeMutablePointer<T>.init(allocatingCapacity: 1)
    valuePointer.pointee = value
    
    let bytesPointer = UnsafeMutablePointer<UInt8>(valuePointer)
    var bytes = [UInt8](repeating: 0, count: totalBytes)
    for j in 0..<min(sizeof(T),totalBytes) {
        bytes[totalBytes - 1 - j] = (bytesPointer + j).pointee
    }
    
    valuePointer.deinitialize()
    valuePointer.deallocateCapacity(1)
    
    return bytes
}

// MARK: - shiftLeft

// helper to be able tomake shift operation on T
func << <T:SignedInteger>(lhs: T, rhs: Int) -> Int {
    let a = lhs as! Int
    let b = rhs
    return a << b
}

func << <T:UnsignedInteger>(lhs: T, rhs: Int) -> UInt {
    let a = lhs as! UInt
    let b = rhs
    return a << b
}

// Generic function itself
// FIXME: this generic function is not as generic as I would. It crashes for smaller types
func shiftLeft<T: SignedInteger where T: Initiable>(_ value: T, count: Int) -> T {
    if (value == 0) {
        return 0;
    }
    
    let bitsCount = (sizeofValue(value) * 8)
    let shiftCount = Int(Swift.min(count, bitsCount - 1))
    
    var shiftedValue:T = 0;
    for bitIdx in 0..<bitsCount {
        let bit = T(IntMax(1 << bitIdx))
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
func shiftLeft(_ value: UInt, count: Int) -> UInt {
    return UInt(shiftLeft(Int(value), count: count)) //FIXME: count:
}

func shiftLeft(_ value: UInt8, count: Int) -> UInt8 {
    return UInt8(shiftLeft(UInt(value), count: count))
}

func shiftLeft(_ value: UInt16, count: Int) -> UInt16 {
    return UInt16(shiftLeft(UInt(value), count: count))
}

func shiftLeft(_ value: UInt32, count: Int) -> UInt32 {
    return UInt32(shiftLeft(UInt(value), count: count))
}

func shiftLeft(_ value: UInt64, count: Int) -> UInt64 {
    return UInt64(shiftLeft(UInt(value), count: count))
}

func shiftLeft(_ value: Int8, count: Int) -> Int8 {
    return Int8(shiftLeft(Int(value), count: count))
}

func shiftLeft(_ value: Int16, count: Int) -> Int16 {
    return Int16(shiftLeft(Int(value), count: count))
}

func shiftLeft(_ value: Int32, count: Int) -> Int32 {
    return Int32(shiftLeft(Int(value), count: count))
}

func shiftLeft(_ value: Int64, count: Int) -> Int64 {
    return Int64(shiftLeft(Int(value), count: count))
}

