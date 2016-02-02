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

struct BlockModeOptions: OptionSetType {
    let rawValue: Int

    static let None = BlockModeOptions(rawValue: 0)
    static let InitializationVectorRequired = BlockModeOptions(rawValue: 1)
    static let PaddingRequired = BlockModeOptions(rawValue: 2)
}

private protocol BlockMode {
    var options: BlockModeOptions { get }
    func encryptBlocks(blocks:[[UInt8]], iv:[UInt8]?, cipherOperation:CipherOperationOnBlock) throws -> [UInt8]
    func decryptBlocks(blocks:[[UInt8]], iv:[UInt8]?, cipherOperation:CipherOperationOnBlock) throws -> [UInt8]
}

public enum CipherBlockMode {
    case ECB, CBC, PCBC, CFB, OFB, CTR
    
    private var mode:BlockMode {
        switch (self) {
        case CBC:
            return CBCMode()
        case PCBC:
            return PCBCMode()
        case CFB:
            return CFBMode()
        case OFB:
            return OFBMode()
        case ECB:
            return ECBMode()
        case CTR:
            return CTRMode()
        }
    }

    var options: BlockModeOptions { return mode.options }
    
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
    let options: BlockModeOptions = [.InitializationVectorRequired, .PaddingRequired]
    
    func encryptBlocks(blocks:[[UInt8]], iv:[UInt8]?, cipherOperation:CipherOperationOnBlock) throws -> [UInt8] {
        precondition(blocks.count > 0)
        guard let iv = iv else {
            throw BlockError.MissingInitializationVector
        }
        
        var out:[UInt8] = [UInt8]()
        out.reserveCapacity(blocks.count * blocks[blocks.startIndex].count)
        var prevCiphertext = iv // for the first time prevCiphertext = iv
        for plaintext in blocks {
            if let encrypted = cipherOperation(block: xor(prevCiphertext, plaintext)) {
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
                out.appendContentsOf(xor(prevCiphertext, decrypted))
            }
            prevCiphertext = ciphertext
        }
        
        return out
    }
}

/**
 Propagating Cipher Block Chaining (PCBC)
 */
private struct PCBCMode: BlockMode {
    let options: BlockModeOptions = [.InitializationVectorRequired, .PaddingRequired]

    func encryptBlocks(blocks:[[UInt8]], iv:[UInt8]?, cipherOperation:CipherOperationOnBlock) throws -> [UInt8] {
        precondition(blocks.count > 0)
        guard let iv = iv else {
            throw BlockError.MissingInitializationVector
        }

        var out:[UInt8] = [UInt8]()
        out.reserveCapacity(blocks.count * blocks[blocks.startIndex].count)
        var prevCiphertext = iv // for the first time prevCiphertext = iv
        for plaintext in blocks {
            guard let encrypted = cipherOperation(block: xor(prevCiphertext, plaintext)) else {
                out.appendContentsOf(plaintext)
                continue
            }

            let ciphertext = encrypted
            out.appendContentsOf(ciphertext)

            prevCiphertext = xor(plaintext, ciphertext)
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
            guard let decrypted = cipherOperation(block: ciphertext) else {
                out.appendContentsOf(ciphertext)
                continue
            }

            let plaintext = xor(prevCiphertext, decrypted)
            out.appendContentsOf(plaintext)
            prevCiphertext = xor(plaintext, ciphertext)
        }

        return out
    }
}

/**
Cipher feedback (CFB)
*/
private struct CFBMode: BlockMode {
    let options: BlockModeOptions = [.InitializationVectorRequired]

    func encryptBlocks(blocks:[[UInt8]], iv:[UInt8]?, cipherOperation:CipherOperationOnBlock) throws -> [UInt8] {
        guard let iv = iv else {
            throw BlockError.MissingInitializationVector
        }
        
        var out:[UInt8] = [UInt8]()
        out.reserveCapacity(blocks.count * blocks[blocks.startIndex].count)

        var lastCiphertext = iv
        for plaintext in blocks {
            if let ciphertext = cipherOperation(block: lastCiphertext) {
                lastCiphertext = xor(plaintext, ciphertext)
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
                out.appendContentsOf(xor(decrypted, ciphertext))
            }
            lastCiphertext = ciphertext
        }
        
        return out
    }
}

/**
 Output Feedback (OFB)
 */
private struct OFBMode: BlockMode {
    let options: BlockModeOptions = [.InitializationVectorRequired]

    func encryptBlocks(blocks:[[UInt8]], iv:[UInt8]?, cipherOperation:CipherOperationOnBlock) throws -> [UInt8] {
        guard let iv = iv else {
            throw BlockError.MissingInitializationVector
        }

        var out:[UInt8] = [UInt8]()
        out.reserveCapacity(blocks.count * blocks[blocks.startIndex].count)

        var lastEncryptedBlock = iv
        for plaintext in blocks {
            guard let ciphertext = cipherOperation(block: lastEncryptedBlock) else {
                out.appendContentsOf(plaintext)
                continue
            }

            lastEncryptedBlock = ciphertext
            out.appendContentsOf(xor(plaintext, ciphertext))
        }
        return out
    }

    func decryptBlocks(blocks:[[UInt8]], iv:[UInt8]?, cipherOperation:CipherOperationOnBlock) throws -> [UInt8] {
        guard let iv = iv else {
            throw BlockError.MissingInitializationVector
        }

        var out:[UInt8] = [UInt8]()
        out.reserveCapacity(blocks.count * blocks[blocks.startIndex].count)

        var lastDecryptedBlock = iv
        for ciphertext in blocks {
            guard let decrypted = cipherOperation(block: lastDecryptedBlock) else {
                out.appendContentsOf(ciphertext)
                continue
            }

            lastDecryptedBlock = decrypted

            let plaintext = xor(decrypted, ciphertext)
            out.appendContentsOf(plaintext)
        }

        return out
    }
}

/**
Electronic codebook (ECB)
*/
private struct ECBMode: BlockMode {
    let options: BlockModeOptions = [.PaddingRequired]

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
    let options = BlockModeOptions.InitializationVectorRequired

    private func buildNonce(iv: [UInt8], counter: UInt64) -> [UInt8] {
        let noncePartLen = AES.blockSize / 2
        let noncePrefix = Array(iv[0..<noncePartLen])
        let nonceSuffix = Array(iv[noncePartLen..<iv.count])
        let c = UInt64.withBytes(nonceSuffix) + counter
        return noncePrefix + arrayOfBytes(c)
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
            let nonce = buildNonce(iv, counter: UInt64(counter))
            counter += 1
            if let encrypted = cipherOperation(block: nonce) {
                out.appendContentsOf(xor(plaintext, encrypted))
            }
        }
        return out
    }
    
    func decryptBlocks(blocks:[[UInt8]], iv:[UInt8]?, cipherOperation:CipherOperationOnBlock) throws -> [UInt8] {
        guard let iv = iv else {
            throw BlockError.MissingInitializationVector
        }
        
        var counter:UInt = 0
        var out = [UInt8]()
        out.reserveCapacity(blocks.count * blocks[blocks.startIndex].count)
        for ciphertext in blocks {
            let nonce = buildNonce(iv, counter: UInt64(counter))
            counter += 1
            if let decrypted = cipherOperation(block: nonce) {
                out.appendContentsOf(xor(decrypted, ciphertext))
            }
        }
        return out
    }

}
