//
//  Utils.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 26/08/14.
//  Copyright (c) 2014 Marcin Krzyzanowski. All rights reserved.
//

func rotateLeft(_ v:UInt8, _ n:UInt8) -> UInt8 {
    return ((v << n) & 0xFF) | (v >> (8 - n))
}

func rotateLeft(_ v:UInt16, _ n:UInt16) -> UInt16 {
    return ((v << n) & 0xFFFF) | (v >> (16 - n))
}

func rotateLeft(_ v:UInt32, _ n:UInt32) -> UInt32 {
    return ((v << n) & 0xFFFFFFFF) | (v >> (32 - n))
}

func rotateLeft(_ x:UInt64, _ n:UInt64) -> UInt64 {
    return (x << n) | (x >> (64 - n))
}

func rotateRight(_ x:UInt16, n:UInt16) -> UInt16 {
    return (x >> n) | (x << (16 - n))
}

func rotateRight(_ x:UInt32, n:UInt32) -> UInt32 {
    return (x >> n) | (x << (32 - n))
}

func rotateRight(_ x:UInt64, n:UInt64) -> UInt64 {
    return ((x >> n) | (x << (64 - n)))
}

func reverseBytes(_ value: UInt32) -> UInt32 {
    return ((value & 0x000000FF) << 24) | ((value & 0x0000FF00) << 8) | ((value & 0x00FF0000) >> 8)  | ((value & 0xFF000000) >> 24);
}

func toUInt32Array(_ slice: ArraySlice<UInt8>) -> Array<UInt32> {
    var result = Array<UInt32>()
    result.reserveCapacity(16)
    
    for idx in stride(from: slice.startIndex, to: slice.endIndex, by: Int.Stride(sizeof(UInt32))) {
        let val1:UInt32 = (UInt32(slice[idx.advanced(by: 3)]) << 24)
        let val2:UInt32 = (UInt32(slice[idx.advanced(by: 2)]) << 16)
        let val3:UInt32 = (UInt32(slice[idx.advanced(by: 1)]) << 8)
        let val4:UInt32 = UInt32(slice[idx])
        let val:UInt32 = val1 | val2 | val3 | val4
        result.append(val)
    }
    return result
}

func toUInt64Array(_ slice: ArraySlice<UInt8>) -> Array<UInt64> {
    var result = Array<UInt64>()
    result.reserveCapacity(32)
    
    for idx in stride(from: slice.startIndex, to: slice.endIndex, by: Int.Stride(sizeof(UInt64))) {
        var val:UInt64 = 0
        val |= UInt64(slice[idx.advanced(by: 7)]) << 56
        val |= UInt64(slice[idx.advanced(by: 6)]) << 48
        val |= UInt64(slice[idx.advanced(by: 5)]) << 40
        val |= UInt64(slice[idx.advanced(by: 4)]) << 32
        val |= UInt64(slice[idx.advanced(by: 3)]) << 24
        val |= UInt64(slice[idx.advanced(by: 2)]) << 16
        val |= UInt64(slice[idx.advanced(by: 1)]) << 8
        val |= UInt64(slice[idx.advanced(by: 0)]) << 0
        result.append(val)
    }
    return result
}

func xor(_ a: [UInt8], _ b:[UInt8]) -> [UInt8] {
    var xored = [UInt8](repeating: 0, count: min(a.count, b.count))
    for i in 0..<xored.count {
        xored[i] = a[i] ^ b[i]
    }
    return xored
}