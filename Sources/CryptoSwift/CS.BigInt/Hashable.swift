//
//  Hashable.swift
//  BigInt
//
//  Created by Károly Lőrentey on 2016-01-03.
//  Copyright © 2016-2017 Károly Lőrentey.
//

extension CS.BigUInt: Hashable {
    //MARK: Hashing

    /// Append this `BigUInt` to the specified hasher.
    public func hash(into hasher: inout Hasher) {
        for word in self.words {
            hasher.combine(word)
        }
    }
}

extension CS.BigInt: Hashable {
    /// Append this `BigInt` to the specified hasher.
    public func hash(into hasher: inout Hasher) {
        hasher.combine(sign)
        hasher.combine(magnitude)
    }
}
