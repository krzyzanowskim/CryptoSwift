//
//  Cipher.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 30/08/14.
//  Copyright (c) 2014 Marcin Krzyzanowski. All rights reserved.
//

import Darwin

public enum CipherError: ErrorType {
    case Encrypt
    case Decrypt
}

public protocol Cipher {
    func cipherEncrypt(bytes: [UInt8]) throws -> [UInt8]
    func cipherDecrypt(bytes: [UInt8]) throws -> [UInt8]
    
    static func randomIV(blockSize:Int) -> [UInt8]
}

extension Cipher {
    static public func randomIV(blockSize:Int) -> [UInt8] {
        var randomIV:[UInt8] = [UInt8]();
        for (var i = 0; i < blockSize; i++) {
            randomIV.append(UInt8(truncatingBitPattern: arc4random_uniform(256)));
        }
        return randomIV
    }
}