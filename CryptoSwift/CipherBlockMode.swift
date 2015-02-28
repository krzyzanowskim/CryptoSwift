//
//  CipherBlockMode.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 27/12/14.
//  Copyright (c) 2014 Marcin Krzyzanowski. All rights reserved.
//

import Foundation

// I have no better name for that
typealias CipherOperationOnBlock = (block: [UInt8]) -> [UInt8]?

private protocol BlockMode {
    var needIV:Bool { get }
    func encryptBlocks(blocks:[[UInt8]], iv:[UInt8]?, cipherOperation:CipherOperationOnBlock) -> [UInt8]?
    func decryptBlocks(blocks:[[UInt8]], iv:[UInt8]?, cipherOperation:CipherOperationOnBlock) -> [UInt8]?
}

public enum CipherBlockMode {
    case ECB, CBC, CFB
    
    private var mode:BlockMode {
        switch (self) {
        case CBC:
            return CBCMode()
        case CFB:
            return CFBMode()
        case ECB:
            return ECBMode()
        }
    }
    
    var needIV: Bool {
        return mode.needIV
    }
    
    /**
    Process input blocks with given block cipher mode. With fallback to plain mode.
    
    :param: blocks cipher block size blocks
    :param: iv     IV
    :param: cipher single block encryption closure
    
    :returns: encrypted bytes
    */
    func encryptBlocks(blocks:[[UInt8]], iv:[UInt8]?, cipherOperation:CipherOperationOnBlock) -> [UInt8]? {
        
        // if IV is not available, fallback to plain
        var finalBlockMode:CipherBlockMode = self
        if (iv == nil) {
            finalBlockMode = .ECB
        }
        
        return finalBlockMode.mode.encryptBlocks(blocks, iv: iv, cipherOperation: cipherOperation)
    }
    
    func decryptBlocks(blocks:[[UInt8]], iv:[UInt8]?, cipherOperation:(block:[UInt8]) -> [UInt8]?) -> [UInt8]? {
        // if IV is not available, fallback to plain
        var finalBlockMode:CipherBlockMode = self
        if (iv == nil) {
            finalBlockMode = .ECB
        }

        return finalBlockMode.mode.decryptBlocks(blocks, iv: iv, cipherOperation: cipherOperation)
    }
}

/**
*  Cipher-block chaining (CBC)
*/
private struct CBCMode: BlockMode {
    var needIV:Bool = true
    
    init() {
        
    }
    
    func encryptBlocks(blocks:[[UInt8]], iv:[UInt8]?, cipherOperation:CipherOperationOnBlock) -> [UInt8]? {
        assert(iv != nil, "CFB require IV")
        if (iv == nil) {
            return nil;
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
            if let encrypted = cipherOperation(block: xoredPlaintext) {
                lastCiphertext = encrypted
                
                if (out == nil) {
                    out = [UInt8]()
                }
                
                out = out! + encrypted
            }
        }
        return out;
    }
    
    func decryptBlocks(blocks:[[UInt8]], iv:[UInt8]?, cipherOperation:CipherOperationOnBlock) -> [UInt8]? {
        assert(iv != nil, "CFB require IV")
        if (iv == nil) {
            return nil
        }

        var out:[UInt8]?
        var lastCiphertext:[UInt8] = iv!
        for (idx,ciphertext) in enumerate(blocks) {
            if let decrypted = cipherOperation(block: ciphertext) { // decrypt
                
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
private struct CFBMode: BlockMode {
    var needIV:Bool = true
    func encryptBlocks(blocks:[[UInt8]], iv:[UInt8]?, cipherOperation:CipherOperationOnBlock) -> [UInt8]? {
        assert(iv != nil, "CFB require IV")
        if (iv == nil) {
            return nil
        }
        
        var out:[UInt8]?
        var lastCiphertext:[UInt8] = iv!
        for (idx,plaintext) in enumerate(blocks) {
            if let encrypted = cipherOperation(block: lastCiphertext) {
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
    
    func decryptBlocks(blocks:[[UInt8]], iv:[UInt8]?, cipherOperation:CipherOperationOnBlock) -> [UInt8]? {
        assert(iv != nil, "CFB require IV")
        if (iv == nil) {
            return nil
        }
        
        var out:[UInt8]?
        var lastCiphertext:[UInt8] = iv!
        for (idx,ciphertext) in enumerate(blocks) {
            if let decrypted = cipherOperation(block: lastCiphertext) {
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
private struct ECBMode: BlockMode {
    var needIV:Bool = false
    func encryptBlocks(blocks:[[UInt8]], iv:[UInt8]?, cipherOperation:CipherOperationOnBlock) -> [UInt8]? {
        var out:[UInt8]?
        for (idx,plaintext) in enumerate(blocks) {
            if let encrypted = cipherOperation(block: plaintext) {
                
                if (out == nil) {
                    out = [UInt8]()
                }

                out = out! + encrypted
            }
        }
        return out
    }
    
    func decryptBlocks(blocks:[[UInt8]], iv:[UInt8]?, cipherOperation:CipherOperationOnBlock) -> [UInt8]? {
        return encryptBlocks(blocks, iv: iv, cipherOperation: cipherOperation)
    }
}