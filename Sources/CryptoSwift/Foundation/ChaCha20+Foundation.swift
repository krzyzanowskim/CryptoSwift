//
//  ChaCha20+Foundation.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 27/09/15.
//  Copyright © 2015 Marcin Krzyzanowski. All rights reserved.
//

import Foundation

extension ChaCha20 {

    public convenience init(key: String, iv: String) throws {
        guard let kkey = key.data(using: String.Encoding.utf8, allowLossyConversion: false)?.bytes, let iiv = iv.data(using: String.Encoding.utf8, allowLossyConversion: false)?.bytes else {
            throw Error.invalidKeyOrInitializationVector
        }
        try self.init(key: kkey, iv: iiv)
    }
}
