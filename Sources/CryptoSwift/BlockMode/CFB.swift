//
//  CFB.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 08/03/16.
//  Copyright © 2016 Marcin Krzyzanowski. All rights reserved.
//
//  Cipher feedback (CFB)
//

struct CFBModeWorker: BlockModeWorker {
    typealias Element = Array<UInt8>

    let cipherOperation: CipherOperationOnBlock
    private let iv: Element
    private var prev: Element?

    init(iv: Array<UInt8>, cipherOperation: CipherOperationOnBlock) {
        self.iv = iv
        self.cipherOperation = cipherOperation
    }

    mutating func encrypt(plaintext: Array<UInt8>) -> [UInt8] {
        guard let ciphertext = cipherOperation(block: prev ?? iv) else {
            return plaintext
        }
        prev = xor(plaintext, ciphertext)
        return prev ?? []
    }

    mutating func decrypt(ciphertext: Array<UInt8>) -> [UInt8] {
        guard let plaintext = cipherOperation(block: prev ?? iv) else {
            return ciphertext
        }
        let result = xor(plaintext, ciphertext)
        self.prev = ciphertext
        return result
    }
}