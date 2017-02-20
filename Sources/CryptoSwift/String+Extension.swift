//
//  StringExtension.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 15/08/14.
//  Copyright (c) 2014 Marcin Krzyzanowski. All rights reserved.
//

/** String extension */
extension String {

    public func md5() -> String {
        return self.utf8.lazy.map({ $0 as UInt8 }).md5().toHexString()
    }

    public func sha1() -> String {
        return self.utf8.lazy.map({ $0 as UInt8 }).sha1().toHexString()
    }

    public func sha224() -> String {
        return self.utf8.lazy.map({ $0 as UInt8 }).sha224().toHexString()
    }

    public func sha256() -> String {
        return self.utf8.lazy.map({ $0 as UInt8 }).sha256().toHexString()
    }

    public func sha384() -> String {
        return self.utf8.lazy.map({ $0 as UInt8 }).sha384().toHexString()
    }

    public func sha512() -> String {
        return self.utf8.lazy.map({ $0 as UInt8 }).sha512().toHexString()
    }

    public func sha3(_ variant: SHA3.Variant) -> String {
        return self.utf8.lazy.map({ $0 as UInt8 }).sha3(variant).toHexString()
    }

    public func crc32(seed: UInt32? = nil, reflect: Bool = true) -> String {
        return self.utf8.lazy.map({ $0 as UInt8 }).crc32(seed: seed, reflect: reflect).bytes().toHexString()
    }

    public func crc16(seed: UInt16? = nil) -> String {
        return self.utf8.lazy.map({ $0 as UInt8 }).crc16(seed: seed).bytes().toHexString()
    }

    /// - parameter cipher: Instance of `Cipher`
    /// - returns: hex string of bytes
    public func encrypt(cipher: Cipher) throws -> String {
        return try self.utf8.lazy.map({ $0 as UInt8 }).encrypt(cipher: cipher).toHexString()
    }

    // decrypt() does not make sense for String

    /// - parameter authenticator: Instance of `Authenticator`
    /// - returns: hex string of string
    public func authenticate<A: Authenticator>(with authenticator: A) throws -> String {
        return try self.utf8.lazy.map({ $0 as UInt8 }).authenticate(with: authenticator).toHexString()
    }
    
    
    private static var unicodeHexMap:[UnicodeScalar:UInt8] = ["0":0,"1":1,"2":2,"3":3,"4":4,"5":5,"6":6,"7":7,"8":8,"9":9,"a":10,"b":11,"c":12,"d":13,"e":14,"f":15]
    /**
     Converts the a hexadecimal string to a corresponding array of bytes.
     
     So the string "ff00" would get converted to [255, 0].
     
     - Returns: An array of 8 bit unsigned integers (bytes).
     */
    public func hexToBytes() -> [UInt8]{
        var bytes:[UInt8] = []
        var buffer:UInt8?
        var skip = self.hasPrefix("0x") ? 2 : 0
        for char in unicodeScalars.lazy {
            guard skip == 0 else {skip -= 1;continue}
            guard let value = String.unicodeHexMap[char] else {return []}
            if let b = buffer {
                let byte = b << 4 | value
                bytes.append(byte)
                buffer = nil
            } else {
                buffer = value
            }
        }
        if let b = buffer{
            bytes.append(b)
        }
        return bytes
    }
    
}
