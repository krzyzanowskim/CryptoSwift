//
//  ChaCha20+Foundation.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 27/09/15.
//  Copyright © 2015 Marcin Krzyzanowski. All rights reserved.
//

import Foundation

extension ChaCha20 {
    convenience public init?(key:String, iv:String) {
        guard let kkey = key.bridge().dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)?.arrayOfBytes(), let iiv = iv.bridge().dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)?.arrayOfBytes() else {
            return nil
        }
        self.init(key: kkey, iv: iiv)
    }
}