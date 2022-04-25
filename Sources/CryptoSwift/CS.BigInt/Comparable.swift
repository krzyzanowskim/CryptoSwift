//
//  Comparable.swift
//  CS.BigInt
//
//  Created by Károly Lőrentey on 2016-01-03.
//  Copyright © 2016-2017 Károly Lőrentey.
//

import Foundation

extension CS.BigUInt: Comparable {
    //MARK: Comparison
    
    /// Compare `a` to `b` and return an `NSComparisonResult` indicating their order.
    ///
    /// - Complexity: O(count)
    public static func compare(_ a: CS.BigUInt, _ b: CS.BigUInt) -> ComparisonResult {
        if a.count != b.count { return a.count > b.count ? .orderedDescending : .orderedAscending }
        for i in (0 ..< a.count).reversed() {
            let ad = a[i]
            let bd = b[i]
            if ad != bd { return ad > bd ? .orderedDescending : .orderedAscending }
        }
        return .orderedSame
    }

    /// Return true iff `a` is equal to `b`.
    ///
    /// - Complexity: O(count)
    public static func ==(a: CS.BigUInt, b: CS.BigUInt) -> Bool {
        return CS.BigUInt.compare(a, b) == .orderedSame
    }

    /// Return true iff `a` is less than `b`.
    ///
    /// - Complexity: O(count)
    public static func <(a: CS.BigUInt, b: CS.BigUInt) -> Bool {
        return CS.BigUInt.compare(a, b) == .orderedAscending
    }
}

extension CS.BigInt {
    /// Return true iff `a` is equal to `b`.
    public static func ==(a: CS.BigInt, b: CS.BigInt) -> Bool {
        return a.sign == b.sign && a.magnitude == b.magnitude
    }

    /// Return true iff `a` is less than `b`.
    public static func <(a: CS.BigInt, b: CS.BigInt) -> Bool {
        switch (a.sign, b.sign) {
        case (.plus, .plus):
            return a.magnitude < b.magnitude
        case (.plus, .minus):
            return false
        case (.minus, .plus):
            return true
        case (.minus, .minus):
            return a.magnitude > b.magnitude
        }
    }
}


