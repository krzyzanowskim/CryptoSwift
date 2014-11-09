//
//  CryptoHash.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 07/08/14.
//  Copyright (c) 2014 Marcin Krzyzanowski. All rights reserved.
//

import Foundation

public enum Hash {
    case md5(NSData)
    case sha1(NSData)
    case sha224(NSData), sha256(NSData), sha384(NSData), sha512(NSData)
    case crc32(NSData)
    
    public func calculate() -> NSData? {
        switch self {
        case md5(let data):
            return MD5(data).calculate()
        case sha1(let data):
            return SHA1(data).calculate()
        case sha224(let data):
            return SHA2(data).calculate32(.sha224)
        case sha256(let data):
            return SHA2(data).calculate32(.sha256)
        case sha384(let data):
            return SHA2(data).calculate64(.sha384)
        case sha512(let data):
            return SHA2(data).calculate64(.sha512)
        case crc32(let data):
            return CRC().crc32(data);
        default:
            return nil
        }
    }
}