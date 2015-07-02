//
//  StringExtension.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 15/08/14.
//  Copyright (c) 2014 Marcin Krzyzanowski. All rights reserved.
//

import Foundation

/** String extension */
extension String {
    
    /** Calculate MD5 hash */
    public func md5() -> String? {
        return self.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)?.md5()?.toHexString()
    }
    
    public func sha1() -> String? {
        return self.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)?.sha1()?.toHexString()
    }

    public func sha224() -> String? {
        return self.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)?.sha224()?.toHexString()
    }

    public func sha256() -> String? {
        return self.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)?.sha256()?.toHexString()
    }

    public func sha384() -> String? {
        return self.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)?.sha384()?.toHexString()
    }

    public func sha512() -> String? {
        return self.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)?.sha512()?.toHexString()
    }

    public func crc32() -> String? {
        return self.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)?.crc32()?.toHexString()
    }

    public func encrypt(cipher: Cipher) -> String? {
        return self.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)?.encrypt(cipher)?.toHexString()
    }

    public func decrypt(cipher: Cipher) -> String? {
        return self.toHexData()?.decrypt(cipher)?.toUtf8String()
    }
    
    public func authenticate(authenticator: Authenticator) -> String? {
        return self.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)?.authenticate(authenticator)?.toHexString()
    }
    
    
    private func toHexData()->NSData?
    {
        let encryptString = self
        
        if encryptString.isEmpty
        {
            assert(false, "encryptString must have some characters")
            return nil
        }
        
        func charToUInt8(char:Character)->UInt8
        {
            switch char
            {
            case "1"..."9":
                return  UInt8("\(char)".toInt()!)
            case "A":
                return 10
            case "B":
                return 11
            case "C":
                return 12
            case "D":
                return 13
            case "E":
                return 14
            case "F":
                return 15
            default:
                return UInt8()
            }
        }
        
        var bytes:[UInt8] = [UInt8](count: count(encryptString)/2, repeatedValue: 0)
        
        var i = 0
        var x = -1
        var byte:UInt8 = 0
        
        for char in encryptString
        {
            i++
            
            if i == 1
            {
                byte += charToUInt8(char) * 16
            }
            if i % 2 == 0
            {
                x++
                
                byte += charToUInt8(char)
                
                bytes[x]=byte
                
                byte=0
                i=0
            }
        }
        
        return NSData.withBytes(bytes)
    }

}