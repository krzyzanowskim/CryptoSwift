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
        return SHA1(bytes).calculate()
    }

    /// Calculate SHA2-224 Digest
    /// - parameter bytes: input message
    /// - returns: Digest bytes
    public static func sha224(_ bytes: Array<UInt8>) -> Array<UInt8> {
        return SHA2(bytes, variant: .sha224).calculate32()
    }

    /// Calculate SHA2-256 Digest
    /// - parameter bytes: input message
    /// - returns: Digest bytes
    public static func sha256(_ bytes: Array<UInt8>) -> Array<UInt8> {
        return SHA2(bytes, variant: .sha256).calculate32()
    }

    /// Calculate SHA2-384 Digest
    /// - parameter bytes: input message
    /// - returns: Digest bytes
    public static func sha384(_ bytes: Array<UInt8>) -> Array<UInt8> {
        return SHA2(bytes, variant: .sha384).calculate64()
    }

    /// Calculate SHA2-512 Digest
    /// - parameter bytes: input message
    /// - returns: Digest bytes
    public static func sha512(_ bytes: Array<UInt8>) -> Array<UInt8> {
        return SHA2(bytes, variant: .sha512).calculate64()
    }
}
