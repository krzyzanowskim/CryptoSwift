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

    private var mode:BlockMode {
        switch (self) {
        case CBC:
            return CBCMode()
        case PCBC:
            return PCBCMode()
        case CFB:
            return CFBMode()
        case OFB:
            return OFBMode()
        case ECB:
            return ECBMode()
        case CTR:
            return CTRMode()
        }
    }

    var options: BlockModeOptions { return mode.options }

    /**
     Process input blocks with given block cipher mode. With fallback to plain mode.

     - parameter blocks: cipher block size blocks
     - parameter iv:     IV
     - parameter cipher: single block encryption closure

     - returns: encrypted bytes
     */
    func encryptBlocks(blocks:[[UInt8]], iv:[UInt8]?, cipherOperation:CipherOperationOnBlock) throws -> [UInt8] {

        // if IV is not available, fallback to plain
        var finalBlockMode:CipherBlockMode = self
        if (iv == nil) {
            finalBlockMode = .ECB
        }

        return try finalBlockMode.mode.encryptBlocks(blocks, iv: iv, cipherOperation: cipherOperation)
    }

    func decryptBlocks(blocks:[[UInt8]], iv:[UInt8]?, cipherOperation:CipherOperationOnBlock) throws -> [UInt8] {
        // if IV is not available, fallback to plain
        var finalBlockMode:CipherBlockMode = self
        if (iv == nil) {
            finalBlockMode = .ECB
        }

        return try finalBlockMode.mode.decryptBlocks(blocks, iv: iv, cipherOperation: cipherOperation)
    }
}