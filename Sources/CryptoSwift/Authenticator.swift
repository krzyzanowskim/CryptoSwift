//
//  MAC.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 03/09/14.
//  Copyright (c) 2014 Marcin Krzyzanowski. All rights reserved.
//

/**
*  Message Authentication
*/
public enum Authenticator {
    
    public enum Error: Swift.Error {
        case authenticateError
    }
    
    /**
    Poly1305
    
    - parameter key: 256-bit key
    */
    case Poly1305(key: Array<UInt8>)
    case HMAC(key: Array<UInt8>, variant:CryptoSwift.HMAC.Variant)
    
    /**
    Generates an authenticator for message using a one-time key and returns the 16-byte result
    
    - returns: 16-byte message authentication code
    */
    public func authenticate(_ bytes: Array<UInt8>) throws -> Array<UInt8> {
        switch (self) {
        case .Poly1305(let key):
            guard let auth = CryptoSwift.Poly1305(key: key)?.authenticate(bytes) else {
                throw Error.authenticateError
            }
            return auth
        case .HMAC(let key, let variant):
            guard let auth = CryptoSwift.HMAC(key: key, variant: variant)?.authenticate(bytes) else {
                throw Error.authenticateError
            }
            return auth
        }
    }
}
