//  CryptoSwift
//
//  Copyright (C) 2014-__YEAR__ Marcin Krzyżanowski <marcin@krzyzanowskim.com>
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

public class BlockDecryptor: Cryptor, Updatable {
    private let blockSize: Int
    private let padding: Padding
    private var worker: CipherModeWorker
    private var accumulated = Array<UInt8>()

    init(blockSize: Int, padding: Padding, _ worker: CipherModeWorker) throws {
        self.blockSize = blockSize
        self.padding = padding
        self.worker = worker
    }

    public func update(withBytes bytes: ArraySlice<UInt8>, isLast: Bool = false) throws -> Array<UInt8> {
        accumulated += bytes

        // If a worker (eg GCM) can combine ciphertext + tag
        // we need to remove tag from the ciphertext.
        if !isLast && accumulated.count < blockSize + worker.additionalBufferSize {
            return []
        }

        let accumulatedWithoutSuffix: Array<UInt8>
        if worker.additionalBufferSize > 0 {
            // FIXME: how slow is that?
            accumulatedWithoutSuffix = Array(accumulated.prefix(accumulated.count - worker.additionalBufferSize))
        } else {
            accumulatedWithoutSuffix = accumulated
        }

        var processedBytesCount = 0
        var plaintext = Array<UInt8>(reserveCapacity: accumulatedWithoutSuffix.count)
        // Processing in a block-size manner. It's good for block modes, but bad for stream modes.
        for var chunk in accumulatedWithoutSuffix.batched(by: blockSize) {
            if isLast || (accumulatedWithoutSuffix.count - processedBytesCount) >= blockSize {

                if isLast, var finalizingWorker = worker as? BlockModeWorkerFinalizing {
                    chunk = try finalizingWorker.willDecryptLast(block: chunk + accumulated.suffix(worker.additionalBufferSize)) // tag size
                }

                if !chunk.isEmpty {
                    plaintext += worker.decrypt(block: chunk)
                }

                if var finalizingWorker = worker as? BlockModeWorkerFinalizing, isLast == true {
                    plaintext = try finalizingWorker.didDecryptLast(block: plaintext.slice)
                }

                processedBytesCount += chunk.count
            }
        }
        accumulated.removeFirst(processedBytesCount) // super-slow

        if isLast {
            plaintext = padding.remove(from: plaintext, blockSize: blockSize)
        }

        return plaintext
    }

    public func seek(to position: Int) throws {
        guard var worker = self.worker as? StreamModeWorker else {
            fatalError("Not supported")
        }

        try worker.seek(to: position)
        self.worker = worker

        accumulated = []
    }
}
