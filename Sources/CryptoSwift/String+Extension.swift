//
//  StringExtension.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 15/08/14.
//  Copyright (c) 2014 Marcin Krzyzanowski. All rights reserved.
//

/** String extension */
extension String {
    
    public func md5() -> String {
        return self.utf8.lazy.map({ $0 as UInt8 }).md5().toHexString()
    }
    
    public func sha1() -> String {
        return self.utf8.lazy.map({ $0 as UInt8 }).sha1().toHexString()
    }

    public func sha224() -> String {
        return self.utf8.lazy.map({ $0 as UInt8 }).sha224().toHexString()
    }

    public func sha256() -> String {
        return self.utf8.lazy.map({ $0 as UInt8 }).sha256().toHexString()
    }

    public func sha384() -> String {
        return self.utf8.lazy.map({ $0 as UInt8 }).sha384().toHexString()
    }

    public func sha512() -> String {
        return self.utf8.lazy.map({ $0 as UInt8 }).sha512().toHexString()
    }

    public func crc32(seed: UInt32? = nil, reflect : Bool = true) -> String {
        return self.utf8.lazy.map({ $0 as UInt8 }).crc32(seed, reflect: reflect).toHexString()
    }

    public func crc16(seed: UInt16? = nil) -> String {
        return self.utf8.lazy.map({ $0 as UInt8 }).crc16(seed).toHexString()
    }

    public func encrypt(cipher: Cipher) throws -> [UInt8] {
        return try self.utf8.lazy.map({ $0 as UInt8 }).encrypt(cipher)
    }

    public func decrypt(cipher: Cipher) throws -> [UInt8] {
        return try self.utf8.lazy.map({ $0 as UInt8 }).decrypt(cipher)
    }
    
    /// Returns hex string of bytes.
    public func authenticate(authenticator: Authenticator) throws -> String {
        return  try self.utf8.lazy.map({ $0 as UInt8 }).authenticate(authenticator).toHexString()
    }
}