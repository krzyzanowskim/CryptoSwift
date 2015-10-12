//
//  CipherBlockMode.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 27/12/14.
//  Copyright (c) 2014 Marcin Krzyzanowski. All rights reserved.
//

// I have no better name for that
typealias CipherOperationOnBlock = (block: [UInt8]) -> [UInt8]?

enum BlockError: ErrorType {
    case MissingInitializationVector
}

private protocol BlockMode {
    var needIV:Bool { get }
    func encryptBlocks(blocks:[[UInt8]], iv:[UInt8]?, cipherOperation:CipherOperationOnBlock) throws -> [UInt8]
    func decryptBlocks(blocks:[[UInt8]], iv:[UInt8]?, cipherOperation:CipherOperationOnBlock) throws -> [UInt8]
}

public enum CipherBlockMode {
    case ECB, CBC, CFB, CTR
    
    private var mode:BlockMode {
        switch (self) {
        case CBC:
            return CBCMode()
        case CFB:
            return CFBMode()
        case ECB:
            return ECBMode()
        case CTR:
            return CTRMode()
        }
    }
    
    var needIV: Bool {
        return mode.needIV
    }
    
    /**
    Process input blocks with given block cipher mode. With fallback to plain mode.
    
    - parameter blocks: cipher block size blocks
    - parameter iv:     IV
    - parameter cipher: single block encryption closure
    
    - returns: encrypted bytes
    */
    func encryptBlocks(blocks:[[UInt8]], iv:[UInt8]?, cipherOperation:CipherOperationOnBlock) throws -> [UInt8] {
        
        // if IV is not available, fallback to plain
        var finalBlockMode:CipherBlockMode = self
        if (iv == nil) {
            finalBlockMode = .ECB
        }
        
        return try finalBlockMode.mode.encryptBlocks(blocks, iv: iv, cipherOperation: cipherOperation)
    }
    
    func decryptBlocks(blocks:[[UInt8]], iv:[UInt8]?, cipherOperation:CipherOperationOnBlock) throws -> [UInt8] {
        // if IV is not available, fallback to plain
        var finalBlockMode:CipherBlockMode = self
        if (iv == nil) {
            finalBlockMode = .ECB
        }

        return try finalBlockMode.mode.decryptBlocks(blocks, iv: iv, cipherOperation: cipherOperation)
    }
}

/**
Cipher-block chaining (CBC)
*/
private struct CBCMode: BlockMode {
    let needIV = true
    
    func encryptBlocks(blocks:[[UInt8]], iv:[UInt8]?, cipherOperation:CipherOperationOnBlock) throws -> [UInt8] {
        precondition(blocks.count > 0)
        guard let iv = iv else {
            throw BlockError.MissingInitializationVector
        }
        
        var out:[UInt8] = [UInt8]()
        out.reserveCapacity(blocks.count * blocks[blocks.startIndex].count)
        var prevCiphertext = iv // for the first time prevCiphertext = iv
        for plaintext in blocks {
            if let encrypted = cipherOperation(block: xor(prevCiphertext, b: plaintext)) {
                out.appendContentsOf(encrypted)
                prevCiphertext = encrypted
            }
        }
        return out
    }
    
    func decryptBlocks(blocks:[[UInt8]], iv:[UInt8]?, cipherOperation:CipherOperationOnBlock) throws -> [UInt8] {
        precondition(blocks.count > 0)
        guard let iv = iv else {
            throw BlockError.MissingInitializationVector
        }

        var out:[UInt8] = [UInt8]()
        out.reserveCapacity(blocks.count * blocks[blocks.startIndex].count)
        var prevCiphertext = iv // for the first time prevCiphertext = iv
        for ciphertext in blocks {
            if let decrypted = cipherOperation(block: ciphertext) { // decrypt
                out.appendContentsOf(xor(prevCiphertext, b: decrypted)) //FIXME: b:
            }
            prevCiphertext = ciphertext
        }
        
        return out
    }
}

/**
Cipher feedback (CFB)
*/
private struct CFBMode: BlockMode {
    let needIV = true
    
