//
//  BlockMode.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 08/03/16.
//  Copyright © 2016 Marcin Krzyzanowski. All rights reserved.
//

import Foundation

// I have no better name for that
typealias CipherOperationOnBlock = (block: [UInt8]) -> [UInt8]?

enum BlockError: ErrorType {
    case MissingInitializationVector
}

protocol BlockMode {
    var options: BlockModeOptions { get }
    func encryptBlocks(blocks:[[UInt8]], iv:[UInt8]?, cipherOperation:CipherOperationOnBlock) throws -> [UInt8]
    func decryptBlocks(blocks:[[UInt8]], iv:[UInt8]?, cipherOperation:CipherOperationOnBlock) throws -> [UInt8]
}