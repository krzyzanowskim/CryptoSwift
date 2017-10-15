//
//  BlockMode.swift
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

typealias CipherOperationOnBlock = (_ block: ArraySlice<UInt8>) -> Array<UInt8>?

public enum BlockMode {
    case ECB, CBC(iv: Array<UInt8>), PCBC(iv: Array<UInt8>), CFB(iv: Array<UInt8>), OFB(iv: Array<UInt8>), CTR(iv: Array<UInt8>)

    public enum Error: Swift.Error {
        /// Invalid key or IV
        case invalidKeyOrInitializationVector
        /// Invalid IV
        case invalidInitializationVector
    }

    func worker(blockSize: Int, cipherOperation: @escaping CipherOperationOnBlock) throws -> BlockModeWorker {
        switch self {
        case .ECB:
            return ECBModeWorker(cipherOperation: cipherOperation)
        case let .CBC(iv):
            if iv.count != blockSize {
                throw Error.invalidInitializationVector
            }
            return CBCModeWorker(iv: iv.slice, cipherOperation: cipherOperation)
        case let .PCBC(iv):
            if iv.count != blockSize {
                throw Error.invalidInitializationVector
            }
            return PCBCModeWorker(iv: iv.slice, cipherOperation: cipherOperation)
        case let .CFB(iv):
            if iv.count != blockSize {
                throw Error.invalidInitializationVector
            }
            return CFBModeWorker(iv: iv.slice, cipherOperation: cipherOperation)
        case let .OFB(iv):
            if iv.count != blockSize {
                throw Error.invalidInitializationVector
            }
            return OFBModeWorker(iv: iv.slice, cipherOperation: cipherOperation)
        case let .CTR(iv):
            if iv.count != blockSize {
                throw Error.invalidInitializationVector
            }
            return CTRModeWorker(iv: iv.slice, cipherOperation: cipherOperation)
        }
    }

    var options: BlockModeOptions {
        switch self {
        case .ECB:
            return .paddingRequired
        case .CBC:
            return [.initializationVectorRequired, .paddingRequired]
        case .CFB:
            return .initializationVectorRequired
        case .CTR:
            return .initializationVectorRequired
        case .OFB:
            return .initializationVectorRequired
        case .PCBC:
            return [.initializationVectorRequired, .paddingRequired]
        }
    }
}
