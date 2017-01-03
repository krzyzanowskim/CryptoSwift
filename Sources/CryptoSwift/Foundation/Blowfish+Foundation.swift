//
//  Blowfish+Foundation.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 27/10/16.
//  Copyright © 2016 Marcin Krzyzanowski. All rights reserved.
//

import Foundation

extension Blowfish {

    public convenience init(key: String, iv: String, blockMode: BlockMode = .CBC, padding: Padding = PKCS7()) throws {
        guard let kkey = key.data(using: String.Encoding.utf8, allowLossyConversion: false)?.bytes, let iiv = iv.data(using: String.Encoding.utf8, allowLossyConversion: false)?.bytes else {
            throw Error.invalidKeyOrInitializationVector
        }

        try self.init(key: kkey, iv: iiv, blockMode: blockMode, padding: padding)
    }
}
