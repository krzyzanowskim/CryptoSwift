//
//  GCD.swift
//  CS.BigInt
//
//  Created by Károly Lőrentey on 2016-01-03.
//  Copyright © 2016-2017 Károly Lőrentey.
//

extension CS.BigUInt {
    //MARK: Greatest Common Divisor
    
    /// Returns the greatest common divisor of `self` and `b`.
    ///
    /// - Complexity: O(count^2) where count = max(self.count, b.count)
    public func greatestCommonDivisor(with b: CS.BigUInt) -> CS.BigUInt {
        // This is Stein's algorithm: https://en.wikipedia.org/wiki/Binary_GCD_algorithm
        if self.isZero { return b }
        if b.isZero { return self }

        let az = self.trailingZeroBitCount
        let bz = b.trailingZeroBitCount
        let twos = Swift.min(az, bz)

        var (x, y) = (self >> az, b >> bz)
        if x < y { swap(&x, &y) }

        while !x.isZero {
            x >>= x.trailingZeroBitCount
            if x < y { swap(&x, &y) }
            x -= y
        }
        return y << twos
    }
    
    /// Returns the [multiplicative inverse of this integer in modulo `modulus` arithmetic][inverse],
    /// or `nil` if there is no such number.
    /// 
    /// [inverse]: https://en.wikipedia.org/wiki/Extended_Euclidean_algorithm#Modular_integers
    ///
    /// - Returns: If `gcd(self, modulus) == 1`, the value returned is an integer `a < modulus` such that `(a * self) % modulus == 1`. If `self` and `modulus` aren't coprime, the return value is `nil`.
    /// - Requires: modulus > 1
    /// - Complexity: O(count^3)
    public func inverse(_ modulus: CS.BigUInt) -> CS.BigUInt? {
        precondition(modulus > 1)
        var t1 = CS.BigInt(0)
        var t2 = CS.BigInt(1)
        var r1 = modulus
        var r2 = self
        while !r2.isZero {
            let quotient = r1 / r2
            (t1, t2) = (t2, t1 - CS.BigInt(quotient) * t2)
            (r1, r2) = (r2, r1 - quotient * r2)
        }
        if r1 > 1 { return nil }
        if t1.sign == .minus { return modulus - t1.magnitude }
        return t1.magnitude
    }
}

extension CS.BigInt {
    /// Returns the greatest common divisor of `a` and `b`.
    ///
    /// - Complexity: O(count^2) where count = max(a.count, b.count)
    public func greatestCommonDivisor(with b: CS.BigInt) -> CS.BigInt {
        return CS.BigInt(self.magnitude.greatestCommonDivisor(with: b.magnitude))
    }

    /// Returns the [multiplicative inverse of this integer in modulo `modulus` arithmetic][inverse],
    /// or `nil` if there is no such number.
    ///
    /// [inverse]: https://en.wikipedia.org/wiki/Extended_Euclidean_algorithm#Modular_integers
    ///
    /// - Returns: If `gcd(self, modulus) == 1`, the value returned is an integer `a < modulus` such that `(a * self) % modulus == 1`. If `self` and `modulus` aren't coprime, the return value is `nil`.
    /// - Requires: modulus.magnitude > 1
    /// - Complexity: O(count^3)
    public func inverse(_ modulus: CS.BigInt) -> CS.BigInt? {
        guard let inv = self.magnitude.inverse(modulus.magnitude) else { return nil }
        return CS.BigInt(self.sign == .plus || inv.isZero ? inv : modulus.magnitude - inv)
    }
}
