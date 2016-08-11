//
//  _ArrayType+Extensions.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 08/10/15.
//  Copyright © 2015 Marcin Krzyzanowski. All rights reserved.
//

public protocol CSArrayType: Collection, RangeReplaceableCollection {
    func cs_arrayValue() -> [Iterator.Element]
}

extension Array: CSArrayType {
    public func cs_arrayValue() -> [Iterator.Element] {
        return self
    }
}

public extension CSArrayType where Iterator.Element == UInt8 {
    public func toHexString() -> String {
        return self.lazy.reduce("") { $0 + String(format:"%02x", $1) }
    }
}

public extension CSArrayType where Iterator.Element == UInt8 {
    public func md5() -> [Iterator.Element] {
        return Hash.md5(cs_arrayValue()).calculate()
    }
    
    public func sha1() -> [Iterator.Element] {
        return Hash.sha1(cs_arrayValue()).calculate()
    }
    
    public func sha224() -> [Iterator.Element] {
        return Hash.sha224(cs_arrayValue()).calculate()
    }
    
    public func sha256() -> [Iterator.Element] {
        return Hash.sha256(cs_arrayValue()).calculate()
    }
    
    public func sha384() -> [Iterator.Element] {
        return Hash.sha384(cs_arrayValue()).calculate()
    }
    
    public func sha512() -> [Iterator.Element] {
        return Hash.sha512(cs_arrayValue()).calculate()
    }
    
    public func crc32(seed: UInt32? = nil, reflect : Bool = true) -> [Iterator.Element] {
        return Hash.crc32(cs_arrayValue(), seed: seed, reflect: reflect).calculate()
    }
    
    public func crc16(seed: UInt16? = nil) -> [Iterator.Element] {
        return Hash.crc16(cs_arrayValue(), seed: seed).calculate()
    }
    
    public func encrypt(cipher: Cipher) throws -> [Iterator.Element] {
        return try cipher.encrypt(cs_arrayValue())
    }

    public func decrypt(cipher: Cipher) throws -> [Iterator.Element] {
        return try cipher.decrypt(cs_arrayValue())
    }
    
    public func authenticate(with authenticator: Authenticator) throws -> [Iterator.Element] {
        return try authenticator.authenticate(cs_arrayValue())
    }
}
