//
//  Cipher.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 30/08/14.
//  Copyright (c) 2014 Marcin Krzyzanowski. All rights reserved.
//

#if os(Linux)
    import Glibc
#else
    import Darwin
#endif

public enum CipherError: ErrorProtocol {
    case Encrypt
    case Decrypt
}

public protocol Cipher {
    func cipherEncrypt(_ bytes: [UInt8]) throws -> [UInt8]
    func cipherDecrypt(_ bytes: [UInt8]) throws -> [UInt8]
    
    static func randomIV(_ blockSize:Int) -> [UInt8]
}

extension Cipher {
    static public func randomIV(_ blockSize:Int) -> [UInt8] {
        var randomIV:[UInt8] = [UInt8]();
        for _ in 0..<blockSize {
            randomIV.append(UInt8(truncatingBitPattern: cs_arc4random_uniform(256)));
        }
        return randomIV
    }
}