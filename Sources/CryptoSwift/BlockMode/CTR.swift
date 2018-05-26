//
//  CryptoSwift
//
//  Copyright (C) 2014-2017 Marcin Krzyżanowski <marcin@krzyzanowskim.com>
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

public struct CTR: BlockMode {
    public enum Error: Swift.Error {
        /// Invalid IV
        case invalidInitializationVector
    }

    public let options: BlockModeOption = [.initializationVectorRequired, .useEncryptToDecrypt]
    private let iv: Array<UInt8>

    public init(iv: Array<UInt8>) {
        self.iv = iv
    }

    public func worker(blockSize: Int, cipherOperation: @escaping CipherOperationOnBlock) throws -> BlockModeWorker {
        if iv.count != blockSize {
            throw Error.invalidInitializationVector
        }

        return CTRModeWorker(blockSize: blockSize, iv: iv.slice, cipherOperation: cipherOperation)
    }
}

struct CTRModeWorker: RandomAccessBlockModeWorker {
    let cipherOperation: CipherOperationOnBlock
    let blockSize: Int
    let additionalBufferSize: Int = 0
    private let iv: ArraySlice<UInt8>
    var counter: UInt = 0

    init(blockSize: Int, iv: ArraySlice<UInt8>, cipherOperation: @escaping CipherOperationOnBlock) {
        self.blockSize = blockSize
        self.iv = iv
        self.cipherOperation = cipherOperation
    }

    mutating func encrypt(block plaintext: ArraySlice<UInt8>) -> Array<UInt8> {
        let nonce = buildNonce(iv, counter: UInt64(counter))
        counter = counter + 1

        guard let ciphertext = cipherOperation(nonce.slice) else {
            return Array(plaintext)
        }

        return xor(plaintext, ciphertext)
    }

    mutating func decrypt(block ciphertext: ArraySlice<UInt8>) -> Array<UInt8> {
        return encrypt(block: ciphertext)
    }
}

private func buildNonce(_ iv: ArraySlice<UInt8>, counter: UInt64) -> Array<UInt8> {
    let noncePartLen = iv.count / 2
    let noncePrefix = iv[iv.startIndex..<iv.startIndex.advanced(by: noncePartLen)]
    let nonceSuffix = iv[iv.startIndex.advanced(by: noncePartLen)..<iv.startIndex.advanced(by: iv.count)]
    let c = UInt64(bytes: nonceSuffix) + counter
    return noncePrefix + c.bytes()
}
