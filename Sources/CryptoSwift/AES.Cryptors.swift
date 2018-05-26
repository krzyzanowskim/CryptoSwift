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

// MARK: Cryptors

extension AES: Cryptors {
    public func makeEncryptor() throws -> AES.Encryptor {
        return try AES.Encryptor(aes: self)
    }

    public func makeDecryptor() throws -> AES.Decryptor {
        return try AES.Decryptor(aes: self)
    }
}

// MARK: Encryptor

extension AES {
    public struct Encryptor: Cryptor, Updatable {
        private var worker: BlockModeWorker
        private let padding: Padding
        // Accumulated bytes. Not all processed bytes.
        private var accumulated = Array<UInt8>()
        private var processedBytesTotalCount: Int = 0

        init(aes: AES) throws {
            padding = aes.padding
            worker = try aes.blockMode.worker(blockSize: AES.blockSize, cipherOperation: aes.encrypt)
        }

        // MARK: Updatable
        public mutating func update(withBytes bytes: ArraySlice<UInt8>, isLast: Bool = false) throws -> Array<UInt8> {
            accumulated += bytes

            if isLast {
                accumulated = padding.add(to: accumulated, blockSize: AES.blockSize)
            }

            var processedBytes = 0
            var encrypted = Array<UInt8>(reserveCapacity: accumulated.count)
            for chunk in accumulated.batched(by: AES.blockSize) {
                if isLast || (accumulated.count - processedBytes) >= AES.blockSize {
                    encrypted += worker.encrypt(block: chunk)
                    processedBytes += chunk.count
                }
            }
            accumulated.removeFirst(processedBytes)
            processedBytesTotalCount += processedBytes

            if var finalizingWorker = worker as? BlockModeWorkerFinalizing, isLast == true {
                encrypted = try finalizingWorker.finalize(encrypt: encrypted.slice)
            }

            return encrypted
        }
    }
}

// MARK: Decryptor

extension AES {
    public struct Decryptor: RandomAccessCryptor, Updatable {
        private var worker: BlockModeWorker
        private let padding: Padding
        private let additionalBufferSize: Int
        private var accumulated = Array<UInt8>()
        private var processedBytesTotalCount: Int = 0

        private var offset: Int = 0
        private var offsetToRemove: Int = 0

        init(aes: AES) throws {
            padding = aes.padding

            if aes.blockMode.options.contains(.useEncryptToDecrypt) {
                worker = try aes.blockMode.worker(blockSize: AES.blockSize, cipherOperation: aes.encrypt)
            } else {
                worker = try aes.blockMode.worker(blockSize: AES.blockSize, cipherOperation: aes.decrypt)
            }

            additionalBufferSize = worker.additionalBufferSize
        }

        public mutating func update(withBytes bytes: ArraySlice<UInt8>, isLast: Bool = false) throws -> Array<UInt8> {
            // prepend "offset" number of bytes at the beginning
            if offset > 0 {
                accumulated += Array<UInt8>(repeating: 0, count: offset) + bytes
                offsetToRemove = offset
                offset = 0
            } else {
                accumulated += bytes
            }

            // If a worker (eg GCM) can combine ciphertext + tag
            // we need to remove tag from the ciphertext.
            if !isLast && accumulated.count < worker.blockSize + additionalBufferSize {
                return []
            }

            let accumulatedWithoutSuffix: Array<UInt8>
            if additionalBufferSize > 0 {
                // FIXME: how slow is that?
                accumulatedWithoutSuffix = Array(accumulated.prefix(accumulated.count - additionalBufferSize))
            } else {
                accumulatedWithoutSuffix = accumulated
            }

            var processedBytesCount = 0
            var plaintext = Array<UInt8>(reserveCapacity: accumulatedWithoutSuffix.count)
            // Processing in a block-size manner. It's good for block modes, but bad for stream modes.
            for var chunk in accumulatedWithoutSuffix.batched(by: worker.blockSize) {
                if isLast || (accumulatedWithoutSuffix.count - processedBytesCount) >= worker.blockSize {

                    if isLast, var finalizingWorker = worker as? BlockModeWorkerFinalizing {
                        chunk = try finalizingWorker.willDecryptLast(block: chunk + accumulated.suffix(additionalBufferSize)) // tag size
                    }

                    if !chunk.isEmpty {
                        plaintext += worker.decrypt(block: chunk)
                    }

                    // remove "offset" from the beginning of first chunk
                    if offsetToRemove > 0 {
                        plaintext.removeFirst(offsetToRemove)
                        offsetToRemove = 0
                    }

                    if var finalizingWorker = worker as? BlockModeWorkerFinalizing, isLast == true {
                        plaintext = try finalizingWorker.didDecryptLast(block: plaintext.slice)
                    }

                    processedBytesCount += chunk.count
                }
            }
            accumulated.removeFirst(processedBytesCount) // super-slow
            processedBytesTotalCount += processedBytesCount

            if isLast {
                plaintext = padding.remove(from: plaintext, blockSize: worker.blockSize)
            }

            return plaintext
        }

        @discardableResult public mutating func seek(to position: Int) -> Bool {
            guard var worker = self.worker as? RandomAccessBlockModeWorker else {
                return false
            }

            worker.counter = UInt(position / AES.blockSize) // TODO: worker.blockSize
            self.worker = worker

            offset = position % worker.blockSize

            accumulated = []

            return true
        }
    }
}
