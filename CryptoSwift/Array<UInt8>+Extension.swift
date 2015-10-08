//
//  ArrayUInt8+CryptoSwift.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 27/09/15.
//  Copyright © 2015 Marcin Krzyzanowski. All rights reserved.
//

extension Array where Element: _UInt8Type {
    
    public func toHexString() -> String {
        return self.lazy.reduce("") { $0 + String(format:"%02x", $1 as! UInt8) }
    }
    
    public func md5() -> [UInt8]? {
        return Hash.md5(Element.arrayValue(self)).calculate()
    }
    
    public func sha1() -> [UInt8]? {
        return Hash.sha1(Element.arrayValue(self)).calculate()
    }

    public func sha224() -> [UInt8]? {
        return Hash.sha224(Element.arrayValue(self)).calculate()
    }

    public func sha256() -> [UInt8]? {
        return Hash.sha256(Element.arrayValue(self)).calculate()
    }

    public func sha384() -> [UInt8]? {
        return Hash.sha384(Element.arrayValue(self)).calculate()
    }

    public func sha512() -> [UInt8]? {
        return Hash.sha512(Element.arrayValue(self)).calculate()
    }
    
    public func crc32() -> [UInt8]? {
        return Hash.crc32(Element.arrayValue(self)).calculate()
    }

    public func crc16() -> [UInt8]? {
        return Hash.crc16(Element.arrayValue(self)).calculate()
    }

    public func encrypt(cipher: Cipher) throws -> [UInt8]? {
        return try cipher.encrypt(Element.arrayValue(self))
    }
    
    public func decrypt(cipher: Cipher) throws -> [UInt8]? {
        return try cipher.decrypt(Element.arrayValue(self))
    }

    public func authenticate(authenticator: Authenticator) -> [UInt8]? {
        return authenticator.authenticate(Element.arrayValue(self))
    }

}