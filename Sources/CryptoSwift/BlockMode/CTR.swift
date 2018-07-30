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

public struct CTR: StreamMode {
    public enum Error: Swift.Error {
        /// Invalid IV
        case invalidInitializationVector
    }

    public let options: BlockModeOption = [.initializationVectorRequired, .useEncryptToDecrypt]
    private let iv: Array<UInt8>
    private let counter: Int

    public init(iv: Array<UInt8>, counter: Int = 0) {
        self.iv = iv
        self.counter = counter
    }

    public func worker(blockSize: Int, cipherOperation: @escaping CipherOperationOnBlock) throws -> CipherModeWorker {
        if iv.count != blockSize {
            throw Error.invalidInitializationVector
        }

        return CTRModeWorker(blockSize: blockSize, iv: iv.slice, counter: counter, cipherOperation: cipherOperation)
    }
}

struct CTRModeWorker: RandomAccessCipherModeWorker {
    typealias Counter = CTRCounter

    class CTRCounter {
        private let constPrefix: Array<UInt8>
        private var value: UInt64
        //TODO: make it an updatable value, computing is too slow
        var bytes: Array<UInt8> {
            return constPrefix + value.bytes()
        }

        init(_ initialValue: Array<UInt8>) {
            let halfIndex = initialValue.startIndex.advanced(by: initialValue.count / 2)
            constPrefix = Array(initialValue[initialValue.startIndex..<halfIndex])

            let suffixBytes = Array(initialValue[halfIndex..<initialValue.endIndex])
            value = UInt64(bytes: suffixBytes)
        }

        convenience init(nonce: Array<UInt8>, startAt index: Int) {
            self.init(buildCounterValue(nonce, counter: UInt64(index)))
        }

        static func +=(lhs: CTRCounter, rhs: Int) {
            lhs.value += UInt64(rhs)
        }
    }


    let cipherOperation: CipherOperationOnBlock
    let additionalBufferSize: Int = 0
    var counter: Counter

    init(blockSize: Int, iv: ArraySlice<UInt8>, counter: Int, cipherOperation: @escaping CipherOperationOnBlock) {
        self.counter = Counter(nonce: Array(iv), startAt: counter)
        self.cipherOperation = cipherOperation
    }

    mutating func encrypt(block plaintext: ArraySlice<UInt8>) -> Array<UInt8> {
        defer {
            counter += 1
        }

        guard let ciphertext = cipherOperation(counter.bytes.slice) else {
            return Array(plaintext)
        }

        return xor(plaintext, ciphertext)
    }

    mutating func decrypt(block ciphertext: ArraySlice<UInt8>) -> Array<UInt8> {
        return encrypt(block: ciphertext)
    }
}

private func buildCounterValue(_ iv: Array<UInt8>, counter: UInt64) -> Array<UInt8> {
    let noncePartLen = iv.count / 2
    let noncePrefix = iv[iv.startIndex..<iv.startIndex.advanced(by: noncePartLen)]
    let nonceSuffix = iv[iv.startIndex.advanced(by: noncePartLen)..<iv.startIndex.advanced(by: iv.count)]
    let c = UInt64(bytes: nonceSuffix) + counter
    return noncePrefix + c.bytes()
}
