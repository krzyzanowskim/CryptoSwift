//
//  BlockMode.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 27/12/14.
//  Copyright (c) 2014 Marcin Krzyzanowski. All rights reserved.
//
//  Electronic codebook (ECB)
//

struct ECBModeWorker: BlockModeWorker {
    typealias Element = Array<UInt8>
    let cipherOperation: CipherOperationOnBlock

    init(iv: Array<UInt8>, cipherOperation: @escaping CipherOperationOnBlock) {
        self.cipherOperation = cipherOperation
    }

    mutating func encrypt(_ plaintext: Array<UInt8>) -> Array<UInt8> {
        guard let ciphertext = cipherOperation(plaintext) else {
            return plaintext
        }
        return ciphertext
    }

    mutating func decrypt(_ ciphertext: Array<UInt8>) -> Array<UInt8> {
        return encrypt(ciphertext)
    }
}
