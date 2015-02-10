//
//  Cipher.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 30/08/14.
//  Copyright (c) 2014 Marcin Krzyzanowski. All rights reserved.
//

import Foundation

public enum Cipher {
    /**
    ChaCha20
    
    :param: key Encryption key
    :param: iv  Initialization Vector
    
    :returns: Value of Cipher
    */
    case ChaCha20(key: NSData, iv: NSData)
    /**
    AES
    
    :param: key       Encryption key
    :param: iv        Initialization Vector
    :param: blockMode Block mode (CBC by default)
    
    :returns: Value of Cipher
    */
    case AES(key: NSData, iv: NSData, blockMode: CipherBlockMode)
    
    /**
    Encrypt message
    
    :param: message Plaintext message
    
    :returns: encrypted message
    */
    public func encrypt(message: NSData) -> NSData? {
        switch (self) {
            case .ChaCha20(let key, let iv):
                var chacha = CryptoSwift.ChaCha20(key: key, iv: iv)
                return chacha?.encrypt(message)
            case .AES(let key, let iv, let blockMode):
                var aes = CryptoSwift.AES(key: key, iv: iv, blockMode: blockMode)
                return aes?.encrypt(message)
        }
    }
    
    /**
    Decrypt message
    
    :param: message Message data
    
    :returns: Plaintext message
    */
    public func decrypt(message: NSData) -> NSData? {
        switch (self) {
            case .ChaCha20(let key, let iv):
                var chacha = CryptoSwift.ChaCha20(key: key, iv: iv);
                return chacha?.decrypt(message)
            case .AES(let key, let iv, let blockMode):
                var aes = CryptoSwift.AES(key: key, iv: iv, blockMode: blockMode);
                return aes?.decrypt(message)
        }
    }

    static public func randomIV(key: NSData) -> [UInt8] {
        var randomIV:[UInt8] = [UInt8]();
        for (var i = 0; i < key.length; i++) {
            randomIV.append(UInt8(truncatingBitPattern: arc4random_uniform(256)));
        }
        return randomIV
    }
    
    /**
    Convenience function to generate Initialization Vector (IV) for given key. Use this function to generate IV for you key.
    
    :param: key Given key
    
    :returns: Random IV
    */
    static public func randomIV(key: NSData) -> NSData {
        return NSData.withBytes(randomIV(key))
    }
}