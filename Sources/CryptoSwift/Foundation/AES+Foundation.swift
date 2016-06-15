//
//  AES+Foundation.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 27/09/15.
//  Copyright © 2015 Marcin Krzyzanowski. All rights reserved.
//

import Foundation

extension AES {
    convenience public init(key:String, iv:String, blockMode:BlockMode = .CBC, padding: Padding = PKCS7()) throws {
        guard let kkey = key.bridge().data(using: String.Encoding.utf8.rawValue, allowLossyConversion: false)?.bytes, let iiv = iv.bridge().data(using: String.Encoding.utf8.rawValue, allowLossyConversion: false)?.bytes else {
            throw Error.invalidKeyOrInitializationVector
        }
        
        try self.init(key: kkey, iv: iiv, blockMode: blockMode, padding: padding)
    }
}
