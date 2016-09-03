//
//  PGPDataExtension.swift
//  SwiftPGP
//
//  Created by Marcin Krzyzanowski on 05/07/14.
//  Copyright (c) 2014 Marcin Krzyzanowski. All rights reserved.
//

import Foundation

extension Data {

    /// Two octet checksum as defined in RFC-4880. Sum of all octets, mod 65536
    public func checksum() -> UInt16 {
        var s:UInt32 = 0
        var bytesArray = self.bytes
        for i in 0..<bytesArray.count {
            s = s + UInt32(bytesArray[i])
        }
        s = s % 65536
        return UInt16(s)
    }
    
    public func md5() -> Data {
        let result = Digest.md5(self.bytes)
        return Data(bytes: result)
    }

    public func sha1() -> Data? {
        let result = Digest.sha1(self.bytes)
        return Data(bytes: result)
    }

    public func sha224() -> Data? {
        let result = Digest.sha224(self.bytes)
        return Data(bytes: result)
    }

    public func sha256() -> Data? {
        let result = Digest.sha256(self.bytes)
        return Data(bytes: result)
    }

    public func sha384() -> Data? {
        let result = Digest.sha384(self.bytes)
        return Data(bytes: result)
    }

    public func sha512() -> Data? {
        let result = Digest.sha512(self.bytes)
        return Data(bytes: result)
    }

    public func crc32(seed: UInt32? = nil, reflect : Bool = true) -> Data? {
        let result = Checksum.crc32(self.bytes, seed: seed, reflect: reflect)
        return Data(bytes: result.bytes())
    }

    public func crc16(seed: UInt16? = nil) -> Data? {
        let result = Checksum.crc16(self.bytes, seed: seed)
        return Data(bytes: result.bytes())
    }

    public func encrypt(cipher: Cipher) throws -> Data {
        let encrypted = try cipher.encrypt(self.bytes)
        return Data(bytes: encrypted)
    }

    public func decrypt(cipher: Cipher) throws -> Data {
        let decrypted = try cipher.decrypt(self.bytes)
        return Data(bytes: decrypted)
    }
    
    public func authenticate(with authenticator: Authenticator) throws -> Data {
        let result = try authenticator.authenticate(self.bytes)
        return Data(bytes: result)
    }
}

extension Data {

    public var bytes: Array<UInt8> {
        return Array(self)
    }
    
    public func toHexString() -> String {
        return self.bytes.toHexString()
    }
}

