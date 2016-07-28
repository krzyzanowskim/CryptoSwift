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
    private var offset: UInt = 0

    init(iv: Array<UInt8>, cipherOperation: CipherOperationOnBlock) {
        self.iv = iv
        self.cipherOperation = cipherOperation
    }

    mutating func encrypt(plaintext: Array<UInt8>) -> Array<UInt8> {
        assert(plaintext.count <= AES.blockSize, "input size too large")
        
        let nonce = buildNonce(iv, counter: UInt64(counter))
        let currentOffset = offset
        
        incrementCounter(plaintext.count)

        guard let ciphertext = cipherOperation(block: nonce) else {
            return plaintext
        }
        
        if currentOffset > 0 {
            let arr = leftpad(plaintext, padding: currentOffset)
            if arr.count <= AES.blockSize {
                return zip(arr, ciphertext).suffix(plaintext.count).map(^)
            } else {
                let nonce2 = buildNonce(iv, counter: UInt64(counter))
                
                guard let ciphertext2 = cipherOperation(block: nonce2) else {
                    return plaintext
                }
                
                let ciphertextCombined = ciphertext + ciphertext2
                return zip(arr, ciphertextCombined).suffix(plaintext.count).map(^)
            }
        }
        return xor(plaintext, ciphertext)
    }

    mutating func decrypt(ciphertext: Array<UInt8>) -> Array<UInt8> {
        return encrypt(ciphertext)
    }
    
    mutating func incrementCounter(size: Int) {
        counter += (offset + UInt(size)) / UInt(AES.blockSize)
        offset += UInt(size % AES.blockSize)
        offset %= UInt(AES.blockSize)
    }
}

private func leftpad(arr: Array<UInt8>, padding: UInt) -> Array<UInt8> {
    return Array<UInt8>(count: Int(padding), repeatedValue: 0) + arr
}

private func buildNonce(iv: Array<UInt8>, counter: UInt64) -> Array<UInt8> {
    let noncePartLen = AES.blockSize / 2
    let noncePrefix = Array(iv[0..<noncePartLen])
    let nonceSuffix = Array(iv[noncePartLen..<iv.count])
    let c = UInt64.withBytes(nonceSuffix) + counter
    return noncePrefix + arrayOfBytes(c)
}
