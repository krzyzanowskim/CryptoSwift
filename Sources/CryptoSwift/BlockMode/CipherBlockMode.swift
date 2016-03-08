//
//  CipherBlockMode.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 08/03/16.
//  Copyright © 2016 Marcin Krzyzanowski. All rights reserved.
//

import Foundation

public enum CipherBlockMode {
    case ECB, CBC, PCBC, CFB, OFB, CTR

    func encryptGenerator(iv: Array<UInt8>?, cipherOperation: CipherOperationOnBlock, inputGenerator: AnyGenerator<Array<UInt8>>) -> AnyGenerator<Array<UInt8>> {
        switch (self) {
        case CBC:
            return AnyGenerator<Array<UInt8>>(CBCModeEncryptGenerator(iv: iv ?? [], cipherOperation: cipherOperation, inputGenerator: inputGenerator))
        default:
            fatalError("Unimplemented")
        }
    }

    func decryptGenerator(iv: Array<UInt8>?, cipherOperation: CipherOperationOnBlock, inputGenerator: AnyGenerator<Array<UInt8>>) -> AnyGenerator<Array<UInt8>> {
        switch (self) {
        case CBC:
            return AnyGenerator<Array<UInt8>>(CBCModeDecryptGenerator(iv: iv ?? [], cipherOperation: cipherOperation, inputGenerator: inputGenerator))
        default:
            fatalError("Unimplemented")
        }
    }

    var options: BlockModeOptions {
        switch (self) {
        case .CBC:
            return [.InitializationVectorRequired, .PaddingRequired]
        case .CFB:
            return .InitializationVectorRequired
        case .CTR:
            return .InitializationVectorRequired
        case .ECB:
            return .PaddingRequired
        case .OFB:
            return .InitializationVectorRequired
        case .PCBC:
            return [.InitializationVectorRequired, .PaddingRequired]
        }
    }

    /**
     Process input blocks with given block cipher mode. With fallback to plain mode.

     - parameter blocks: cipher block size blocks
     - parameter iv:     IV
     - parameter cipher: single block encryption closure

     - returns: encrypted bytes
     */
//    func encryptBlocks(blocks:[[UInt8]], iv:[UInt8]?, cipherOperation:CipherOperationOnBlock) throws -> [UInt8] {
//
//        // if IV is not available, fallback to plain
//        var finalBlockMode:CipherBlockMode = self
//        if (iv == nil) {
//            finalBlockMode = .ECB
//        }
//
//        return try finalBlockMode.mode.encryptBlocks(blocks, iv: iv, cipherOperation: cipherOperation)
//    }
//
//    func decryptBlocks(blocks:[[UInt8]], iv:[UInt8]?, cipherOperation:CipherOperationOnBlock) throws -> [UInt8] {
//        // if IV is not available, fallback to plain
//        var finalBlockMode:CipherBlockMode = self
//        if (iv == nil) {
//            finalBlockMode = .ECB
//        }
//
//        return try finalBlockMode.mode.decryptBlocks(blocks, iv: iv, cipherOperation: cipherOperation)
//    }
}