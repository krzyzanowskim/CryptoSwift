//
//  Cipher.swift
//  CryptoSwift
//
//  Copyright (C) 2014-2017 Krzyżanowski <marcin@krzyzanowskim.com>
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

public enum CipherError: Error {
    case encrypt
    case decrypt
}

public protocol Cipher: class {
    /// Encrypt given bytes at once
    ///
    /// - parameter bytes: Plaintext data
    /// - returns: Encrypted data
    func encrypt<C: Collection>(_ bytes: C) throws -> Array<UInt8> where C.Element == UInt8, C.IndexDistance == Int, C.Index == Int, C.SubSequence: Collection, C.SubSequence.IndexDistance == C.IndexDistance

    /// Decrypt given bytes at once
    ///
    /// - parameter bytes: Ciphertext data
    /// - returns: Plaintext data
    func decrypt<C: Collection>(_ bytes: C) throws -> Array<UInt8> where C.Element == UInt8, C.IndexDistance == Int, C.Index == Int, C.SubSequence: Collection, C.SubSequence.IndexDistance == C.IndexDistance
}
