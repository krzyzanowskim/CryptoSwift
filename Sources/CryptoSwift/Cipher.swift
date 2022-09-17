//
//  CryptoSwift
//
//  Copyright (C) 2014-2022 Marcin Krzyżanowski <marcin@krzyzanowskim.com>
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

public protocol Cipher: AnyObject {
  var keySize: Int { get }

  /// Encrypt given bytes at once
  ///
  /// - parameter bytes: Plaintext data
  /// - returns: Encrypted data
  func encrypt(_ bytes: ArraySlice<UInt8>) throws -> Array<UInt8>
  func encrypt(_ bytes: Array<UInt8>) throws -> Array<UInt8>

  /// Decrypt given bytes at once
  ///
  /// - parameter bytes: Ciphertext data
  /// - returns: Plaintext data
  func decrypt(_ bytes: ArraySlice<UInt8>) throws -> Array<UInt8>
  func decrypt(_ bytes: Array<UInt8>) throws -> Array<UInt8>
}

extension Cipher {
  public func encrypt(_ bytes: Array<UInt8>) throws -> Array<UInt8> {
    try self.encrypt(bytes.slice)
  }

  public func decrypt(_ bytes: Array<UInt8>) throws -> Array<UInt8> {
    try self.decrypt(bytes.slice)
  }
}
