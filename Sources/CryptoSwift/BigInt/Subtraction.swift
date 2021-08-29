//
//  Subtraction.swift
//  BigInt
//
//  Created by Károly Lőrentey on 2016-01-03.
//  Copyright © 2016-2017 Károly Lőrentey.
//

extension BigUInt {
    //MARK: Subtraction

    /// Subtract `word` from this integer in place, returning a flag indicating if the operation
    /// caused an arithmetic overflow. `word` is shifted `shift` words to the left before being subtracted.
    ///
    /// - Note: If the result indicates an overflow, then `self` becomes the two's complement of the absolute difference.
    /// - Complexity: O(count)
    internal mutating func subtractWordReportingOverflow(_ word: Word, shiftedBy shift: Int = 0) -> Bool {
        precondition(shift >= 0)
        var carry: Word = word
        var i = shift
        let count = self.count
        while carry > 0 && i < count {
            let (d, c) = self[i].subtractingReportingOverflow(carry)
            self[i] = d
            carry = (c ? 1 : 0)
            i += 1
        }
        return carry > 0
    }

    /// Subtract `word` from this integer, returning the difference and a flag that is true if the operation
    /// caused an arithmetic overflow. `word` is shifted `shift` words to the left before being subtracted.
    ///
    /// - Note: If `overflow` is true, then the returned value is the two's complement of the absolute difference.
    /// - Complexity: O(count)
    internal func subtractingWordReportingOverflow(_ word: Word, shiftedBy shift: Int = 0) -> (partialValue: BigUInt, overflow: Bool) {
        var result = self
        let overflow = result.subtractWordReportingOverflow(word, shiftedBy: shift)
        return (result, overflow)
    }

    /// Subtract a digit `d` from this integer in place.
    /// `d` is shifted `shift` digits to the left before being subtracted.
    ///
    /// - Requires: self >= d * 2^shift
    /// - Complexity: O(count)
    internal mutating func subtractWord(_ word: Word, shiftedBy shift: Int = 0) {
        let overflow = subtractWordReportingOverflow(word, shiftedBy: shift)
        precondition(!overflow)
    }

    /// Subtract a digit `d` from this integer and return the result.
    /// `d` is shifted `shift` digits to the left before being subtracted.
    ///
    /// - Requires: self >= d * 2^shift
    /// - Complexity: O(count)
    internal func subtractingWord(_ word: Word, shiftedBy shift: Int = 0) -> BigUInt {
        var result = self
        result.subtractWord(word, shiftedBy: shift)
        return result
    }

    /// Subtract `other` from this integer in place, and return a flag indicating if the operation caused an
    /// arithmetic overflow. `other` is shifted `shift` digits to the left before being subtracted.
    ///
    /// - Note: If the result indicates an overflow, then `self` becomes the twos' complement of the absolute difference.
    /// - Complexity: O(count)
    public mutating func subtractReportingOverflow(_ b: BigUInt, shiftedBy shift: Int = 0) -> Bool {
        precondition(shift >= 0)
        var carry = false
        var bi = 0
        let bc = b.count
        let count = self.count
        while bi < bc || (shift + bi < count && carry) {
            let ai = shift + bi
            let (d, c) = self[ai].subtractingReportingOverflow(b[bi])
            if carry {
                let (d2, c2) = d.subtractingReportingOverflow(1)
                self[ai] = d2
                carry = c || c2
            }
            else {
                self[ai] = d
                carry = c
            }
            bi += 1
        }
        return carry
    }

    /// Subtract `other` from this integer, returning the difference and a flag indicating arithmetic overflow.
    /// `other` is shifted `shift` digits to the left before being subtracted.
    ///
    /// - Note: If `overflow` is true, then the result value is the twos' complement of the absolute value of the difference.
    /// - Complexity: O(count)
    public func subtractingReportingOverflow(_ other: BigUInt, shiftedBy shift: Int) -> (partialValue: BigUInt, overflow: Bool) {
        var result = self
        let overflow = result.subtractReportingOverflow(other, shiftedBy: shift)
        return (result, overflow)
    }
    
    /// Subtracts `other` from `self`, returning the result and a flag indicating arithmetic overflow.
    ///
    /// - Note: When the operation overflows, then `partialValue` is the twos' complement of the absolute value of the difference.
    /// - Complexity: O(count)
    public func subtractingReportingOverflow(_ other: BigUInt) -> (partialValue: BigUInt, overflow: Bool) {
        return self.subtractingReportingOverflow(other, shiftedBy: 0)
    }
    
    /// Subtract `other` from this integer in place.
    /// `other` is shifted `shift` digits to the left before being subtracted.
    ///
    /// - Requires: self >= other * 2^shift
    /// - Complexity: O(count)
    public mutating func subtract(_ other: BigUInt, shiftedBy shift: Int = 0) {
        let overflow = subtractReportingOverflow(other, shiftedBy: shift)
        precondition(!overflow)
    }

    /// Subtract `b` from this integer, and return the difference.
    /// `b` is shifted `shift` digits to the left before being subtracted.
    ///
    /// - Requires: self >= b * 2^shift
    /// - Complexity: O(count)
    public func subtracting(_ other: BigUInt, shiftedBy shift: Int = 0) -> BigUInt {
        var result = self
        result.subtract(other, shiftedBy: shift)
        return result
    }

    /// Decrement this integer by one.
    ///
    /// - Requires: !isZero
    /// - Complexity: O(count)
    public mutating func decrement(shiftedBy shift: Int = 0) {
        self.subtract(1, shiftedBy: shift)
    }

    /// Subtract `b` from `a` and return the result.
    ///
    /// - Requires: a >= b
    /// - Complexity: O(a.count)
    public static func -(a: BigUInt, b: BigUInt) -> BigUInt {
        return a.subtracting(b)
    }

    /// Subtract `b` from `a` and store the result in `a`.
    ///
    /// - Requires: a >= b
    /// - Complexity: O(a.count)
    public static func -=(a: inout BigUInt, b: BigUInt) {
        a.subtract(b)
    }
}

extension BigInt {
    public mutating func negate() {
        guard !magnitude.isZero else { return }
        self.sign = self.sign == .plus ? .minus : .plus
    }

    /// Subtract `b` from `a` and return the result.
    public static func -(a: BigInt, b: BigInt) -> BigInt {
        return a + -b
    }

    /// Subtract `b` from `a` in place.
    public static func -=(a: inout BigInt, b: BigInt) { a = a - b }
}
