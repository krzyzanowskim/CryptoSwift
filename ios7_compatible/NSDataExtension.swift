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
    internal func appendBytes(arrayOfBytes: [UInt8]) {
        self.appendBytes(arrayOfBytes, length: arrayOfBytes.count)
    }
    
}

extension NSData {

    public func checksum() -> UInt16 {
        var s:UInt32 = 0;
        
        var bytesArray = self.arrayOfBytes()
        
        for (var i = 0; i < bytesArray.count; i++) {
            var b = bytesArray[i]
            s = s + UInt32(bytesArray[i])
        }
        s = s % 65536;
        return UInt16(s);
    }
    
    public func md5() -> NSData? {
        return Hash.md5(self).calculate()
    }

    public func sha1() -> NSData? {
        return Hash.sha1(self).calculate()
    }

    public func sha224() -> NSData? {
        return Hash.sha224(self).calculate()
    }

    public func sha256() -> NSData? {
        return Hash.sha256(self).calculate()
    }

    public func sha384() -> NSData? {
        return Hash.sha384(self).calculate()
    }

    public func sha512() -> NSData? {
        return Hash.sha512(self).calculate()
    }

    public func crc32() -> NSData? {
        return Hash.crc32(self).calculate()
    }

    public func encrypt(cipher: Cipher) -> NSData? {
        if let encrypted = cipher.encrypt(self.arrayOfBytes()) {
            return NSData.withBytes(encrypted)
        }
        return nil
    }

    public func decrypt(cipher: Cipher) -> NSData? {
        if let decrypted = cipher.decrypt(self.arrayOfBytes()) {
            return NSData.withBytes(decrypted)
        }
        return nil;
    }
    
    public func authenticate(authenticator: Authenticator) -> NSData? {
        if let result = authenticator.authenticate(self.arrayOfBytes()) {
            return NSData.withBytes(result)
        }
        return nil
    }
}

extension NSData {
    
    public var hexString: String {
        return self.toHexString()
    }

    func toHexString() -> String {
        let count = self.length / sizeof(UInt8)
        var bytesArray = [UInt8](count: count, repeatedValue: 0)
        self.getBytes(&bytesArray, length:count * sizeof(UInt8))
        
        var s:String = "";
        for byte in bytesArray {
            s = s + String(format:"%02X", byte)
        }
        return s;
    }
    
    public func arrayOfBytes() -> [UInt8] {
        let count = self.length / sizeof(UInt8)
        var bytesArray = [UInt8](count: count, repeatedValue: 0)
        self.getBytes(&bytesArray, length:count * sizeof(UInt8))
        return bytesArray
    }
    
    class public func withBytes(bytes: [UInt8]) -> NSData {
        return NSData(bytes: bytes, length: bytes.count)
    }
}

