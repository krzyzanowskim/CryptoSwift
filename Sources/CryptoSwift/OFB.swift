//
//  OFB.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 08/03/16.
//  Copyright © 2016 Marcin Krzyzanowski. All rights reserved.
//
// Output Feedback (OFB)
//

struct OFBMode: BlockMode {
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