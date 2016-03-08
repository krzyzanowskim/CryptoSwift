//
//  CTR.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 08/03/16.
//  Copyright © 2016 Marcin Krzyzanowski. All rights reserved.
//
//  Counter (CTR)
//

struct CTRMode: BlockMode {
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
