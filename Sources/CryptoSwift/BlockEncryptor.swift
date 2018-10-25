//  CryptoSwift
//
//  Copyright (C) 2014-2018 Marcin Krzyżanowski <marcin@krzyzanowskim.com>
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
final class BlockEncryptor: Cryptor, Updatable {
    private let blockSize: Int
    private var worker: CipherModeWorker
    private let padding: Padding
    // Accumulated bytes. Not all processed bytes.
    private var accumulated = Array<UInt8>(reserveCapacity: 16)

    private var lastBlockRemainder = 0

    init(blockSize: Int, padding: Padding, _ worker: CipherModeWorker) throws {
        self.blockSize = blockSize
        self.padding = padding
        self.worker = worker
    }

    // MARK: Updatable
    public func update(withBytes bytes: ArraySlice<UInt8>, isLast: Bool) throws -> Array<UInt8> {
        accumulated += bytes

        if isLast {
            accumulated = padding.add(to: accumulated, blockSize: blockSize)
        }

        var encrypted = Array<UInt8>(reserveCapacity: accumulated.count)
        for chunk in accumulated.batched(by: blockSize) {
            if isLast || chunk.count == blockSize {
                encrypted += worker.encrypt(block: chunk)
            }
        }

        // Stream encrypts all, so it removes all elements
        accumulated.removeFirst(encrypted.count)

        if var finalizingWorker = worker as? FinalizingEncryptModeWorker, isLast == true {
            encrypted = Array(try finalizingWorker.finalize(encrypt: encrypted.slice))
        }

        return encrypted
    }

    func seek(to: Int) throws {
        fatalError("Not supported")
    }
}
