//
//  ChaCha20Poly1305.swift
//  CryptoSwift
//
//  Copyright (C) 2014-2017 Marcin Krzyżanowski <marcin@krzyzanowskim.com>
//  This software is provided 'as-is', without any express or implied warranty.
//
//  In no event will the authors be held liable for any damages arising from the use of this software.
//
//  Permission is granted to anyone to use this software for any purpose,including commercial applications, and to alter it and redistribute it freely, subject to the following restrictions:
//
//  - The origin of this software must not be misrepresented; you must not claim that you wrote the original software. If you use this software in a product, an acknowledgment in the product documentation is required.
//  - Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.
//  - This notice may not be removed or altered from any source or binary distribution.
//
//
//  https://tools.ietf.org/html/rfc7539#section-2.8.1

public final class ChaCha20Poly1305: AEAD {

    public static func encrypt( message:Array<UInt8>, header:Array<UInt8>, key:Array<UInt8>, nonce:Array<UInt8> ) throws -> (cipher:Array<UInt8>, tag:Array<UInt8>) {
        
        let chacha = try ChaCha20(key: key, iv: nonce)
        
        var polykey = Array<UInt8>(repeating: 0, count: 32)
        var toEncrypt = Array<UInt8>(reserveCapacity: message.count + 64)
        
        toEncrypt += polykey
        polykey = try chacha.encrypt(polykey)
        toEncrypt += polykey
        toEncrypt += message
        
        let fullCipher = try chacha.encrypt(toEncrypt)
        let cipher = Array(fullCipher.dropFirst(64))
        
        let tag = try ChaCha20Poly1305.calculateTag(cipher: cipher, header: header, encodedKey: polykey)
        
        return (cipher, tag)
    }
    
    public static func decrypt( cipher:Array<UInt8>, header:Array<UInt8>, key:Array<UInt8>, nonce:Array<UInt8>, tag:Array<UInt8> ) throws -> (message:Array<UInt8>, success:Bool) {
        
        let chacha = try ChaCha20(key: key, iv: nonce)
        
        var polykey = Array<UInt8>(repeating: 0, count: 32)
        polykey = try chacha.encrypt(polykey)
        
        let mac = try ChaCha20Poly1305.calculateTag(cipher: cipher, header: header, encodedKey: polykey)
        
        guard mac == tag else { return (cipher, false) }
        
        var toDecrypt = Array<UInt8>(reserveCapacity: cipher.count + 64)
        toDecrypt += polykey
        toDecrypt += polykey
        toDecrypt += cipher
        let decrypted = try chacha.decrypt(toDecrypt)
        let message = Array(decrypted.dropFirst(64))
        return (message, true)
    }
    
    private class func calculateTag( cipher:Array<UInt8>, header:Array<UInt8>, encodedKey:Array<UInt8> ) throws -> Array<UInt8> {
        
        let poly1305 = Poly1305(key: encodedKey)
        var mac = Array<UInt8>()
        mac += header
        let headerPadding = ((16 - (header.count & 0xf)) & 0xf)
        mac += Array<UInt8>(repeating: 0, count: headerPadding)
        mac += cipher
        let cipherPadding = ((16 - (cipher.count & 0xf)) & 0xf)
        mac += Array<UInt8>(repeating: 0, count: cipherPadding)
        mac += UInt64(bigEndian: UInt64(header.count)).bytes()
        mac += UInt64(bigEndian: UInt64(cipher.count)).bytes()
        
        return try poly1305.authenticate(mac)
    }
    
}
