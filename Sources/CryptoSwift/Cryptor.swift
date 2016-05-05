//
//  Cryptor.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 06/05/16.
//  Copyright © 2016 Marcin Krzyzanowski. All rights reserved.
//

public protocol Cryptor {
    mutating func update(bytes:[UInt8], isLast: Bool) throws -> [UInt8]
}