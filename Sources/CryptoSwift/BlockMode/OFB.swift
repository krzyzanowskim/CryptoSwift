//
//  OFB.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 08/03/16.
//  Copyright © 2016 Marcin Krzyzanowski. All rights reserved.
//
// Output Feedback (OFB)
//

struct OFBModeEncryptGenerator: BlockModeGenerator {
    typealias Element = Array<UInt8>

    private let iv: Element
    private let inputGenerator: AnyGenerator<Element>

    private let cipherOperation: CipherOperationOnBlock
    private var prevCiphertext: Element?

    init(iv: Array<UInt8>, cipherOperation: CipherOperationOnBlock, inputGenerator: AnyGenerator<Array<UInt8>>) {
        self.iv = iv
        self.cipherOperation = cipherOperation
        self.inputGenerator = inputGenerator
    }

    mutating func next() -> Element? {
        guard let plaintext = inputGenerator.next(),
            let ciphertext = cipherOperation(block: prevCiphertext ?? iv)
            else {
                return nil
        }

        self.prevCiphertext = ciphertext
        return xor(plaintext, ciphertext)
    }
}

struct OFBModeDecryptGenerator: BlockModeGenerator {
    typealias Element = Array<UInt8>

    private let iv: Element
    private let inputGenerator: AnyGenerator<Element>

    private let cipherOperation: CipherOperationOnBlock
    private var prevCiphertext: Element?

    init(iv: Array<UInt8>, cipherOperation: CipherOperationOnBlock, inputGenerator: AnyGenerator<Element>) {
        self.iv = iv
        self.cipherOperation = cipherOperation
        self.inputGenerator = inputGenerator
    }

    mutating func next() -> Element? {
        guard let ciphertext = inputGenerator.next(),
            let decrypted = cipherOperation(block: self.prevCiphertext ?? iv)
            else {
                return nil
        }

        let plaintext = xor(decrypted, ciphertext)
        self.prevCiphertext = decrypted
        return plaintext
    }
}