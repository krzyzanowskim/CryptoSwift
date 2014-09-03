//
//  MAC.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 03/09/14.
//  Copyright (c) 2014 Marcin Krzyzanowski. All rights reserved.
//

import Foundation

/**
*  Message Authentication
*/
public enum Authentication {
    /**
    Poly1305
    
    :param: key 256-bit key
    */
    case Poly1305(key: [Byte], message: [Byte])
    
    /**
    Generates an authenticator for message using a one-time key and returns the 16-byte result
    
    :returns: 16-byte message authentication code
    */
    public func calculate() -> [Byte]? {
        switch (self) {
        case .Poly1305(let key, let message):
            return CryptoSwift.Poly1305.authenticate(key: key, message: message)
        }
    }
}