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
    
    func encryptBlocks(blocks:[[UInt8]], iv:[UInt8]?, cipherOperation:CipherOperationOnBlock) -> [UInt8]? {
        precondition(blocks.count > 0)
        assert(iv != nil, "CFB require IV")
        if (iv == nil) {
            return nil;
        }
        
        
        var out:[UInt8] = [UInt8]()
        out.reserveCapacity(blocks.count * blocks[0].count)
        var prevCiphertext = iv! // for the first time prevCiphertext = iv
        for plaintext in blocks {
            if let encrypted = cipherOperation(block: xor(prevCiphertext, plaintext)) {
                out.extend(encrypted)
                prevCiphertext = encrypted
            }
        }
        return out;
    }
    
    func decryptBlocks(blocks:[[UInt8]], iv:[UInt8]?, cipherOperation:CipherOperationOnBlock) -> [UInt8]? {
        precondition(blocks.count > 0)
        assert(iv != nil, "CFB require IV")
        if (iv == nil) {
            return nil
        }

        var out:[UInt8] = [UInt8]()
        out.reserveCapacity(blocks.count * blocks[0].count)
        var prevCiphertext = iv! // for the first time prevCiphertext = iv
        for ciphertext in blocks {
            if let decrypted = cipherOperation(block: ciphertext) { // decrypt
                out.extend(xor(prevCiphertext, decrypted))
            }
            prevCiphertext = ciphertext
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
        
        var out:[UInt8] = [UInt8]()
        out.reserveCapacity(blocks.count * blocks[0].count)

        var lastCiphertext = iv!
        for plaintext in blocks {
            if let encrypted = cipherOperation(block: lastCiphertext) {
                lastCiphertext = xor(plaintext,encrypted)
                out.extend(lastCiphertext)
            }
        }
        return out;
    }
    
    func decryptBlocks(blocks:[[UInt8]], iv:[UInt8]?, cipherOperation:CipherOperationOnBlock) -> [UInt8]? {
        return encryptBlocks(blocks, iv: iv, cipherOperation: cipherOperation)
    }
}


/**
*  Electronic codebook (ECB)
*/
private struct ECBMode: BlockMode {
    var needIV:Bool = false
    func encryptBlocks(blocks:[[UInt8]], iv:[UInt8]?, cipherOperation:CipherOperationOnBlock) -> [UInt8]? {
        var out:[UInt8] = [UInt8]()
        out.reserveCapacity(blocks.count * blocks[0].count)
        for plaintext in blocks {
            if let encrypted = cipherOperation(block: plaintext) {
                out.extend(encrypted)
            }
        }
        return out
    }
    
    func decryptBlocks(blocks:[[UInt8]], iv:[UInt8]?, cipherOperation:CipherOperationOnBlock) -> [UInt8]? {
        return encryptBlocks(blocks, iv: iv, cipherOperation: cipherOperation)
    }
}
