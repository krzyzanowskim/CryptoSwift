//
//  Hash.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 07/08/14.
//  Copyright (c) 2014 Marcin Krzyzanowski. All rights reserved.
//

@available(*, deprecated:0.6.0, renamed: "Digest")
public typealias Hash = Digest

/// Hash functions to calculate Digest.
public struct Digest {

    /// Calculate MD5 Digest
    /// - parameter bytes: input message
    /// - returns: Digest bytes
    public static func md5(_ bytes: Array<UInt8>) -> Array<UInt8> {
        return MD5().calculate(for: bytes)
    }

    /// Calculate SHA1 Digest
    /// - parameter bytes: input message
    /// - returns: Digest bytes
    public static func sha1(_ bytes: Array<UInt8>) -> Array<UInt8> {
        return SHA1().calculate(for: bytes)
    }

    /// Calculate SHA2-224 Digest
    /// - parameter bytes: input message
    /// - returns: Digest bytes
    public static func sha224(_ bytes: Array<UInt8>) -> Array<UInt8> {
        return SHA2(variant: .sha224).calculate(for: bytes)
    }

    /// Calculate SHA2-256 Digest
    /// - parameter bytes: input message
    /// - returns: Digest bytes
    public static func sha256(_ bytes: Array<UInt8>) -> Array<UInt8> {
        return SHA2(variant: .sha256).calculate(for: bytes)
    }

    /// Calculate SHA2-384 Digest
    /// - parameter bytes: input message
    /// - returns: Digest bytes
    public static func sha384(_ bytes: Array<UInt8>) -> Array<UInt8> {
        return SHA2(variant: .sha384).calculate(for: bytes)
    }

    /// Calculate SHA2-512 Digest
    /// - parameter bytes: input message
    /// - returns: Digest bytes
    public static func sha512(_ bytes: Array<UInt8>) -> Array<UInt8> {
        return SHA2(variant: .sha512).calculate(for: bytes)
    }

    /// Calculate SHA3 Digest
    /// - parameter bytes: input message
    /// - parameter variant: SHA-3 variant
    /// - returns: Digest bytes
    public static func sha3(_ bytes: Array<UInt8>, variant: SHA3.Variant) -> Array<UInt8> {
        return SHA3(variant: variant).calculate(for: bytes)
    }

}
