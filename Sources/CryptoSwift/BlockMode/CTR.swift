//
//  CTR.swift
//  CryptoSwift
//
//  Copyright (C) 2014-2017 Krzyżanowski <marcin@krzyzanowskim.com>
//  This software is provided 'as-is', without any express or implied warranty.
//
//  In no event will the authors be held liable for any damages arising from the use of this software.
//
//  Permission is granted to anyone to use this software for any purpose,including commercial applications, and to alter it and redistribute it freely, subject to the following restrictions:
//
//  - The origin of this software must not be misrepresented; you must not claim that you wrote the original software. If you use this software in a product, an acknowledgment in the product documentation is required.
//  - Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.
//  - This notice may not be removed or altered from any source or binary distribution.
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
