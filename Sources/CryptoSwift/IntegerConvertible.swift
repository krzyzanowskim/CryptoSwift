//
//  IntegerConvertible.swift
//  CryptoSwift
//
//  Copyright (C) 2014-2017 Krzyżanowski <marcin@krzyzanowskim.com>
//  This software is provided 'as-is', without any express or implied warranty.
//
//  In no event will the authors be held liable for any damages arising from the use of this software.
//
//  Permission is granted to anyone to use this software for any purpose,including commercial applications, and to alter it and redistribute it freely, subject to the following restrictions:
//
//  - The origin of this software must not be misrepresented; you must not claim that you wrote the original software. If you use this software in a product, an acknowledgment in the product documentation is required.
//  - Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.
//  - This notice may not be removed or altered from any source or binary distribution.
//

protocol BitshiftOperationsType {
    static func <<(lhs: Self, rhs: Self) -> Self
    static func >>(lhs: Self, rhs: Self) -> Self
    static func <<=(lhs: inout Self, rhs: Self)
    static func >>=(lhs: inout Self, rhs: Self)
}

protocol ByteConvertible {
    init(_ value: UInt8)
    init(truncatingBitPattern: UInt64)
}

extension Int: BitshiftOperationsType, ByteConvertible {}
extension Int8: BitshiftOperationsType, ByteConvertible {}
extension Int16: BitshiftOperationsType, ByteConvertible {}
extension Int32: BitshiftOperationsType, ByteConvertible {}

extension Int64: BitshiftOperationsType, ByteConvertible {

    init(truncatingBitPattern value: UInt64) {
        self = Int64(bitPattern: value)
    }
}

extension UInt: BitshiftOperationsType, ByteConvertible {}
extension UInt8: BitshiftOperationsType, ByteConvertible {}
extension UInt16: BitshiftOperationsType, ByteConvertible {}
extension UInt32: BitshiftOperationsType, ByteConvertible {}

extension UInt64: BitshiftOperationsType, ByteConvertible {

    init(truncatingBitPattern value: UInt64) {
        self = value
    }
}
