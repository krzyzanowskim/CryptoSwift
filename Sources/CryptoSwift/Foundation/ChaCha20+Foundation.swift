//
//  ChaCha20+Foundation.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 27/09/15.
//  Copyright © 2015 Marcin Krzyzanowski. All rights reserved.
//

import Foundation

extension ChaCha20 {
    convenience public init(key:String, iv:String) throws {
        guard let kkey = key.bridge().data(using: String.Encoding.utf8.rawValue, allowLossyConversion: false)?.bytes, let iiv = iv.bridge().data(using: String.Encoding.utf8.rawValue, allowLossyConversion: false)?.bytes else {
            throw Error.invalidKeyOrInitializationVector
        }
        try self.init(key: kkey, iv: iiv)
    }
}
