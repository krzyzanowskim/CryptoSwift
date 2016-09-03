//
//  Hash.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 07/08/14.
//  Copyright (c) 2014 Marcin Krzyzanowski. All rights reserved.
//

@available(*, deprecated:0.6.0, renamed: "Digest")
public typealias Hash = Digest

public struct Digest {
    public static func md5(_ bytes: Array<UInt8>) -> Array<UInt8> {
        return MD5().calculate(for: bytes)
    }

    public static func sha1(_ bytes: Array<UInt8>) -> Array<UInt8> {
        return SHA1(bytes).calculate()
    }

    public static func sha224(_ bytes: Array<UInt8>) -> Array<UInt8> {
        return SHA2(bytes, variant: .sha224).calculate32()
    }

    public static func sha256(_ bytes: Array<UInt8>) -> Array<UInt8> {
        return SHA2(bytes, variant: .sha256).calculate32()
    }

    public static func sha384(_ bytes: Array<UInt8>) -> Array<UInt8> {
        return SHA2(bytes, variant: .sha384).calculate64()
    }

    public static func sha512(_ bytes: Array<UInt8>) -> Array<UInt8> {
        return SHA2(bytes, variant: .sha512).calculate64()
    }
}
