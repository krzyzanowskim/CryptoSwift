//
//  CTR.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 08/03/16.
//  Copyright © 2016 Marcin Krzyzanowski. All rights reserved.
//
//  Counter (CTR)
//

struct CTRModeWorker: RandomAccessBlockModeWorker {
    typealias Element = Array<UInt8>

    let cipherOperation: CipherOperationOnBlock
    private let iv: Element
    var counter: UInt = 0

    init(iv: Array<UInt8>, cipherOperation: @escaping CipherOperationOnBlock) {
        self.iv = iv
        self.cipherOperation = cipherOperation
    }

    mutating func encrypt(_ plaintext: ArraySlice<UInt8>) -> Array<UInt8> {
        let nonce = buildNonce(iv, counter: UInt64(counter))
        counter = counter + 1

        guard let ciphertext = cipherOperation(nonce) else {
            return Array(plaintext)
        }

        return xor(plaintext, ciphertext)
    }

    mutating func decrypt(_ ciphertext: ArraySlice<UInt8>) -> Array<UInt8> {
        return encrypt(ciphertext)
    }
}

private func buildNonce(_ iv: Array<UInt8>, counter: UInt64) -> Array<UInt8> {
    let noncePartLen = AES.blockSize / 2
    let noncePrefix = Array(iv[0 ..< noncePartLen])
    let nonceSuffix = Array(iv[noncePartLen ..< iv.count])
    let c = UInt64(bytes: nonceSuffix) + counter
    return noncePrefix + c.bytes()
}
