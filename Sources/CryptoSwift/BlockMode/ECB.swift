//
//  CipherBlockMode.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 27/12/14.
//  Copyright (c) 2014 Marcin Krzyzanowski. All rights reserved.
//
//  Electronic codebook (ECB)
//

struct ECBMode {
    static let options: BlockModeOptions = [.PaddingRequired]

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
