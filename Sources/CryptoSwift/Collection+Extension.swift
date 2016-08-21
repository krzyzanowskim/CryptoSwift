//
//  Collection+Extension.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 02/08/16.
//  Copyright © 2016 Marcin Krzyzanowski. All rights reserved.
//

extension Collection where Self.Iterator.Element == UInt8, Self.Index == Int {
    func toUInt32Array() -> Array<UInt32> {
        return stride(from: self.startIndex, to: self.endIndex, by: MemoryLayout<UInt32>.size).map { i in
            return UnsafePointer(Array(self[Range(i..<i.advanced(by:MemoryLayout<UInt32>.size))]))
                .withMemoryRebound(to: UInt32.self, capacity: 1) { $0.pointee }
        }
    }

    func toUInt64Array() -> Array<UInt64> {
        return stride(from: self.startIndex, to: self.endIndex, by: MemoryLayout<UInt64>.size).map { i in
            return UnsafePointer(Array(self[Range(i..<i.advanced(by:MemoryLayout<UInt64>.size))]))
                .withMemoryRebound(to: UInt64.self, capacity: 1) { $0.pointee }
        }
    }

    /// Initialize integer from array of bytes. Caution: may be slow!
    func toInteger<T:Integer>() -> T where T: ByteConvertible, T: BitshiftOperationsType {
        if self.count == 0 {
            return 0;
        }

        var bytes = self.reversed() //FIXME: check it this is equivalent of Array(...)
        if bytes.count < MemoryLayout<T>.size {
            let paddingCount = MemoryLayout<T>.size - bytes.count
            if (paddingCount > 0) {
                bytes += Array<UInt8>(repeating: 0, count: paddingCount)
            }
        }

        if MemoryLayout<T>.size == 1 {
            return T(truncatingBitPattern: UInt64(bytes[0]))
        }

        var result: T = 0
        for byte in bytes.reversed() {
            result = result << 8 | T(byte)
        }
        return result
    }
}
