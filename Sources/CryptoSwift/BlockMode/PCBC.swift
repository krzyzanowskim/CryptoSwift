//
//  PCBM.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 08/03/16.
//  Copyright © 2016 Marcin Krzyzanowski. All rights reserved.
//
//  Propagating Cipher Block Chaining (PCBC)
//

struct PCBCMode {
    static let options: BlockModeOptions = [.InitializationVectorRequired, .PaddingRequired]

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