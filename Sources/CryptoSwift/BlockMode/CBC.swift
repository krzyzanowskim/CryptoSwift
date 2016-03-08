//
//  CBC.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 08/03/16.
//  Copyright © 2016 Marcin Krzyzanowski. All rights reserved.
//
//  Cipher-block chaining (CBC)
//

struct CBCMode: BlockMode {
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