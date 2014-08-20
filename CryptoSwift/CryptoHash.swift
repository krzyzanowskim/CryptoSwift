//
//  CryptoHash.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 07/08/14.
//  Copyright (c) 2014 Marcin Krzyzanowski. All rights reserved.
//

import Foundation

public enum CryptoHash {
    case md5
    case sha1, sha224, sha256, sha384, sha512
    case ripemd160
    
    public func hash(data: NSData) -> NSData! {
        switch self {
        case md5:
            return data.md5()
        case sha1:
            return data.sha1()
        case sha256:
            return data.sha256()
            //        case sha224:
            //            return data.sha224()
            //        case sha256:
            //            return data.sha256()
            //        case sha384:
            //            return data.sha384()
            //        case sha512:
            //            return data.sha512()
            //        case ripemd160:
            //            return data.ripemd160()
        default:
            return nil
        }
    }
}