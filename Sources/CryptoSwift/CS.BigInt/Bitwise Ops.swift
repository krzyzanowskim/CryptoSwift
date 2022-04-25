//
//  Bitwise Ops.swift
//  CS.BigInt
//
//  Created by Károly Lőrentey on 2016-01-03.
//  Copyright © 2016-2017 Károly Lőrentey.
//

//MARK: Bitwise Operations

extension CS.BigUInt {
    /// Return the ones' complement of `a`.
    ///
    /// - Complexity: O(a.count)
    public static prefix func ~(a: CS.BigUInt) -> CS.BigUInt {
        return CS.BigUInt(words: a.words.map { ~$0 })
    }

    /// Calculate the bitwise OR of `a` and `b`, and store the result in `a`.
    ///
    /// - Complexity: O(max(a.count, b.count))
    public static func |= (a: inout CS.BigUInt, b: CS.BigUInt) {
        a.reserveCapacity(b.count)
        for i in 0 ..< b.count {
            a[i] |= b[i]
        }
    }

    /// Calculate the bitwise AND of `a` and `b` and return the result.
    ///
    /// - Complexity: O(max(a.count, b.count))
    public static func &= (a: inout CS.BigUInt, b: CS.BigUInt) {
        for i in 0 ..< Swift.max(a.count, b.count) {
            a[i] &= b[i]
        }
    }

    /// Calculate the bitwise XOR of `a` and `b` and return the result.
    ///
    /// - Complexity: O(max(a.count, b.count))
    public static func ^= (a: inout CS.BigUInt, b: CS.BigUInt) {
        a.reserveCapacity(b.count)
        for i in 0 ..< b.count {
            a[i] ^= b[i]
        }
    }
}

extension CS.BigInt {
    public static prefix func ~(x: CS.BigInt) -> CS.BigInt {
        switch x.sign {
        case .plus:
            return CS.BigInt(sign: .minus, magnitude: x.magnitude + 1)
        case .minus:
            return CS.BigInt(sign: .plus, magnitude: x.magnitude - 1)
        }
    }
    
    public static func &(lhs: inout CS.BigInt, rhs: CS.BigInt) -> CS.BigInt {
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
            return CS.BigInt(sign: .minus, magnitude: CS.BigUInt(words: words))
        }
        return CS.BigInt(sign: .plus, magnitude: CS.BigUInt(words: words))
    }
    
    public static func |(lhs: inout CS.BigInt, rhs: CS.BigInt) -> CS.BigInt {
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
            return CS.BigInt(sign: .minus, magnitude: CS.BigUInt(words: words))
        }
        return CS.BigInt(sign: .plus, magnitude: CS.BigUInt(words: words))
    }
    
    public static func ^(lhs: inout CS.BigInt, rhs: CS.BigInt) -> CS.BigInt {
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
            return CS.BigInt(sign: .minus, magnitude: CS.BigUInt(words: words))
        }
        return CS.BigInt(sign: .plus, magnitude: CS.BigUInt(words: words))
    }
    
    public static func &=(lhs: inout CS.BigInt, rhs: CS.BigInt) {
        lhs = lhs & rhs
    }
    
    public static func |=(lhs: inout CS.BigInt, rhs: CS.BigInt) {
        lhs = lhs | rhs
    }
    
    public static func ^=(lhs: inout CS.BigInt, rhs: CS.BigInt) {
        lhs = lhs ^ rhs
    }
}
