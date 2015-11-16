//
//  ArraySlice.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 27/09/15.
//  Copyright © 2015 Marcin Krzyzanowski. All rights reserved.
//
//  Disabled because performance is bad. The cost of generic approach is to big.

/*
extension ArraySlice where Element: _UInt8Type {

    func toUInt32Array() -> Array<UInt32> {
        var result = Array<UInt32>()
        result.reserveCapacity(16)
        
        for idx in self.startIndex.stride(to: self.endIndex, by: sizeof(UInt32)) {
            let val:UInt32 = (UInt32(self[idx.advancedBy(3)] as! UInt8) << 24) | (UInt32(self[idx.advancedBy(2)] as! UInt8) << 16) | (UInt32(self[idx.advancedBy(1)] as! UInt8) << 8) | UInt32(self[idx] as! UInt8)
            result.append(val)
        }
        return result
    }
    
    func toUInt64Array() -> Array<UInt64> {
        var result = Array<UInt64>()
        result.reserveCapacity(32)
        for idx in self.startIndex.stride(to: self.endIndex, by: sizeof(UInt64)) {
            var val:UInt64 = 0
            val |= UInt64(self[idx.advancedBy(7)] as! UInt8) << 56
            val |= UInt64(self[idx.advancedBy(6)] as! UInt8) << 48
            val |= UInt64(self[idx.advancedBy(5)] as! UInt8) << 40
            val |= UInt64(self[idx.advancedBy(4)] as! UInt8) << 32
            val |= UInt64(self[idx.advancedBy(3)] as! UInt8) << 24
            val |= UInt64(self[idx.advancedBy(2)] as! UInt8) << 16
            val |= UInt64(self[idx.advancedBy(1)] as! UInt8) << 8
            val |= UInt64(self[idx.advancedBy(0)] as! UInt8) << 0
            result.append(val)
        }
        return result
    }
}
*/
