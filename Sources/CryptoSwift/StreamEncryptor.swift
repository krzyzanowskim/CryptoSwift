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

final class StreamEncryptor: Cryptor, Updatable {
    private let blockSize: Int
    private var worker: CipherModeWorker
    private let padding: Padding

    private var lastBlockRemainder = 0

    init(blockSize: Int, padding: Padding, _ worker: CipherModeWorker) throws {
        self.blockSize = blockSize
        self.padding = padding
        self.worker = worker
    }

    // MARK: Updatable
    public func update(withBytes bytes: ArraySlice<UInt8>, isLast: Bool) throws -> Array<UInt8> {
        var accumulated = Array(bytes)
        if isLast {
            // CTR doesn't need padding. Really. Add padding to the last block if really want. but... don't.
            accumulated = padding.add(to: accumulated, blockSize: blockSize - lastBlockRemainder)
        }

        var encrypted = Array<UInt8>(reserveCapacity: bytes.count)
        for chunk in accumulated.batched(by: blockSize) {
            encrypted += worker.encrypt(block: chunk)
        }

        // omit unecessary calculation if not needed
        if padding != .noPadding {
            lastBlockRemainder = encrypted.count.quotientAndRemainder(dividingBy: blockSize).remainder
        }

        if var finalizingWorker = worker as? FinalizingEncryptModeWorker, isLast == true {
            encrypted = Array(try finalizingWorker.finalize(encrypt: encrypted.slice))
        }

        return encrypted
    }

    func seek(to: Int) throws {
        fatalError("Not supported")
    }
}
