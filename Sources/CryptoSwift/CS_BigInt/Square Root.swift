//
//  Square Root.swift
//  CS.BigInt
//
//  Created by Károly Lőrentey on 2016-01-03.
//  Copyright © 2016-2017 Károly Lőrentey.
//

//MARK: Square Root

extension CS.BigUInt {
    /// Returns the integer square root of a big integer; i.e., the largest integer whose square isn't greater than `value`.
    ///
    /// - Returns: floor(sqrt(self))
    public func squareRoot() -> CS.BigUInt {
        // This implementation uses Newton's method.
        guard !self.isZero else { return CS.BigUInt() }
        var x = CS.BigUInt(1) << ((self.bitWidth + 1) / 2)
        var y: CS.BigUInt = 0
        while true {
            y.load(self)
            y /= x
            y += x
            y >>= 1
            if x == y || x == y - 1 { break }
            x = y
        }
        return x
    }
}

extension CS.BigInt {
    /// Returns the integer square root of a big integer; i.e., the largest integer whose square isn't greater than `value`.
    ///
    /// - Requires: self >= 0
    /// - Returns: floor(sqrt(self))
    public func squareRoot() -> CS.BigInt {
        precondition(self.sign == .plus)
        return CS.BigInt(sign: .plus, magnitude: self.magnitude.squareRoot())
    }
}
