//
//  Collection+Extension.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 02/08/16.
//  Copyright © 2016 Marcin Krzyzanowski. All rights reserved.
//

extension Collection where Self.Iterator.Element == UInt8, Self.Index == Int {
    func toUInt32Array() -> Array<UInt32> {
        var result = Array<UInt32>()
        result.reserveCapacity(16)
        for idx in stride(from: self.startIndex, to: self.endIndex, by: sizeof(UInt32.self)) {
            let val1:UInt32 = (UInt32(self[idx.advanced(by: 3)]) << 24)
            let val2:UInt32 = (UInt32(self[idx.advanced(by: 2)]) << 16)
            let val3:UInt32 = (UInt32(self[idx.advanced(by: 1)]) << 8)
            let val4:UInt32 = UInt32(self[idx])
            let val:UInt32 = val1 | val2 | val3 | val4
            result.append(val)
        }
        return result
    }

    func toUInt64Array() -> Array<UInt64> {
        var result = Array<UInt64>()
        result.reserveCapacity(32)
        for idx in stride(from: self.startIndex, to: self.endIndex, by: sizeof(UInt64.self)) {
            var val:UInt64 = 0
            val |= UInt64(self[idx.advanced(by: 7)]) << 56
            val |= UInt64(self[idx.advanced(by: 6)]) << 48
            val |= UInt64(self[idx.advanced(by: 5)]) << 40
            val |= UInt64(self[idx.advanced(by: 4)]) << 32
            val |= UInt64(self[idx.advanced(by: 3)]) << 24
            val |= UInt64(self[idx.advanced(by: 2)]) << 16
            val |= UInt64(self[idx.advanced(by: 1)]) << 8
            val |= UInt64(self[idx.advanced(by: 0)]) << 0
            result.append(val)
        }
        return result
    }

    /// Initialize integer from array of bytes. Caution: may be slow!
    func toInteger<T:Integer>() -> T where T: ByteConvertible, T: BitshiftOperationsType {
        if self.count == 0 {
            return 0;
        }

        var bytes = self.reversed() //FIXME: check it this is equivalent of Array(...)
        if bytes.count < sizeof(T.self) {
            let paddingCount = sizeof(T.self) - bytes.count
            if (paddingCount > 0) {
                bytes += Array<UInt8>(repeating: 0, count: paddingCount)
            }
        }

        if sizeof(T.self) == 1 {
            return T(truncatingBitPattern: UInt64(bytes[0]))
        }

        var result: T = 0
        for byte in bytes.reversed() {
            result = result << 8 | T(byte)
        }
        return result
    }
}
