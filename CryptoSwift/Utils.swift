//
//  Utils.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 26/08/14.
//  Copyright (c) 2014 Marcin Krzyzanowski. All rights reserved.
//

func rotateLeft(v:UInt8, _ n:UInt8) -> UInt8 {
    return ((v << n) & 0xFF) | (v >> (8 - n))
}

func rotateLeft(v:UInt16, _ n:UInt16) -> UInt16 {
    return ((v << n) & 0xFFFF) | (v >> (16 - n))
}

func rotateLeft(v:UInt32, _ n:UInt32) -> UInt32 {
    return ((v << n) & 0xFFFFFFFF) | (v >> (32 - n))
}

func rotateLeft(x:UInt64, _ n:UInt64) -> UInt64 {
    return (x << n) | (x >> (64 - n))
}

func rotateRight(x:UInt16, n:UInt16) -> UInt16 {
    return (x >> n) | (x << (16 - n))
}

func rotateRight(x:UInt32, n:UInt32) -> UInt32 {
    return (x >> n) | (x << (32 - n))
}

func rotateRight(x:UInt64, n:UInt64) -> UInt64 {
    return ((x >> n) | (x << (64 - n)))
}

func reverseBytes(value: UInt32) -> UInt32 {
    return ((value & 0x000000FF) << 24) | ((value & 0x0000FF00) << 8) | ((value & 0x00FF0000) >> 8)  | ((value & 0xFF000000) >> 24);
}

func toUInt32Array(slice: ArraySlice<UInt8>) -> Array<UInt32> {
    var result = Array<UInt32>()
    result.reserveCapacity(16)
    
    for idx in slice.startIndex.stride(to: slice.endIndex, by: sizeof(UInt32)) {
        let val:UInt32 = (UInt32(slice[idx.advancedBy(3)]) << 24) | (UInt32(slice[idx.advancedBy(2)]) << 16) | (UInt32(slice[idx.advancedBy(1)]) << 8) | UInt32(slice[idx])
        result.append(val)
    }
    return result
}

func toUInt64Array(slice: ArraySlice<UInt8>) -> Array<UInt64> {
    var result = Array<UInt64>()
    result.reserveCapacity(32)
    for idx in slice.startIndex.stride(to: slice.endIndex, by: sizeof(UInt64)) {
        var val:UInt64 = 0
        val |= UInt64(slice[idx.advancedBy(7)]) << 56
        val |= UInt64(slice[idx.advancedBy(6)]) << 48
        val |= UInt64(slice[idx.advancedBy(5)]) << 40
        val |= UInt64(slice[idx.advancedBy(4)]) << 32
        val |= UInt64(slice[idx.advancedBy(3)]) << 24
        val |= UInt64(slice[idx.advancedBy(2)]) << 16
        val |= UInt64(slice[idx.advancedBy(1)]) << 8
        val |= UInt64(slice[idx.advancedBy(0)]) << 0
        result.append(val)
    }
    return result
}

func xor(a: [UInt8], b:[UInt8]) -> [UInt8] {
    var xored = [UInt8](count: a.count, repeatedValue: 0)
    for i in 0..<xored.count {
        xored[i] = a[i] ^ b[i]
    }
    return xored
}