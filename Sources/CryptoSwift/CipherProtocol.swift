//
//  CipherProtocol.swift
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

public enum CipherError: ErrorType {
    case Encrypt
    case Decrypt
}

public protocol CipherProtocol {

    /// Cryptor suitable for encryption
    func encryptor() -> Cryptor;

    /// Cryptor suitable for decryption
    func decryptor() -> Cryptor;

    /// Encrypt given bytes at once
    ///
    /// - parameter bytes: Plaintext data
    /// - returns: Encrypted data
    func encrypt(bytes: [UInt8]) throws -> [UInt8]

    /// Decrypt given bytes at once
    ///
    /// - parameter bytes: Ciphertext data
    /// - returns: Plaintext data
    func decrypt(bytes: [UInt8]) throws -> [UInt8]
    
    static func randomIV(blockSize:Int) -> [UInt8]
}

extension CipherProtocol {
    static public func randomIV(blockSize:Int) -> [UInt8] {
        var randomIV:[UInt8] = [UInt8]();
        for _ in 0..<blockSize {
            randomIV.append(UInt8(truncatingBitPattern: cs_arc4random_uniform(256)));
        }
        return randomIV
    }
}