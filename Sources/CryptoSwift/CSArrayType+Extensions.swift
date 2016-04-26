//
//  _ArrayType+Extensions.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 08/10/15.
//  Copyright © 2015 Marcin Krzyzanowski. All rights reserved.
//

public protocol CSArrayType: _ArrayType {
    func cs_arrayValue() -> [Generator.Element]
}

extension Array: CSArrayType {
    public func cs_arrayValue() -> [Generator.Element] {
        return self
    }
}

public extension CSArrayType where Generator.Element == UInt8 {
    public func toHexString() -> String {
        return self.lazy.reduce("") { $0 + String(format:"%02x", $1) }
    }
}

public extension CSArrayType where Generator.Element == UInt8 {
    public func md5() -> [Generator.Element] {
        return Hash.md5(cs_arrayValue()).calculate()
    }
    
    public func sha1() -> [Generator.Element] {
        return Hash.sha1(cs_arrayValue()).calculate()
    }
    
    public func sha224() -> [Generator.Element] {
        return Hash.sha224(cs_arrayValue()).calculate()
    }
    
    public func sha256() -> [Generator.Element] {
        return Hash.sha256(cs_arrayValue()).calculate()
    }
    
    public func sha384() -> [Generator.Element] {
        return Hash.sha384(cs_arrayValue()).calculate()
    }
    
    public func sha512() -> [Generator.Element] {
        return Hash.sha512(cs_arrayValue()).calculate()
    }
    
    public func crc32(seed: UInt32? = nil) -> [Generator.Element] {
        return Hash.crc32(cs_arrayValue(), seed: seed).calculate()
    }
    
    public func crc16(seed: UInt16? = nil) -> [Generator.Element] {
        return Hash.crc16(cs_arrayValue(), seed: seed).calculate()
    }
    
    public func encrypt(cipher: CipherProtocol) throws -> [Generator.Element] {
        return try cipher.cipherEncrypt(cs_arrayValue())
    }

    public func decrypt(cipher: CipherProtocol) throws -> [Generator.Element] {
        return try cipher.cipherDecrypt(cs_arrayValue())
    }
    
    public func authenticate(authenticator: Authenticator) throws -> [Generator.Element] {
        return try authenticator.authenticate(cs_arrayValue())
    }
}