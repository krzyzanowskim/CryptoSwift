//
//  BitExtension.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 01/09/14.
//  Copyright (c) 2014 Marcin Krzyzanowski. All rights reserved.
//

extension Bit {
    func inverted() -> Bit {
        if (self == Bit.Zero) {
            return Bit.One
        }

        return Bit.Zero
    }
}
