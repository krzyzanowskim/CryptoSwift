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
    
    
    private static var unicodeHexMap:[UnicodeScalar:UInt8] = ["0":0,"1":1,"2":2,"3":3,"4":4,"5":5,"6":6,"7":7,"8":8,"9":9,"a":10,"b":11,"c":12,"d":13,"e":14,"f":15,"A":10,"B":11,"C":12,"D":13,"E":14,"F":15]
    /**
     Converts the a hexadecimal string to a corresponding array of bytes.
     
     So the string "ff00" would get converted to [255, 0].
     Supports odd number of characters by interpreting the last character as its' hex value ("f" produces [16] as if it was "0f").
     
     - Returns: An array of 8 bit unsigned integers (bytes).
     */
    public func hexToBytes() -> Array<UInt8>{
        var bytes:Array<UInt8> = []
        do{
            try self.streamHexBytes { (byte) in
                bytes.append(byte)
            }
        }catch _{
            return []
        }
        
        return bytes
    }
    
    // Allows str.hexToBytes() and Array<UInt8>(hex: str) to share the same code
    // Old functionality returns a blank array upon encountering a non hex character so this method must throw in order to replicate that in methods relying on this method. (ex. "ffn" should return [] instead of [255])
    // Consider switching NSError to custom Error enum
    public func streamHexBytes(_ block:(UInt8)->Void) throws{
        var buffer:UInt8?
        var skip = hasPrefix("0x") ? 2 : 0
        for char in unicodeScalars.lazy {
            guard skip == 0 else {
                skip -= 1
                continue
            }
            guard let value = String.unicodeHexMap[char] else {
                throw NSError(domain: "com.krzyzanowskim.CryptoSwift.hexParseError", code: 0, userInfo: nil)
            }
            if let b = buffer {
                block(b << 4 | value)
                buffer = nil
            } else {
                buffer = value
            }
        }
        if let b = buffer{block(b)}
    }
    
}
