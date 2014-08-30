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
    internal func appendBytes(arrayOfBytes: [Byte]) {
        self.appendBytes(arrayOfBytes, length: arrayOfBytes.count)
    }
    
}

extension NSData {
    
    public var hexString: String {
        return self.toHexString()
    }
    
    public func checksum() -> UInt16 {
        var s:UInt32 = 0;
        
        var bytesArray = self.arrayOfBytes();
        
        for (var i = 0; i < bytesArray.count; i++) {
            var b = bytesArray[i]
            s = s + UInt32(bytesArray[i])
        }
        s = s % 65536;
        return UInt16(s);
    }
    
    public func md5() -> NSData {
        return Hash.md5.calculate(self)
    }

    public func sha1() -> NSData {
        return Hash.sha1.calculate(self)
    }

    public func sha224() -> NSData {
        return Hash.sha224.calculate(self)
    }

    public func sha256() -> NSData {
        return SHA2(self).calculate32(.sha256)
    }

    public func sha384() -> NSData {
        return SHA2(self).calculate64(.sha384)
    }

    public func sha512() -> NSData {
        return SHA2(self).calculate64(.sha512)
    }

    public func crc32() -> NSData {
        return CRC().crc32(self);
    }

    public func encrypt(cipher: Cipher) -> NSData {
        return cipher.encrypt(self)
    }

    public func decrypt(cipher: Cipher) -> NSData {
        return cipher.decrypt(self)
    }

    internal func toHexString() -> String {
        let count = self.length / sizeof(Byte)
        var bytesArray = [Byte](count: count, repeatedValue: 0)
        self.getBytes(&bytesArray, length:count * sizeof(Byte))
        
        var s:String = "";
        bytesArray.map({ (byte) -> () in
            var st: String = NSString(format:"%02X", byte)
            s = s + st
        })
        return s;
    }
    
    internal func arrayOfBytes() -> Array<Byte> {
        let count = self.length / sizeof(Byte)
        var bytesArray = [Byte](count: count, repeatedValue: 0)
        self.getBytes(&bytesArray, length:count * sizeof(Byte))
        return bytesArray
    }
}

