//
//  Bit.swift
//  CryptoSwift
//
//  Created by Pedro Silva on 29/03/16.
//  Copyright © 2016 Marcin Krzyzanowski. All rights reserved.
//

enum Bit: Int {
    case Zero
    case One
}

extension Bit {
    func inverted() -> Bit {
        return self == .Zero ? .One : .Zero
    }
}
