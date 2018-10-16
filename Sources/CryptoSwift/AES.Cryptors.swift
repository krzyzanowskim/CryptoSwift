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
    public func makeEncryptor() throws -> Cryptor & Updatable {
        let worker = try blockMode.worker(blockSize: AES.blockSize, cipherOperation: encrypt)
        if worker is StreamModeWorker {
            return try StreamEncryptor(blockSize: AES.blockSize, padding: padding, worker)
        }
        return try BlockEncryptor(blockSize: AES.blockSize, padding: padding, worker)
    }

    public func makeDecryptor() throws -> Cryptor & Updatable {
        let cipherOperation: CipherOperationOnBlock = blockMode.options.contains(.useEncryptToDecrypt) == true ? encrypt : decrypt
        let worker = try blockMode.worker(blockSize: AES.blockSize, cipherOperation: cipherOperation)
        if worker is StreamModeWorker {
            return try StreamDecryptor(blockSize: AES.blockSize, padding: padding, worker)
        }
        return try BlockDecryptor(blockSize: AES.blockSize, padding: padding, worker)
    }
}
