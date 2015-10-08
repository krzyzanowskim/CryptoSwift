//
//  AES+Foundation.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 27/09/15.
//  Copyright © 2015 Marcin Krzyzanowski. All rights reserved.
//

import Foundation

extension AES {
    convenience public init(key:String, iv:String, blockMode:CipherBlockMode = .CBC) throws {
        guard let kkey = key.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)?.arrayOfBytes(), let iiv = iv.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)?.arrayOfBytes() else {
            throw Error.InvalidKeyOrInitializationVector
        }
        
        try self.init(key: kkey, iv: iiv, blockMode: blockMode)
    }
}