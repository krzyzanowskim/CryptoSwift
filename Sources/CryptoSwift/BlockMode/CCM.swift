////  CryptoSwift
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

// CCM mode combines the well known CBC-MAC with the well known counter mode of encryption.

public final class CCM: BlockMode {
    public enum Error: Swift.Error {
        /// Invalid IV
        case invalidInitializationVector
    }

    public let options: BlockModeOption = [.initializationVectorRequired, .useEncryptToDecrypt]

    public func worker(blockSize: Int, cipherOperation: @escaping CipherOperationOnBlock) throws -> CipherModeWorker {
        fatalError("Not implemented")
    }
}


struct CCMModeWorker: StreamModeWorker, CounterModeWorker {
    var counter: CTRModeWorker.CTRCounter

    func seek(to position: Int) throws {
        fatalError("Unimplemented")
    }

    typealias Counter = CTRModeWorker.CTRCounter

    var cipherOperation: CipherOperationOnBlock

    var additionalBufferSize: Int

    func encrypt(block plaintext: ArraySlice<UInt8>) -> Array<UInt8> {
        fatalError("Unimplemented")
    }

    func decrypt(block ciphertext: ArraySlice<UInt8>) -> Array<UInt8> {
        fatalError("Unimplemented")
    }

}
