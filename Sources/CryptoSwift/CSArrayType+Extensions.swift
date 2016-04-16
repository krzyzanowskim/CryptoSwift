//
//  _ArrayType+Extensions.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 08/10/15.
//  Copyright © 2015 Marcin Krzyzanowski. All rights reserved.
//

import Foundation

public protocol CSArrayType: Collection {
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

    public func toBase64() -> String? {
        guard let bytesArray = self as? [UInt8] else {
            return nil
        }

        return NSData(bytes: bytesArray).base64EncodedStringWithOptions([])
    }

    public init(base64: String) {
        self.init()

        guard let decodedData = NSData(base64EncodedString: base64, options: []) else {
            return
        }

        self.appendContentsOf(decodedData.arrayOfBytes())
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
    
    public func crc32(seed: UInt32? = nil) -> [Iterator.Element] {
        return Hash.crc32(cs_arrayValue(), seed: seed).calculate()
    }
    
    public func crc16(seed: UInt16? = nil) -> [Iterator.Element] {
        return Hash.crc16(cs_arrayValue(), seed: seed).calculate()
    }
    
    public func encrypt(cipher: Cipher) throws -> [Iterator.Element] {
        return try cipher.cipherEncrypt(cs_arrayValue())
    }

    public func decrypt(cipher: Cipher) throws -> [Iterator.Element] {
        return try cipher.cipherDecrypt(cs_arrayValue())
    }
    
    public func authenticate(authenticator: Authenticator) throws -> [Iterator.Element] {
        return try authenticator.authenticate(cs_arrayValue())
    }
}