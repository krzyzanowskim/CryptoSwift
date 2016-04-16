//
//  BlockModeGenerator.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 08/03/16.
//  Copyright © 2016 Marcin Krzyzanowski. All rights reserved.
//

// I have no better name for that

enum BlockError: ErrorType {
    case MissingInitializationVector
}

typealias CipherOperationOnBlock = (block: [UInt8]) -> [UInt8]?

protocol BlockModeGenerator: GeneratorType {
    init(iv: Array<UInt8>, cipherOperation: CipherOperationOnBlock, inputGenerator: AnyGenerator<Element>)
}