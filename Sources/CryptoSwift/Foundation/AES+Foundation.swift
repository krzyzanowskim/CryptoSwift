//
//  AES+Foundation.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 27/09/15.
//  Copyright © 2015 Marcin Krzyzanowski. All rights reserved.
//

import Foundation

extension AES {

    public convenience init(key: String, iv: String, blockMode: BlockMode = .CBC, padding: Padding = PKCS7()) throws {
        guard let kkey = key.data(using: String.Encoding.utf8, allowLossyConversion: false)?.bytes, let iiv = iv.data(using: String.Encoding.utf8, allowLossyConversion: false)?.bytes else {
            throw Error.invalidKeyOrInitializationVector
        }

        try self.init(key: kkey, iv: iiv, blockMode: blockMode, padding: padding)
    }
}
