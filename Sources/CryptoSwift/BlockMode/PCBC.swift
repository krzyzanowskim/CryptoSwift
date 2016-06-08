//
//  PCBM.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 08/03/16.
//  Copyright © 2016 Marcin Krzyzanowski. All rights reserved.
//
//  Propagating Cipher Block Chaining (PCBC)
//

struct PCBCModeWorker: BlockModeWorker {
    typealias Element = Array<UInt8>

    let cipherOperation: CipherOperationOnBlock
    private let iv: Element
    private var prev: Element?

    init(iv: Array<UInt8>, cipherOperation: CipherOperationOnBlock) {
        self.iv = iv
        self.cipherOperation = cipherOperation
    }

    mutating func encrypt(plaintext: Array<UInt8>) -> [UInt8] {
        guard let ciphertext = cipherOperation(block: xor(prev ?? iv, plaintext)) else {
            return plaintext
        }
        prev = xor(plaintext, ciphertext)
        return ciphertext ?? []
    }

    mutating func decrypt(ciphertext: Array<UInt8>) -> [UInt8] {
        guard let plaintext = cipherOperation(block: ciphertext) else {
            return ciphertext
        }
        let result = xor(prev ?? iv, plaintext)
        self.prev = xor(plaintext, ciphertext)
        return result
    }
}