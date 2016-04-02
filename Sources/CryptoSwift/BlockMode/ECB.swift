//
//  CipherBlockMode.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 27/12/14.
//  Copyright (c) 2014 Marcin Krzyzanowski. All rights reserved.
//
//  Electronic codebook (ECB)
//

struct ECBModeEncryptGenerator: BlockModeGenerator {
    typealias Element = Array<UInt8>

    private let iv: Element
    private let inputGenerator: AnyGenerator<Element>

    private let cipherOperation: CipherOperationOnBlock

    init(iv: Array<UInt8>, cipherOperation: CipherOperationOnBlock, inputGenerator: AnyGenerator<Array<UInt8>>) {
        self.iv = iv
        self.cipherOperation = cipherOperation
        self.inputGenerator = inputGenerator
    }

    mutating func next() -> Element? {
        guard let plaintext = inputGenerator.next(),
              let encrypted = cipherOperation(block: plaintext)
        else {
            return nil
        }

        return encrypted
    }
}

typealias ECBModeDecryptGenerator = ECBModeEncryptGenerator
