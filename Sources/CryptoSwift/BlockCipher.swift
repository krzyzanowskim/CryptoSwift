//
//  BlockCipher.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 15/04/16.
//  Copyright © 2016 Marcin Krzyzanowski. All rights reserved.
//

protocol BlockCipher: Cipher {
    static var blockSize: Int { get }
}
