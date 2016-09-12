//
//  Rabbit+Foundation.swift
//  CryptoSwift
//
//  Created by Dima Kalachov on 13/11/15.
//  Copyright © 2015 Marcin Krzyzanowski. All rights reserved.
//

import Foundation

extension Rabbit {
    convenience public init(key: String) throws {
        guard let kkey = key.data(using: String.Encoding.utf8, allowLossyConversion: false)?.bytes else {
            throw Error.invalidKeyOrInitializationVector
        }
        try self.init(key: kkey)
    }
    
    convenience public init(key: String, iv: String) throws {
        guard let kkey = key.data(using: String.Encoding.utf8, allowLossyConversion: false)?.bytes,
              let iiv = iv.data(using: String.Encoding.utf8, allowLossyConversion: false)?.bytes
        else {
            throw Error.invalidKeyOrInitializationVector
        }

        try self.init(key: kkey, iv: iiv)
    }
}
