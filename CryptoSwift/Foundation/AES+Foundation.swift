//
//  AES+Foundation.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 27/09/15.
//  Copyright © 2015 Marcin Krzyzanowski. All rights reserved.
//

import Foundation

extension AES {
    convenience public init?(key:String, iv:String, blockMode:CipherBlockMode = .CBC) {
        guard let kkey = key.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)?.arrayOfBytes(), let iiv = iv.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)?.arrayOfBytes() else {
            return nil
        }
        
        self.init(key: kkey, iv: iiv, blockMode: blockMode)
    }
}