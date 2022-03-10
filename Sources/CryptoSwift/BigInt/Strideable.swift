//
//  Strideable.swift
//  BigInt
//
//  Created by Károly Lőrentey on 2017-08-11.
//  Copyright © 2016-2017 Károly Lőrentey.
//

extension BigUInt: Strideable {
    /// A type that can represent the distance between two values ofa `BigUInt`.
    public typealias Stride = BigInt

    /// Adds `n` to `self` and returns the result. Traps if the result would be less than zero.
    public func advanced(by n: BigInt) -> BigUInt {
        return n.sign == .minus ? self - n.magnitude : self + n.magnitude
    }

    /// Returns the (potentially negative) difference between `self` and `other` as a `BigInt`. Never traps.
    public func distance(to other: BigUInt) -> BigInt {
        return BigInt(other) - BigInt(self)
    }
}

extension BigInt: Strideable {
    public typealias Stride = BigInt

    /// Returns `self + n`.
    public func advanced(by n: Stride) -> BigInt {
        return self + n
    }

    /// Returns `other - self`.
    public func distance(to other: BigInt) -> Stride {
        return other - self
    }
}


