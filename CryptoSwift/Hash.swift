//
//  CryptoHash.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 07/08/14.
//  Copyright (c) 2014 Marcin Krzyzanowski. All rights reserved.
//

import Foundation

public enum Hash {
    case md5
    case sha1, sha224, sha256, sha384, sha512
    
    public func calculate(data: NSData) -> NSData! {
        switch self {
        case md5:
            return MD5(data).calculate()
        case sha1:
            return SHA1(data).calculate()
        case sha224:
            return SHA2(data).calculate32(.sha224)
        case sha256:
            return SHA2(data).calculate32(.sha256)
        case sha384:
            return SHA2(data).calculate64(.sha384)
        case sha512:
            return SHA2(data).calculate64(.sha512)
        default:
            return nil
        }
    }
}