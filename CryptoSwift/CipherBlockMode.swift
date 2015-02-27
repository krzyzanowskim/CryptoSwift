//
//  CipherBlockMode.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 27/12/14.
//  Copyright (c) 2014 Marcin Krzyzanowski. All rights reserved.
//

import Foundation

public enum CipherBlockMode {
    case ECB, CBC, CFB
    
    func requireIV() -> Bool {
        switch (self) {
        case CBC, CFB:
            return true
        default:
            return false
        }
    }
    
    /**
    Process input blocks with given block cipher mode. With fallback to plain mode.
    
    :param: blocks cipher block size blocks
    :param: iv     IV
    :param: cipher single block encryption closure
    
    :returns: encrypted bytes
    */
    func encryptBlocks(blocks:[[UInt8]], iv:[UInt8]?, cipher:(block:[UInt8]) -> [UInt8]?) -> [UInt8]? {
        
        // if IV is not available, fallback to plain
        var finalBlockMode:CipherBlockMode = self
        if (iv == nil) {
            finalBlockMode = .ECB
        }
        
        switch (finalBlockMode) {
        case CBC:
            return CBCMode.encryptBlocks(blocks, iv: iv, cipher: cipher)
        case CFB:
            return CFBMode.encryptBlocks(blocks, iv: iv, cipher: cipher)
        case ECB:
            return ECBMode.encryptBlocks(blocks, cipher: cipher)
        }
    }
    
    func decryptBlocks(blocks:[[UInt8]], iv:[UInt8]?, cipher:(block:[UInt8]) -> [UInt8]?) -> [UInt8]? {
        // if IV is not available, fallback to plain
        var finalBlockMode:CipherBlockMode = self
        if (iv == nil) {
            finalBlockMode = .ECB
        }
        
        switch (finalBlockMode) {
        case CBC:
            return CBCMode.decryptBlocks(blocks, iv: iv, cipher: cipher)
        case CFB:
            return CFBMode.decryptBlocks(blocks, iv: iv, cipher: cipher)
        case ECB:
            return ECBMode.decryptBlocks(blocks, cipher: cipher)
        }
    }
}

/**
*  Cipher-block chaining (CBC)
*/
private struct CBCMode {
    static func encryptBlocks(blocks:[[UInt8]], iv:[UInt8]?, cipher:(block:[UInt8]) -> [UInt8]?) -> [UInt8]? {
        
        if (iv == nil) {
            assertionFailure("CBC require IV")
            return nil
        }
        
        var out:[UInt8]?
        var lastCiphertext:[UInt8] = iv!
        for (idx,plaintext) in enumerate(blocks) {
            // for the first time ciphertext = iv
            // ciphertext = plaintext (+) ciphertext
            var xoredPlaintext:[UInt8] = plaintext
            for i in 0..<plaintext.count {
                xoredPlaintext[i] = lastCiphertext[i] ^ plaintext[i]
            }
            
            // encrypt with cipher
            if let encrypted = cipher(block: xoredPlaintext) {
                lastCiphertext = encrypted
                
                if (out == nil) {
                    out = [UInt8]()
                }
                
                out = out! + encrypted
            }
        }
        return out;
    }
    
    static func decryptBlocks(blocks:[[UInt8]], iv:[UInt8]?, cipher:(block:[UInt8]) -> [UInt8]?) -> [UInt8]? {
        if (iv == nil) {
            assertionFailure("CBC require IV")
            return nil
        }

        var out:[UInt8]?
        var lastCiphertext:[UInt8] = iv!
        for (idx,ciphertext) in enumerate(blocks) {
            if let decrypted = cipher(block: ciphertext) { // decrypt
                
                var xored:[UInt8] = [UInt8](count: ciphertext.count, repeatedValue: 0)
                for i in 0..<ciphertext.count {
                    xored[i] = lastCiphertext[i] ^ decrypted[i]
                }

                if (out == nil) {
                    out = [UInt8]()
                }
                out = out! + xored
            }
            lastCiphertext = ciphertext
        }
        
        return out
    }
}

/**
*  Cipher feedback (CFB)
*/
private struct CFBMode {
    static func encryptBlocks(blocks:[[UInt8]], iv:[UInt8]?, cipher:(block:[UInt8]) -> [UInt8]?) -> [UInt8]? {
        
        if (iv == nil) {
            assertionFailure("CFB require IV")
            return nil
        }
        
        var out:[UInt8]?
        var lastCiphertext:[UInt8] = iv!
        for (idx,plaintext) in enumerate(blocks) {
            if let encrypted = cipher(block: lastCiphertext) {
                var xoredPlaintext:[UInt8] = [UInt8](count: plaintext.count, repeatedValue: 0)
                for i in 0..<plaintext.count {
                    xoredPlaintext[i] = plaintext[i] ^ encrypted[i]
                }
                lastCiphertext = xoredPlaintext

                
                if (out == nil) {
                    out = [UInt8]()
                }
                
                out = out! + xoredPlaintext
            }
        }
        return out;
    }
    
    static func decryptBlocks(blocks:[[UInt8]], iv:[UInt8]?, cipher:(block:[UInt8]) -> [UInt8]?) -> [UInt8]? {
        if (iv == nil) {
            assertionFailure("CFB require IV")
            return nil
        }
        
        var out:[UInt8]?
        var lastCiphertext:[UInt8] = iv!
        for (idx,ciphertext) in enumerate(blocks) {
            if let decrypted = cipher(block: lastCiphertext) {
                var xored:[UInt8] = [UInt8](count: ciphertext.count, repeatedValue: 0)
                for i in 0..<ciphertext.count {
                    xored[i] = ciphertext[i] ^ decrypted[i]
                }
                lastCiphertext = xored
                
                
                if (out == nil) {
                    out = [UInt8]()
                }
                
                out = out! + xored
            }
        }
        return out;
    }

}


/**
*  Electronic codebook (ECB)
*/
private struct ECBMode {
    static func encryptBlocks(blocks:[[UInt8]], cipher:(block:[UInt8]) -> [UInt8]?) -> [UInt8]? {
        var out:[UInt8]?
        for (idx,plaintext) in enumerate(blocks) {
            if let encrypted = cipher(block: plaintext) {
                
                if (out == nil) {
                    out = [UInt8]()
                }

                out = out! + encrypted
            }
        }
        return out
    }
    
    static func decryptBlocks(blocks:[[UInt8]], cipher:(block:[UInt8]) -> [UInt8]?) -> [UInt8]? {
        return encryptBlocks(blocks, cipher: cipher)
    }
}