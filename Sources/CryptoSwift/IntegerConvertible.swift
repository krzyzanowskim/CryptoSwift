//
//  IntegerConvertible.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 02/06/15.
//  Copyright (c) 2015 Marcin Krzyzanowski. All rights reserved.
//

protocol BitshiftOperationsType {
    func <<(lhs: Self, rhs: Self) -> Self
    func >>(lhs: Self, rhs: Self) -> Self
    func <<=(inout lhs: Self, rhs: Self)
    func >>=(inout lhs: Self, rhs: Self)
}

protocol ByteConvertible {
    init(_ value: UInt8)
    init(truncatingBitPattern: UInt64)
}

extension Int    : BitshiftOperationsType, ByteConvertible { }
extension Int8   : BitshiftOperationsType, ByteConvertible { }
extension Int16  : BitshiftOperationsType, ByteConvertible { }
extension Int32  : BitshiftOperationsType, ByteConvertible { }
extension Int64  : BitshiftOperationsType, ByteConvertible {
    init(truncatingBitPattern value: UInt64) {
        self = Int64(bitPattern: value)
    }
}
extension UInt   : BitshiftOperationsType, ByteConvertible { }
extension UInt8  : BitshiftOperationsType, ByteConvertible { }
extension UInt16 : BitshiftOperationsType, ByteConvertible { }
extension UInt32 : BitshiftOperationsType, ByteConvertible { }
extension UInt64 : BitshiftOperationsType, ByteConvertible {
    init(truncatingBitPattern value: UInt64) {
        self = value
    }
}