//
//  HMAC.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 13/01/15.
//  Copyright (c) 2015 Marcin Krzyzanowski. All rights reserved.
//

final public class HMAC {
    
    public enum Variant {
        case sha1, sha256, sha384, sha512, md5
        
        var size:Int {
            switch (self) {
            case .sha1:
                return SHA1.size
            case .sha256:
                return SHA2.Variant.sha256.size
            case .sha384:
                return SHA2.Variant.sha384.size
            case .sha512:
                return SHA2.Variant.sha512.size
            case .md5:
                return MD5.size
            }
        }
        
        func calculateHash(bytes bytes:Array<UInt8>) -> Array<UInt8>? {
            switch (self) {
            case .sha1:
                return Hash.sha1(bytes).calculate()
            case .sha256:
                return Hash.sha256(bytes).calculate()
            case .sha384:
                return Hash.sha384(bytes).calculate()
            case .sha512:
                return Hash.sha512(bytes).calculate()
            case .md5:
                return Hash.md5(bytes).calculate()
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
    
    var key:Array<UInt8>
    let variant:Variant

    public init? (key: Array<UInt8>, variant:HMAC.Variant = .md5) {
        self.variant = variant
        self.key = key

        if (key.count > variant.blockSize()) {
            if let hash = variant.calculateHash(bytes: key) {
                self.key = hash
            }
        }
        
        if (key.count < variant.blockSize()) { // keys shorter than blocksize are zero-padded
            self.key = key + Array<UInt8>(count: variant.blockSize() - key.count, repeatedValue: 0)
        }
    }

    public func authenticate(message:Array<UInt8>) -> Array<UInt8>? {
        var opad = Array<UInt8>(count: variant.blockSize(), repeatedValue: 0x5c)
        for (idx, _) in key.enumerate() {
            opad[idx] = key[idx] ^ opad[idx]
        }
        var ipad = Array<UInt8>(count: variant.blockSize(), repeatedValue: 0x36)
        for (idx, _) in key.enumerate() {
            ipad[idx] = key[idx] ^ ipad[idx]
        }

        var finalHash:Array<UInt8>? = nil;
        if let ipadAndMessageHash = variant.calculateHash(bytes: ipad + message) {
            finalHash = variant.calculateHash(bytes: opad + ipadAndMessageHash);
        }
        return finalHash
    }
}