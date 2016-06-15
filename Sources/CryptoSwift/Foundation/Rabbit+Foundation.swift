//
//  Rabbit+Foundation.swift
//  CryptoSwift
//
//  Created by Dima Kalachov on 13/11/15.
//  Copyright © 2015 Marcin Krzyzanowski. All rights reserved.
//

import Foundation

extension Rabbit {
    convenience public init?(key: String) {
        guard let kkey = key.bridge().data(using: String.Encoding.utf8.rawValue, allowLossyConversion: false)?.bytes else {
            return nil
        }
        self.init(key: kkey)
        
    }
    
    convenience public init?(key: String, iv: String) {
        guard let kkey = key.bridge().data(using: String.Encoding.utf8.rawValue, allowLossyConversion: false)?.bytes,
            let iiv = iv.bridge().data(using: String.Encoding.utf8.rawValue, allowLossyConversion: false)?.bytes
            else {
                return nil
        }
        self.init(key: kkey, iv: iiv)
    }
}
