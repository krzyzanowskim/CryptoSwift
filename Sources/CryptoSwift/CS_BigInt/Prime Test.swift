//
//  Prime Test.swift
//  CS.BigInt
//
//  Created by Károly Lőrentey on 2016-01-04.
//  Copyright © 2016-2017 Károly Lőrentey.
//

/// The first several [prime numbers][primes]. 
///
/// [primes]: https://oeis.org/A000040
let primes: [CS.BigUInt.Word] = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41]

/// The ith element in this sequence is the smallest composite number that passes the strong probable prime test
/// for all of the first (i+1) primes.
///
/// This is sequence [A014233](http://oeis.org/A014233) on the [Online Encyclopaedia of Integer Sequences](http://oeis.org).
let pseudoPrimes: [CS.BigUInt] = [
    /*  2 */ 2_047,
    /*  3 */ 1_373_653,
    /*  5 */ 25_326_001,
    /*  7 */ 3_215_031_751,
    /* 11 */ 2_152_302_898_747,
    /* 13 */ 3_474_749_660_383,
    /* 17 */ 341_550_071_728_321,
    /* 19 */ 341_550_071_728_321,
    /* 23 */ 3_825_123_056_546_413_051,
    /* 29 */ 3_825_123_056_546_413_051,
    /* 31 */ 3_825_123_056_546_413_051,
    /* 37 */ "318665857834031151167461",
    /* 41 */ "3317044064679887385961981",
]

extension CS.BigUInt {
    //MARK: Primality Testing

    /// Returns true iff this integer passes the [strong probable prime test][sppt] for the specified base.
    ///
    /// [sppt]: https://en.wikipedia.org/wiki/Probable_prime
    public func isStrongProbablePrime(_ base: CS.BigUInt) -> Bool {
        precondition(base > (1 as CS.BigUInt))
        precondition(self > (0 as CS.BigUInt))
        let dec = self - 1

        let r = dec.trailingZeroBitCount
        let d = dec >> r

        var test = base.power(d, modulus: self)
        if test == 1 || test == dec { return true }

        if r > 0 {
            let shift = self.leadingZeroBitCount
            let normalized = self << shift
            for _ in 1 ..< r {
                test *= test
                test.formRemainder(dividingBy: normalized, normalizedBy: shift)
                if test == 1 {
                    return false
                }
                if test == dec { return true }
            }
        }
        return false
    }

    /// Returns true if this integer is probably prime. Returns false if this integer is definitely not prime.
    ///
    /// This function performs a probabilistic [Miller-Rabin Primality Test][mrpt], consisting of `rounds` iterations, 
    /// each calculating the strong probable prime test for a random base. The number of rounds is 10 by default,
    /// but you may specify your own choice.
    ///
    /// To speed things up, the function checks if `self` is divisible by the first few prime numbers before
    /// diving into (slower) Miller-Rabin testing.
    ///
    /// Also, when `self` is less than 82 bits wide, `isPrime` does a deterministic test that is guaranteed to 
    /// return a correct result.
    ///
    /// [mrpt]: https://en.wikipedia.org/wiki/Miller–Rabin_primality_test
    public func isPrime(rounds: Int = 10) -> Bool {
        if count <= 1 && self[0] < 2 { return false }
        if count == 1 && self[0] < 4 { return true }

        // Even numbers above 2 aren't prime.
        if self[0] & 1 == 0 { return false }

        // Quickly check for small primes.
        for i in 1 ..< primes.count {
            let p = primes[i]
            if self.count == 1 && self[0] == p {
                return true
            }
            if self.quotientAndRemainder(dividingByWord: p).remainder == 0 {
                return false
            }
        }

        /// Give an exact answer when we can.
        if self < pseudoPrimes.last! {
            for i in 0 ..< pseudoPrimes.count {
                guard isStrongProbablePrime(CS.BigUInt(primes[i])) else {
                    break
                }
                if self < pseudoPrimes[i] {
                    // `self` is below the lowest pseudoprime corresponding to the prime bases we tested. It's a prime!
                    return true
                }
            }
            return false
        }

        /// Otherwise do as many rounds of random SPPT as required.
        for _ in 0 ..< rounds {
            let random = CS.BigUInt.randomInteger(lessThan: self - 2) + 2
            guard isStrongProbablePrime(random) else {
                return false
            }
        }

        // Well, it smells primey to me.
        return true
    }
}

extension CS.BigInt {
    //MARK: Primality Testing

    /// Returns true iff this integer passes the [strong probable prime test][sppt] for the specified base.
    ///
    /// [sppt]: https://en.wikipedia.org/wiki/Probable_prime
    public func isStrongProbablePrime(_ base: CS.BigInt) -> Bool {
        precondition(base.sign == .plus)
        if self.sign == .minus { return false }
        return self.magnitude.isStrongProbablePrime(base.magnitude)
    }

    /// Returns true if this integer is probably prime. Returns false if this integer is definitely not prime.
    ///
    /// This function performs a probabilistic [Miller-Rabin Primality Test][mrpt], consisting of `rounds` iterations,
    /// each calculating the strong probable prime test for a random base. The number of rounds is 10 by default,
    /// but you may specify your own choice.
    ///
    /// To speed things up, the function checks if `self` is divisible by the first few prime numbers before
    /// diving into (slower) Miller-Rabin testing.
    ///
    /// Also, when `self` is less than 82 bits wide, `isPrime` does a deterministic test that is guaranteed to
    /// return a correct result.
    ///
    /// [mrpt]: https://en.wikipedia.org/wiki/Miller–Rabin_primality_test
    public func isPrime(rounds: Int = 10) -> Bool {
        if self.sign == .minus { return false }
        return self.magnitude.isPrime(rounds: rounds)
    }
}
