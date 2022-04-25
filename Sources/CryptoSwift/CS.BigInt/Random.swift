//
//  Random.swift
//  CS.BigInt
//
//  Created by Károly Lőrentey on 2016-01-04.
//  Copyright © 2016-2017 Károly Lőrentey.
//

extension CS.BigUInt {
    /// Create a big unsigned integer consisting of `width` uniformly distributed random bits.
    ///
    /// - Parameter width: The maximum number of one bits in the result.
    /// - Parameter generator: The source of randomness.
    /// - Returns: A big unsigned integer less than `1 << width`.
    public static func randomInteger<RNG: RandomNumberGenerator>(withMaximumWidth width: Int, using generator: inout RNG) -> CS.BigUInt {
        var result = CS.BigUInt.zero
        var bitsLeft = width
        var i = 0
        let wordsNeeded = (width + Word.bitWidth - 1) / Word.bitWidth
        if wordsNeeded > 2 {
            result.reserveCapacity(wordsNeeded)
        }
        while bitsLeft >= Word.bitWidth {
            result[i] = generator.next()
            i += 1
            bitsLeft -= Word.bitWidth
        }
        if bitsLeft > 0 {
            let mask: Word = (1 << bitsLeft) - 1
            result[i] = (generator.next() as Word) & mask
        }
        return result
    }

    /// Create a big unsigned integer consisting of `width` uniformly distributed random bits.
    ///
    /// - Note: I use a `SystemRandomGeneratorGenerator` as the source of randomness.
    ///
    /// - Parameter width: The maximum number of one bits in the result.
    /// - Returns: A big unsigned integer less than `1 << width`.
    public static func randomInteger(withMaximumWidth width: Int) -> CS.BigUInt {
        var rng = SystemRandomNumberGenerator()
        return randomInteger(withMaximumWidth: width, using: &rng)
    }

    /// Create a big unsigned integer consisting of `width-1` uniformly distributed random bits followed by a one bit.
    ///
    /// - Note: If `width` is zero, the result is zero.
    ///
    /// - Parameter width: The number of bits required to represent the answer.
    /// - Parameter generator: The source of randomness.
    /// - Returns: A random big unsigned integer whose width is `width`.
    public static func randomInteger<RNG: RandomNumberGenerator>(withExactWidth width: Int, using generator: inout RNG) -> CS.BigUInt {
        // width == 0 -> return 0 because there is no room for a one bit.
        // width == 1 -> return 1 because there is no room for any random bits.
        guard width > 1 else { return CS.BigUInt(width) }
        var result = randomInteger(withMaximumWidth: width - 1, using: &generator)
        result[(width - 1) / Word.bitWidth] |= 1 << Word((width - 1) % Word.bitWidth)
        return result
    }

    /// Create a big unsigned integer consisting of `width-1` uniformly distributed random bits followed by a one bit.
    ///
    /// - Note: If `width` is zero, the result is zero.
    /// - Note: I use a `SystemRandomGeneratorGenerator` as the source of randomness.
    ///
    /// - Returns: A random big unsigned integer whose width is `width`.
    public static func randomInteger(withExactWidth width: Int) -> CS.BigUInt {
        var rng = SystemRandomNumberGenerator()
        return randomInteger(withExactWidth: width, using: &rng)
    }

    /// Create a uniformly distributed random unsigned integer that's less than the specified limit.
    ///
    /// - Precondition: `limit > 0`.
    ///
    /// - Parameter limit: The upper bound on the result.
    /// - Parameter generator: The source of randomness.
    /// - Returns: A random big unsigned integer that is less than `limit`.
    public static func randomInteger<RNG: RandomNumberGenerator>(lessThan limit: CS.BigUInt, using generator: inout RNG) -> CS.BigUInt {
        precondition(limit > 0, "\(#function): 0 is not a valid limit")
        let width = limit.bitWidth
        var random = randomInteger(withMaximumWidth: width, using: &generator)
        while random >= limit {
            random = randomInteger(withMaximumWidth: width, using: &generator)
        }
        return random
    }

    /// Create a uniformly distributed random unsigned integer that's less than the specified limit.
    ///
    /// - Precondition: `limit > 0`.
    /// - Note: I use a `SystemRandomGeneratorGenerator` as the source of randomness.
    ///
    /// - Parameter limit: The upper bound on the result.
    /// - Returns: A random big unsigned integer that is less than `limit`.
    public static func randomInteger(lessThan limit: CS.BigUInt) -> CS.BigUInt {
        var rng = SystemRandomNumberGenerator()
        return randomInteger(lessThan: limit, using: &rng)
    }
}
