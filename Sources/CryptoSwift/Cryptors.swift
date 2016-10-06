//
//  Cryptors.swift
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

/// Worker cryptor/decryptor of `Updatable` types
public protocol Cryptors: class {
    associatedtype EncryptorType: Updatable
    associatedtype DecryptorType: Updatable

    /// Cryptor suitable for encryption
    func makeEncryptor() -> EncryptorType

    /// Cryptor suitable for decryption
    func makeDecryptor() -> DecryptorType

    /// Generate array of random bytes. Helper function.
    @available(*, deprecated: 0.6.0, message: "Use system random generator")
    static func randomIV(_ blockSize:Int) -> Array<UInt8>
}

extension Cryptors {
    static public func randomIV(_ blockSize:Int) -> Array<UInt8> {
        return URandom.shared.random(numBytes: blockSize)
    }
}
