//
//  Bitwise Ops.swift
//  BigInt
//
//  Created by Károly Lőrentey on 2016-01-03.
//  Copyright © 2016-2017 Károly Lőrentey.
//

//MARK: Bitwise Operations

extension BigUInt {
    /// Return the ones' complement of `a`.
    ///
    /// - Complexity: O(a.count)
    public static prefix func ~(a: BigUInt) -> BigUInt {
        return BigUInt(words: a.words.map { ~$0 })
    }

    /// Calculate the bitwise OR of `a` and `b`, and store the result in `a`.
    ///
    /// - Complexity: O(max(a.count, b.count))
    public static func |= (a: inout BigUInt, b: BigUInt) {
        a.reserveCapacity(b.count)
        for i in 0 ..< b.count {
            a[i] |= b[i]
        }
    }

    /// Calculate the bitwise AND of `a` and `b` and return the result.
    ///
    /// - Complexity: O(max(a.count, b.count))
    public static func &= (a: inout BigUInt, b: BigUInt) {
        for i in 0 ..< Swift.max(a.count, b.count) {
            a[i] &= b[i]
        }
    }

    /// Calculate the bitwise XOR of `a` and `b` and return the result.
    ///
    /// - Complexity: O(max(a.count, b.count))
    public static func ^= (a: inout BigUInt, b: BigUInt) {
        a.reserveCapacity(b.count)
        for i in 0 ..< b.count {
            a[i] ^= b[i]
        }
    }
}

extension BigInt {
    public static prefix func ~(x: BigInt) -> BigInt {
        switch x.sign {
        case .plus:
            return BigInt(sign: .minus, magnitude: x.magnitude + 1)
        case .minus:
            return BigInt(sign: .plus, magnitude: x.magnitude - 1)
        }
    }
    
    public static func &(lhs: inout BigInt, rhs: BigInt) -> BigInt {
        let left = lhs.words
        let right = rhs.words
        // Note we aren't using left.count/right.count here; we account for the sign bit separately later.
        let count = Swift.max(lhs.magnitude.count, rhs.magnitude.count)
        var words: [UInt] = []
        words.reserveCapacity(count)
        for i in 0 ..< count {
            words.append(left[i] & right[i])
        }
        if lhs.sign == .minus && rhs.sign == .minus {
            words.twosComplement()
            return BigInt(sign: .minus, magnitude: BigUInt(words: words))
        }
        return BigInt(sign: .plus, magnitude: BigUInt(words: words))
    }
    
    public static func |(lhs: inout BigInt, rhs: BigInt) -> BigInt {
        let left = lhs.words
        let right = rhs.words
        // Note we aren't using left.count/right.count here; we account for the sign bit separately later.
        let count = Swift.max(lhs.magnitude.count, rhs.magnitude.count)
        var words: [UInt] = []
        words.reserveCapacity(count)
        for i in 0 ..< count {
            words.append(left[i] | right[i])
        }
        if lhs.sign == .minus || rhs.sign == .minus {
            words.twosComplement()
            return BigInt(sign: .minus, magnitude: BigUInt(words: words))
        }
        return BigInt(sign: .plus, magnitude: BigUInt(words: words))
    }
    
    public static func ^(lhs: inout BigInt, rhs: BigInt) -> BigInt {
        let left = lhs.words
        let right = rhs.words
        // Note we aren't using left.count/right.count here; we account for the sign bit separately later.
        let count = Swift.max(lhs.magnitude.count, rhs.magnitude.count)
        var words: [UInt] = []
        words.reserveCapacity(count)
        for i in 0 ..< count {
            words.append(left[i] ^ right[i])
        }
        if (lhs.sign == .minus) != (rhs.sign == .minus) {
            words.twosComplement()
            return BigInt(sign: .minus, magnitude: BigUInt(words: words))
        }
        return BigInt(sign: .plus, magnitude: BigUInt(words: words))
    }
    
    public static func &=(lhs: inout BigInt, rhs: BigInt) {
        lhs = lhs & rhs
    }
    
    public static func |=(lhs: inout BigInt, rhs: BigInt) {
        lhs = lhs | rhs
    }
    
    public static func ^=(lhs: inout BigInt, rhs: BigInt) {
        lhs = lhs ^ rhs
    }
}
