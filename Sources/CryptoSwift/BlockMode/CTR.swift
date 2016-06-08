//
//  CTR.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 08/03/16.
//  Copyright © 2016 Marcin Krzyzanowski. All rights reserved.
//
//  Counter (CTR)
//

struct CTRModeWorker: BlockModeWorker {
    typealias Element = Array<UInt8>

    let cipherOperation: CipherOperationOnBlock
    private let iv: Element
    private var counter: UInt = 0

    init(iv: Array<UInt8>, cipherOperation: CipherOperationOnBlock) {
        self.iv = iv
        self.cipherOperation = cipherOperation
    }

    mutating func encrypt(plaintext: Array<UInt8>) -> [UInt8] {
        let nonce = buildNonce(iv, counter: UInt64(counter))
        counter = counter + 1

        guard let ciphertext = cipherOperation(block: nonce) else {
            return plaintext
        }

        return xor(plaintext, ciphertext)
    }

    mutating func decrypt(ciphertext: Array<UInt8>) -> [UInt8] {
        let nonce = buildNonce(iv, counter: UInt64(counter))
        counter = counter + 1

        guard let plaintext = cipherOperation(block: nonce) else {
            return ciphertext
        }
        return xor(plaintext, ciphertext)
    }
}

private func buildNonce(iv: [UInt8], counter: UInt64) -> [UInt8] {
    let noncePartLen = AES.blockSize / 2
    let noncePrefix = Array(iv[0..<noncePartLen])
    let nonceSuffix = Array(iv[noncePartLen..<iv.count])
    let c = UInt64.withBytes(nonceSuffix) + counter
    return noncePrefix + arrayOfBytes(c)
}
