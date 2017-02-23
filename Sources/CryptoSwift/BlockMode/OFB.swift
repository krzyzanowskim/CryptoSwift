//
//  OFB.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 08/03/16.
//  Copyright © 2016 Marcin Krzyzanowski. All rights reserved.
//
// Output Feedback (OFB)
//

struct OFBModeWorker: BlockModeWorker {
    typealias Element = Array<UInt8>

    let cipherOperation: CipherOperationOnBlock
    private let iv: Element
    private var prev: Element?

    init(iv: Array<UInt8>, cipherOperation: @escaping CipherOperationOnBlock) {
        self.iv = iv
        self.cipherOperation = cipherOperation
    }

    mutating func encrypt(_ plaintext: ArraySlice<UInt8>) -> Array<UInt8> {
        guard let ciphertext = cipherOperation(prev ?? iv) else {
            return Array(plaintext)
        }
        prev = ciphertext
        return xor(plaintext, ciphertext)
    }

    mutating func decrypt(_ ciphertext: ArraySlice<UInt8>) -> Array<UInt8> {
        guard let decrypted = cipherOperation(prev ?? iv) else {
            return Array(ciphertext)
        }
        let plaintext = xor(decrypted, ciphertext)
        self.prev = decrypted
        return plaintext
    }
}
