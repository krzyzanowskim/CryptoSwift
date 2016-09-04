//
//  Cipher.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 29/05/16.
//  Copyright © 2016 Marcin Krzyzanowski. All rights reserved.
//

public enum CipherError: Error {
    case encrypt
    case decrypt
}

public protocol Cipher: class {
    /// Encrypt given bytes at once
    ///
    /// - parameter bytes: Plaintext data
    /// - returns: Encrypted data
    func encrypt<C: Collection>(_ bytes: C) throws -> Array<UInt8> where C.Iterator.Element == UInt8, C.IndexDistance == Int, C.Index == Int

    /// Decrypt given bytes at once
    ///
    /// - parameter bytes: Ciphertext data
    /// - returns: Plaintext data
    func decrypt<C: Collection>(_ bytes: C) throws -> Array<UInt8> where C.Iterator.Element == UInt8, C.IndexDistance == Int, C.Index == Int
}
