//
//  Bit.swift
//  CryptoSwift
//
//  Created by Pedro Silva on 29/03/16.
//  Copyright © 2016 Marcin Krzyzanowski. All rights reserved.
//

enum Bit: Int {
    case zero
    case one
}

extension Bit {

    func inverted() -> Bit {
        return self == .zero ? .one : .zero
    }
}
