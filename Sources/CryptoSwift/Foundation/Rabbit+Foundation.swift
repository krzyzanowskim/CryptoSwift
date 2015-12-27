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
        guard let kkey = key.bridge().dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)?.arrayOfBytes() else {
            return nil
        }
        self.init(key: kkey)
        
    }
    
    convenience public init?(key: String, iv: String) {
        guard let kkey = key.bridge().dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)?.arrayOfBytes(),
            let iiv = iv.bridge().dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)?.arrayOfBytes()
            else {
                return nil
        }
        self.init(key: kkey, iv: iiv)
    }
}
