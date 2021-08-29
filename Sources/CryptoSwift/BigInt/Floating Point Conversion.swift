//
//  Floating Point Conversion.swift
//  BigInt
//
//  Created by Károly Lőrentey on 2017-08-11.
//  Copyright © 2016-2017 Károly Lőrentey.
//

extension BigUInt {
    public init?<T: BinaryFloatingPoint>(exactly source: T) {
        guard source.isFinite else { return nil }
        guard !source.isZero else { self = 0; return }
        guard source.sign == .plus else { return nil }
        let value = source.rounded(.towardZero)
        guard value == source else { return nil }
        assert(value.floatingPointClass == .positiveNormal)
        assert(value.exponent >= 0)
        let significand = value.significandBitPattern
        self = (BigUInt(1) << value.exponent) + BigUInt(significand) >> (T.significandBitCount - Int(value.exponent))
    }

    public init<T: BinaryFloatingPoint>(_ source: T) {
        self.init(exactly: source.rounded(.towardZero))!
    }
}

extension BigInt {
    public init?<T: BinaryFloatingPoint>(exactly source: T) {
        switch source.sign{
        case .plus:
            guard let magnitude = BigUInt(exactly: source) else { return nil }
            self = BigInt(sign: .plus, magnitude: magnitude)
        case .minus:
            guard let magnitude = BigUInt(exactly: -source) else { return nil }
            self = BigInt(sign: .minus, magnitude: magnitude)
        }
    }

    public init<T: BinaryFloatingPoint>(_ source: T) {
        self.init(exactly: source.rounded(.towardZero))!
    }
}

extension BinaryFloatingPoint where RawExponent: FixedWidthInteger, RawSignificand: FixedWidthInteger {
    public init(_ value: BigInt) {
        guard !value.isZero else { self = 0; return }
        let v = value.magnitude
        let bitWidth = v.bitWidth
        var exponent = bitWidth - 1
        let shift = bitWidth - Self.significandBitCount - 1
        var significand = value.magnitude >> (shift - 1)
        if significand[0] & 3 == 3 { // Handle rounding
            significand >>= 1
            significand += 1
            if significand.trailingZeroBitCount >= Self.significandBitCount {
                exponent += 1
            }
        }
        else {
            significand >>= 1
        }
        let bias = 1 << (Self.exponentBitCount - 1) - 1
        guard exponent <= bias else { self = Self.infinity; return }
        significand &= 1 << Self.significandBitCount - 1
        self = Self.init(sign: value.sign == .plus ? .plus : .minus,
                         exponentBitPattern: RawExponent(bias + exponent),
                         significandBitPattern: RawSignificand(significand))
    }

    public init(_ value: BigUInt) {
        self.init(BigInt(sign: .plus, magnitude: value))
    }
}
