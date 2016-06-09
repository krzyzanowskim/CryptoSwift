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
    internal func appendBytes(arrayOfBytes: Array<UInt8>) {
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

    public func crc32(seed: UInt32? = nil, reflect : Bool = true) -> NSData? {
        let result = Hash.crc32(self.arrayOfBytes(), seed: seed, reflect: reflect).calculate()
        return NSData.with(bytes: result)
    }

    public func crc16(seed: UInt16? = nil) -> NSData? {
        let result = Hash.crc16(self.arrayOfBytes(), seed: seed).calculate()
        return NSData.with(bytes: result)
    }

    public func encrypt(cipher: Cipher) throws -> NSData {
        let encrypted = try cipher.encrypt(bytes: self.arrayOfBytes())
        return NSData.with(bytes: encrypted)
    }

    public func decrypt(cipher: Cipher) throws -> NSData {
        let decrypted = try cipher.decrypt(bytes: self.arrayOfBytes())
        return NSData.with(bytes: decrypted)
    }
    
    public func authenticate(authenticator: Authenticator) throws -> NSData {
        let result = try authenticator.authenticate(message: self.arrayOfBytes())
        return NSData.with(bytes: result)
    }
}

extension NSData {
    
    public func toHexString() -> String {
        return self.arrayOfBytes().toHexString()
    }
    
    public func arrayOfBytes() -> Array<UInt8> {
        let count = self.length / sizeof(UInt8)
        var bytesArray = Array<UInt8>(repeating: 0, count: count)
        self.getBytes(&bytesArray, length:count * sizeof(UInt8))
        return bytesArray
    }

    public convenience init(bytes: Array<UInt8>) {
        self.init(data: NSData.with(bytes: bytes))
    }
    
    class public func with(bytes: Array<UInt8>) -> NSData {
        return NSData(bytes: bytes, length: bytes.count)
    }
}

