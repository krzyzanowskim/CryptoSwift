//
//  HMAC+Foundation.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 12/09/16.
//  Copyright © 2016 Marcin Krzyzanowski. All rights reserved.
//

import Foundation

extension HMAC {
    convenience public init (key: String, variant:HMAC.Variant = .md5) throws {
        guard let kkey = key.bridge().data(using: String.Encoding.utf8.rawValue, allowLossyConversion: false)?.bytes else {
            throw Error.invalidInput
        }
        
        self.init(key: kkey, variant: variant)
    }
}
