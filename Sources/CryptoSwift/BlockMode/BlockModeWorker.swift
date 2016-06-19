//
//  BlockModeWorker.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 06/05/16.
//  Copyright © 2016 Marcin Krzyzanowski. All rights reserved.
//

protocol BlockModeWorker {
    var cipherOperation: CipherOperationOnBlock { get }
    mutating func encrypt(plaintext: Array<UInt8>) -> Array<UInt8>
    mutating func decrypt(ciphertext: Array<UInt8>) -> Array<UInt8>
}
