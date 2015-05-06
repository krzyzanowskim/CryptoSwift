//
//  HMAC.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 13/01/15.
//  Copyright (c) 2015 Marcin Krzyzanowski. All rights reserved.
//

import Foundation

public final class HMAC {
    
    public enum Variant {
        case sha1, sha256, sha384, sha512, md5
        
        var size:Int {
            switch (self) {
            case .sha1:
                return SHA1(NSData()).size
            case .sha256:
                return SHA2.Variant.sha256.size
            case .sha384:
                return SHA2.Variant.sha384.size
            case .sha512:
                return SHA2.Variant.sha512.size
            case .md5:
                return MD5(NSData()).size
            }
        }
        
        func calculateHash(# bytes:[UInt8]) -> [UInt8]? {
            switch (self) {
            case .sha1:
                return NSData.withBytes(bytes).sha1()?.arrayOfBytes()
            case .sha256:
                return NSData.withBytes(bytes).sha256()?.arrayOfBytes()
            case .sha384:
                return NSData.withBytes(bytes).sha384()?.arrayOfBytes()
            case .sha512:
                return NSData.withBytes(bytes).sha512()?.arrayOfBytes()
            case .md5:
                return NSData.withBytes(bytes).md5()?.arrayOfBytes();
            }
        }
        
        func blockSize() -> Int {
            switch self {
            case .md5, .sha1, .sha256:
                return 64
            case .sha384, .sha512:
                return 128
            }
        }
    }
    
    var key:[UInt8]
    let variant:Variant
    
    class internal func authenticate(# key: [UInt8], message: [UInt8], variant:HMAC.Variant = .md5) -> [UInt8]? {
        return HMAC(key, variant: variant)?.authenticate(message: message)
    }

    // MARK: - Private
    
    internal init? (_ key: [UInt8], variant:HMAC.Variant = .md5) {
        self.variant = variant
        self.key = key

        if (key.count > variant.blockSize()) {
            if let hash = variant.calculateHash(bytes: key) {
                self.key = hash
            }
        }
        
        if (key.count < variant.blockSize()) { // keys shorter than blocksize are zero-padded
            self.key = key + [UInt8](count: variant.blockSize() - key.count, repeatedValue: 0)
        }
    }
    
    internal func authenticate(# message:[UInt8]) -> [UInt8]? {
        var opad = [UInt8](count: variant.blockSize(), repeatedValue: 0x5c)
        for (idx, val) in enumerate(key) {
            opad[idx] = key[idx] ^ opad[idx]
        }
        var ipad = [UInt8](count: variant.blockSize(), repeatedValue: 0x36)
        for (idx, val) in enumerate(key) {
            ipad[idx] = key[idx] ^ ipad[idx]
        }

        var finalHash:[UInt8]? = nil;
        if let ipadAndMessageHash = variant.calculateHash(bytes: ipad + message) {
            finalHash = variant.calculateHash(bytes: opad + ipadAndMessageHash);
        }
        return finalHash
    }
}