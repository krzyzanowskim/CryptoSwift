//
//  BlockMode.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 08/03/16.
//  Copyright © 2016 Marcin Krzyzanowski. All rights reserved.
//

typealias CipherOperationOnBlock = (_ block: Array<UInt8>) -> Array<UInt8>?

public enum BlockMode {
    case ECB, CBC, PCBC, CFB, OFB, CTR

    func worker(_ iv: Array<UInt8>?, cipherOperation: @escaping CipherOperationOnBlock) -> BlockModeWorker {
        switch (self) {
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
        switch (self) {
        case .ECB:
            return .PaddingRequired
        case .CBC:
            return [.InitializationVectorRequired, .PaddingRequired]
        case .CFB:
            return .InitializationVectorRequired
        case .CTR:
            return .InitializationVectorRequired
        case .OFB:
            return .InitializationVectorRequired
        case .PCBC:
            return [.InitializationVectorRequired, .PaddingRequired]
        }
    }
}
