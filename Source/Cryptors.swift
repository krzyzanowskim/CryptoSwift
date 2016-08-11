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

public protocol Cryptors: class {
    associatedtype EncryptorType: Updatable
    associatedtype DecryptorType: Updatable

    /// Cryptor suitable for encryption
    func makeEncryptor() -> EncryptorType

    /// Cryptor suitable for decryption
    func makeDecryptor() -> DecryptorType

    /// Generate array of random bytes. Helper function.
    static func randomIV(_ blockSize:Int) -> Array<UInt8>
}

extension Cryptors {
    static public func randomIV(_ blockSize:Int) -> Array<UInt8> {
        var randomIV:Array<UInt8> = Array<UInt8>();
        for _ in 0..<blockSize {
            randomIV.append(UInt8(truncatingBitPattern: cs_arc4random_uniform(256)));
        }
        return randomIV
    }
}
