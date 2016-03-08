//
//  CFB.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 08/03/16.
//  Copyright © 2016 Marcin Krzyzanowski. All rights reserved.
//
//  Cipher feedback (CFB)
//

struct CFBMode: BlockMode {
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