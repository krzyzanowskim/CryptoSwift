//
//  Cipher.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 29/05/16.
//  Copyright © 2016 Marcin Krzyzanowski. All rights reserved.
//

public enum CipherError: ErrorType {
    case Encrypt
    case Decrypt
}

public protocol Cipher {
    /// Encrypt given bytes at once
    ///
    /// - parameter bytes: Plaintext data
    /// - returns: Encrypted data
    func encrypt(bytes: Array<UInt8>) throws -> Array<UInt8>

    /// Decrypt given bytes at once
    ///
    /// - parameter bytes: Ciphertext data
    /// - returns: Plaintext data
    func decrypt(bytes: Array<UInt8>) throws -> Array<UInt8>
}