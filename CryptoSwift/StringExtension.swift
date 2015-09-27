//
//  StringExtension.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 15/08/14.
//  Copyright (c) 2014 Marcin Krzyzanowski. All rights reserved.
//

/** String extension */
extension String {
    
    /** Calculate MD5 hash */
    public func md5() -> String? {
        return self.utf8.lazy.map({ $0 as UInt8 }).md5()?.toHexString()
    }
    
    public func sha1() -> String? {
        return self.utf8.lazy.map({ $0 as UInt8 }).sha1()?.toHexString()
    }

    public func sha224() -> String? {
        return self.utf8.lazy.map({ $0 as UInt8 }).sha224()?.toHexString()
    }

    public func sha256() -> String? {
        return self.utf8.lazy.map({ $0 as UInt8 }).sha256()?.toHexString()
    }

    public func sha384() -> String? {
        return self.utf8.lazy.map({ $0 as UInt8 }).sha384()?.toHexString()
    }

    public func sha512() -> String? {
        return self.utf8.lazy.map({ $0 as UInt8 }).sha512()?.toHexString()
    }

    public func crc32() -> String? {
        return self.utf8.lazy.map({ $0 as UInt8 }).crc32()?.toHexString()
    }

    public func encrypt(cipher: Cipher) throws -> String? {
        return try self.utf8.lazy.map({ $0 as UInt8 }).encrypt(cipher)?.toHexString()
    }

    public func decrypt(cipher: Cipher) throws -> String? {
        return try self.utf8.lazy.map({ $0 as UInt8 }).decrypt(cipher)?.toHexString()
    }
    
    public func authenticate(authenticator: Authenticator) -> String? {
        return self.utf8.lazy.map({ $0 as UInt8 }).authenticate(authenticator)?.toHexString()
    }

}