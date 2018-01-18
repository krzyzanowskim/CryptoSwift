//
//  ChaCha20Poly1305.swift
//  CryptoSwift
//
//  Created by Sean Patno on 1/18/18.
//  Copyright © 2018 Sean Patno. All rights reserved.
//
//  https://tools.ietf.org/html/rfc7539#section-2.8.1

import UIKit

public final class ChaCha20Poly1305 {

    public class func encrypt( message:Array<UInt8>, header:Array<UInt8>, key:Array<UInt8>, nonce:Array<UInt8> ) throws -> (cipher:Array<UInt8>, tag:Array<UInt8>) {
        
        let chacha = try ChaCha20(key: key, iv: nonce)
        
        var polykey = Array<UInt8>(repeating: 0, count: 32)
        var toEncrypt = Array<UInt8>()
        
        toEncrypt.append(contentsOf: polykey)
        polykey = try chacha.encrypt( polykey )
        toEncrypt.append(contentsOf: polykey)
        
        toEncrypt.append(contentsOf: message)
        let fullCipher = try chacha.encrypt(toEncrypt)
        let cipher = Array(fullCipher.dropFirst(64))
        
        let tag = try ChaCha20Poly1305.calculateTag(cipher: cipher, header: header, encodedKey: polykey)
        
        return (cipher, tag)
    }
    
    public class func decrypt( cipher:Array<UInt8>, header:Array<UInt8>, key:Array<UInt8>, nonce:Array<UInt8>, tag:Array<UInt8> ) throws -> (message:Array<UInt8>, success:Bool) {
        
        let chacha = try ChaCha20(key: key, iv: nonce)
        
        var polykey = Array<UInt8>(repeating: 0, count: 32)
        polykey = try chacha.encrypt( polykey )
        
        let mac = try ChaCha20Poly1305.calculateTag(cipher: cipher, header: header, encodedKey: polykey)
        
        if mac == tag {
            var toDecrypt = Array<UInt8>()
            toDecrypt.append(contentsOf: polykey)
            toDecrypt.append(contentsOf: polykey)
            toDecrypt.append(contentsOf: cipher)
            let decrypted = try chacha.decrypt(toDecrypt)
            let message = Array(decrypted.dropFirst(64))
            return (message, true)
        } else {
            return ([], false)
        }
    }
    
    private class func calculateTag( cipher:Array<UInt8>, header:Array<UInt8>, encodedKey:Array<UInt8> ) throws -> Array<UInt8> {
        
        let poly1305 = Poly1305(key: encodedKey)
        var mac = Array<UInt8>()
        mac.append(contentsOf: header)
        let headerPadding = ((16 - (header.count & 0xf)) & 0xf)
        mac.append(contentsOf: Array<UInt8>(repeating: 0, count: headerPadding))
        mac.append(contentsOf: cipher)
        let cipherPadding = ((16 - (cipher.count & 0xf)) & 0xf)
        mac.append(contentsOf: Array<UInt8>(repeating: 0, count: cipherPadding))
        let headerCount = UInt64(header.count).bytes().reversed()
        mac.append(contentsOf: headerCount)
        let cipherCount = UInt64(cipher.count).bytes().reversed()
        mac.append(contentsOf: cipherCount)
        
        return try poly1305.authenticate(mac)
    }
    
}
