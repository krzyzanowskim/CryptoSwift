//
//  CipherBlockMode.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 27/12/14.
//  Copyright (c) 2014 Marcin Krzyzanowski. All rights reserved.
//

import Foundation

public enum CipherBlockMode {
    case Plain, CBC, CFB
    
    /**
    Process input blocks with given block cipher mode. With fallback to plain mode.
    
    :param: blocks cipher block size blocks
    :param: iv     IV
    :param: cipher single block encryption closure
    
    :returns: encrypted bytes
    */
    func processBlocks(blocks:[[Byte]], iv:[Byte]?, cipher:(block:[Byte]) -> [Byte]?) -> [Byte]? {
        
        // if IV is not available, fallback to plain
        var finalBlockMode:CipherBlockMode = self
        if (iv == nil) {
            finalBlockMode = .Plain
        }
        
        switch (finalBlockMode) {
        case CBC:
            return CBCMode.processBlocks(blocks, iv: iv, cipher: cipher)
        case CFB:
            return CFBMode.processBlocks(blocks, iv: iv, cipher: cipher)
        case Plain:
            return PlainMode.processBlocks(blocks, cipher: cipher)
        }
    }
}

/**
*  Cipher-block chaining (CBC)
*/
private struct CBCMode {
    static func processBlocks(blocks:[[Byte]], iv:[Byte]?, cipher:(block:[Byte]) -> [Byte]?) -> [Byte]? {
        
        if (iv == nil) {
            assertionFailure("CBC require IV")
            return nil
        }
        
        var out:[Byte]?
        var lastCiphertext:[Byte] = iv!
        for (idx,plaintext) in enumerate(blocks) {
            // for the first time ciphertext = iv
            // ciphertext = plaintext (+) ciphertext
            var xoredPlaintext:[Byte] = plaintext
            for i in 0..<plaintext.count {
                xoredPlaintext[i] = lastCiphertext[i] ^ plaintext[i]
            }
            
            // encrypt with cipher
            if let encrypted = cipher(block: xoredPlaintext) {
                lastCiphertext = encrypted
                
                if (out == nil) {
                    out = [Byte]()
                }
                
                out = out! + encrypted
            }
        }
        return out;
    }
}

/**
*  Cipher feedback (CFB)
*/
private struct CFBMode {
    static func processBlocks(blocks:[[Byte]], iv:[Byte]?, cipher:(block:[Byte]) -> [Byte]?) -> [Byte]? {
        
        if (iv == nil) {
            assertionFailure("CFB require IV")
            return nil
        }
        
        var out:[Byte]?
        var lastCiphertext:[Byte] = iv!
        for (idx,plaintext) in enumerate(blocks) {
            if let encrypted = cipher(block: lastCiphertext) {
                var xoredPlaintext:[Byte] = [Byte](count: plaintext.count, repeatedValue: 0)
                for i in 0..<plaintext.count {
                    xoredPlaintext[i] = plaintext[i] ^ encrypted[i]
                }
                lastCiphertext = xoredPlaintext

                
                if (out == nil) {
                    out = [Byte]()
                }
                
                out = out! + xoredPlaintext
            }
        }
        return out;
    }
}


/**
*  Plain mode, don't use it. For debuging purposes only
*/
private struct PlainMode {
    static func processBlocks(blocks:[[Byte]], cipher:(block:[Byte]) -> [Byte]?) -> [Byte]? {
        var out:[Byte]?
        for (idx,plaintext) in enumerate(blocks) {
            if let encrypted = cipher(block: plaintext) {
                
                if (out == nil) {
                    out = [Byte]()
                }

                out = out! + encrypted
            }
        }
        return out
    }
}