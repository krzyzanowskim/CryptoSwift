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
}

extension UInt:Initiable {}
extension UInt:Initiable {}
extension UInt8:Initiable {}
extension UInt16:Initiable {}
extension UInt32:Initiable {}
extension UInt64:Initiable {}

/** build bit pattern from array of bits */
func integerFromBitsArray<T: UnsignedIntegerType where T: IntegerLiteralConvertible, T: Initiable>(bits: [Bit]) -> T
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

/** initialize integer from array of bytes */
func integerWithBytes<T: IntegerType>(bytes: [Byte]) -> T {
    var totalBytes = Swift.min(bytes.count, sizeof(T))
    // get slice of Int
    var start = Swift.max(bytes.count - sizeof(T),0)
    var intarr = [Byte](bytes[start..<(start + totalBytes)])
    
    // pad size if necessary
    while (intarr.count < sizeof(T)) {
        intarr.insert(0 as Byte, atIndex: 0)
    }
    intarr = intarr.reverse()
    
    var i:T = 0
    var data = NSData(bytes: intarr, length: intarr.count)
    data.getBytes(&i, length: sizeofValue(i));
    return i
}

/** array of bytes, little-endian representation */
func arrayOfBytes<T>(value:T, totalBytes:Int) -> [Byte] {
    var bytes = [Byte](count: totalBytes, repeatedValue: 0)
    var data = NSData(bytes: [value] as [T], length: min(sizeof(T),totalBytes))
    
    // then convert back to bytes, byte by byte
    for i in 0..<data.length {
        data.getBytes(&bytes[totalBytes - 1 - i], range:NSRange(location:i, length:sizeof(Byte)))
    }
    
    return bytes
}