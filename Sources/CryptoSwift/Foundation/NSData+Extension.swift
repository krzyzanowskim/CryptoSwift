//
//  PGPDataExtension.swift
//  SwiftPGP
//
//  Created by Marcin Krzyzanowski on 05/07/14.
//  Copyright (c) 2014 Marcin Krzyzanowski. All rights reserved.
//

import Foundation

extension NSMutableData {
    
    /** Convenient way to append bytes */
    internal func append(_ arrayOfBytes: [UInt8]) {
        self.append(arrayOfBytes, length: arrayOfBytes.count)
    }
}

extension NSData {

    /// Two octet checksum as defined in RFC-4880. Sum of all octets, mod 65536
    public func checksum() -> UInt16 {
        var s:UInt32 = 0
        var bytesArray = self.arrayOfBytes()
        for i in 0..<bytesArray.count {
            s = s + UInt32(bytesArray[i])
        }
        s = s % 65536
        return UInt16(s)
    }
    
    @nonobjc public func md5() -> NSData {
        let result = Hash.md5(self.arrayOfBytes()).calculate()
        return NSData.with(bytes: result)
    }

    public func sha1() -> NSData? {
        let result = Hash.sha1(self.arrayOfBytes()).calculate()
        return NSData.with(bytes: result)
    }

    public func sha224() -> NSData? {
        let result = Hash.sha224(self.arrayOfBytes()).calculate()
        return NSData.with(bytes: result)
    }

    public func sha256() -> NSData? {
        let result = Hash.sha256(self.arrayOfBytes()).calculate()
        return NSData.with(bytes: result)
    }

    public func sha384() -> NSData? {
        let result = Hash.sha384(self.arrayOfBytes()).calculate()
        return NSData.with(bytes: result)
    }

    public func sha512() -> NSData? {
        let result = Hash.sha512(self.arrayOfBytes()).calculate()
        return NSData.with(bytes: result)
    }

    public func crc32(_ seed: UInt32? = nil) -> NSData? {
        let result = Hash.crc32(self.arrayOfBytes(), seed: seed).calculate()
        return NSData.with(bytes: result)
    }

    public func crc16(_ seed: UInt16? = nil) -> NSData? {
        let result = Hash.crc16(self.arrayOfBytes(), seed: seed).calculate()
        return NSData.with(bytes: result)
    }

    public func encrypt(_ cipher: Cipher) throws -> NSData {
        let encrypted = try cipher.cipherEncrypt(self.arrayOfBytes())
        return NSData.with(bytes: encrypted)
    }

    public func decrypt(_ cipher: Cipher) throws -> NSData {
        let decrypted = try cipher.cipherDecrypt(self.arrayOfBytes())
        return NSData.with(bytes: decrypted)
    }
    
    public func authenticate(_ authenticator: Authenticator) throws -> NSData {
        let result = try authenticator.authenticate(self.arrayOfBytes())
        return NSData.with(bytes: result)
    }
}

extension NSData {
    
    final public func toHexString() -> String {
        return self.arrayOfBytes().toHexString()
    }
    
    final public func arrayOfBytes() -> [UInt8] {
        let count = self.length / sizeof(UInt8)
        var bytesArray = [UInt8](repeating: 0, count: count)
        self.getBytes(&bytesArray, length:count * sizeof(UInt8))
        return bytesArray
    }

    public convenience init(bytes: [UInt8]) {
        self.init(data: NSData.with(bytes: bytes))
    }
    
    final class public func with(bytes: [UInt8]) -> NSData {
        return NSData(bytes: bytes, length: bytes.count)
    }
}

