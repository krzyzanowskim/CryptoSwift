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

typealias CipherOperationOnBlock = (_ block: Array<UInt8>) -> Array<UInt8>?

public enum BlockMode {
    case ECB, CBC, PCBC, CFB, OFB, CTR

    func worker(_ iv: Array<UInt8>?, cipherOperation: @escaping CipherOperationOnBlock) -> BlockModeWorker {
        switch self {
        case .ECB:
            return ECBModeWorker(iv: iv ?? [], cipherOperation: cipherOperation)
        case .CBC:
            return CBCModeWorker(iv: iv ?? [], cipherOperation: cipherOperation)
        case .PCBC:
            return PCBCModeWorker(iv: iv ?? [], cipherOperation: cipherOperation)
        case .CFB:
            return CFBModeWorker(iv: iv ?? [], cipherOperation: cipherOperation)
        case .OFB:
            return OFBModeWorker(iv: iv ?? [], cipherOperation: cipherOperation)
        case .CTR:
            return CTRModeWorker(iv: iv ?? [], cipherOperation: cipherOperation)
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
