//
//  Cipher.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 30/08/14.
//  Copyright (c) 2014 Marcin Krzyzanowski. All rights reserved.
//

import Foundation

public enum Cipher {
    case ChaCha20(key: NSData, iv: NSData)
    
    public func encrypt(message: NSData) -> NSData? {
        switch (self) {
            case .ChaCha20(let key, let iv):
                var chacha = CryptoSwift.ChaCha20(key: key, iv: iv);
                return chacha?.encrypt(message)
        }
    }
    
    public func decrypt(message: NSData) -> NSData? {
        switch (self) {
        case .ChaCha20(let key, let iv):
            var chacha = CryptoSwift.ChaCha20(key: key, iv: iv);
            return chacha?.decrypt(message)
        }
    }

}