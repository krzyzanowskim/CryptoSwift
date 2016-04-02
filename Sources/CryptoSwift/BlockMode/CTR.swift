//
//  CTR.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 08/03/16.
//  Copyright © 2016 Marcin Krzyzanowski. All rights reserved.
//
//  Counter (CTR)
//

struct CTRModeEncryptGenerator: BlockModeGenerator {
    typealias Element = Array<UInt8>

    private let iv: Element
    private let inputGenerator: AnyGenerator<Element>

    private let cipherOperation: CipherOperationOnBlock
    private var counter: UInt = 0

    init(iv: Array<UInt8>, cipherOperation: CipherOperationOnBlock, inputGenerator: AnyGenerator<Array<UInt8>>) {
        self.iv = iv
        self.cipherOperation = cipherOperation
        self.inputGenerator = inputGenerator
    }

    mutating func next() -> Element? {
        guard let plaintext = inputGenerator.next() else {
            return nil
        }

        let nonce = buildNonce(iv, counter: UInt64(counter))
        counter = counter + 1
        if let encrypted = cipherOperation(block: nonce) {
            return xor(plaintext, encrypted)
        }

        return nil
    }
}

struct CTRModeDecryptGenerator: BlockModeGenerator {
    typealias Element = Array<UInt8>

    private let iv: Element
    private let inputGenerator: AnyGenerator<Element>

    private let cipherOperation: CipherOperationOnBlock
    private var counter: UInt = 0

    init(iv: Array<UInt8>, cipherOperation: CipherOperationOnBlock, inputGenerator: AnyGenerator<Element>) {
        self.iv = iv
        self.cipherOperation = cipherOperation
        self.inputGenerator = inputGenerator
    }

    mutating func next() -> Element? {
        guard let ciphertext = inputGenerator.next() else {
            return nil
        }

        let nonce = buildNonce(iv, counter: UInt64(counter))
        counter = counter + 1

        if let decrypted = cipherOperation(block: nonce) {
            return xor(decrypted, ciphertext)
        }

        return nil
    }
}

private func buildNonce(iv: [UInt8], counter: UInt64) -> [UInt8] {
    let noncePartLen = AES.blockSize / 2
    let noncePrefix = Array(iv[0..<noncePartLen])
    let nonceSuffix = Array(iv[noncePartLen..<iv.count])
    let c = UInt64.withBytes(nonceSuffix) + counter
    return noncePrefix + arrayOfBytes(c)
}