    func encryptBlocks(blocks:[[UInt8]], iv:[UInt8]?, cipherOperation:CipherOperationOnBlock) throws -> [UInt8] {
        guard let iv = iv else {
            throw BlockError.MissingInitializationVector
        }
        
        var out:[UInt8] = [UInt8]()
        out.reserveCapacity(blocks.count * blocks[blocks.startIndex].count)

        var lastCiphertext = iv
        for plaintext in blocks {
            if let ciphertext = cipherOperation(block: lastCiphertext) {
                lastCiphertext = xor(plaintext,b: ciphertext)
                out.appendContentsOf(lastCiphertext)
            }
        }
        return out
    }
    
    func decryptBlocks(blocks:[[UInt8]], iv:[UInt8]?, cipherOperation:CipherOperationOnBlock) throws -> [UInt8] {
        guard let iv = iv else {
            throw BlockError.MissingInitializationVector
        }
        
        var out:[UInt8] = [UInt8]()
        out.reserveCapacity(blocks.count * blocks[blocks.startIndex].count)

        var lastCiphertext = iv
        for ciphertext in blocks {
            if let decrypted = cipherOperation(block: lastCiphertext) {
                out.appendContentsOf(xor(decrypted, b: ciphertext))
            }
            lastCiphertext = ciphertext
        }
        
        return out
    }
}


/**
Electronic codebook (ECB)
*/
private struct ECBMode: BlockMode {
    let needIV = false
    
    func encryptBlocks(blocks:[[UInt8]], iv:[UInt8]?, cipherOperation:CipherOperationOnBlock) -> [UInt8] {
        var out:[UInt8] = [UInt8]()
        out.reserveCapacity(blocks.count * blocks[blocks.startIndex].count)
        for plaintext in blocks {
            if let encrypted = cipherOperation(block: plaintext) {
                out.appendContentsOf(encrypted)
            }
        }
        return out
    }
    
    func decryptBlocks(blocks:[[UInt8]], iv:[UInt8]?, cipherOperation:CipherOperationOnBlock) -> [UInt8] {
        return encryptBlocks(blocks, iv: iv, cipherOperation: cipherOperation)
    }
}

/**
Counter (CTR)
*/
private struct CTRMode: BlockMode {
    let needIV = true
    
    private func buildNonce(iv: [UInt8], counter: UInt) -> [UInt8] {
        let noncePartLen = AES.blockSize / 2
        let noncePrefix = Array(iv[0..<noncePartLen])
        let nonceSuffix = arrayOfBytes(counter, length: noncePartLen)
        
        var nonce = noncePrefix
        nonce += nonceSuffix
        return nonce
    }
    
    func encryptBlocks(blocks:[[UInt8]], iv:[UInt8]?, cipherOperation:CipherOperationOnBlock) throws -> [UInt8] {
        //var counter:UInt = 17940646550795321087
        
        guard let iv = iv else {
            throw BlockError.MissingInitializationVector
        }

        var counter:UInt = 0
        var out:[UInt8] = [UInt8]()
        out.reserveCapacity(blocks.count * blocks[blocks.startIndex].count)
        for plaintext in blocks {
            let nonce = buildNonce(iv, counter: counter++)
            if let encrypted = cipherOperation(block: nonce) {
                out.appendContentsOf(xor(plaintext, b: encrypted))
            }
        }
        return out
    }
    
    func decryptBlocks(blocks:[[UInt8]], iv:[UInt8]?, cipherOperation:CipherOperationOnBlock) throws -> [UInt8] {
        guard let iv = iv else {
            throw BlockError.MissingInitializationVector
        }
        
        var counter:UInt = 0
        var out:[UInt8] = [UInt8]()
        out.reserveCapacity(blocks.count * blocks[blocks.startIndex].count)
        for plaintext in blocks {
            let nonce = buildNonce(iv, counter: counter++)
            if let encrypted = cipherOperation(block: nonce) {
                out.appendContentsOf(xor(encrypted, b: plaintext))
            }
        }
        return out
    }

}
