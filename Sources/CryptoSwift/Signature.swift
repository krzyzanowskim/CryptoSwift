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

public enum SignatureError: Error {
  case sign
  case verify
}

public protocol Signature: AnyObject {
  var keySize: Int { get }

  /// Sign the given bytes at once
  ///
  /// - parameter bytes: Plaintext data to be signed
  /// - returns: The signed data
  func sign(_ bytes: ArraySlice<UInt8>) throws -> Array<UInt8>
  /// Sign the given bytes at once
  ///
  /// - parameter bytes: Plaintext data to be signed
  /// - returns: The signed data
  func sign(_ bytes: Array<UInt8>) throws -> Array<UInt8>

  /// Verify the given bytes against the expected data
  ///
  /// - parameter signature: Signature data
  /// - parameter expectedData: The original data that you expected to be signed
  /// - returns: `True` when the signature is valid for the expected data, `False` otherwise.
  func verify(signature: ArraySlice<UInt8>, for expectedData: ArraySlice<UInt8>) throws -> Bool
  /// Verify the given bytes against the expected data
  ///
  /// - parameter signature: Signature data
  /// - parameter expectedData: The original data that you expected to be signed
  /// - returns: `True` when the signature is valid for the expected data, `False` otherwise.
  func verify(signature: Array<UInt8>, for expectedData: Array<UInt8>) throws -> Bool
}

extension Signature {
  /// Sign the given bytes at once
  ///
  /// - parameter bytes: Plaintext data to be signed
  /// - returns: The signed data
  public func sign(_ bytes: Array<UInt8>) throws -> Array<UInt8> {
    try self.sign(bytes.slice)
  }

  /// Verify the given bytes against the expected data
  ///
  /// - parameter signature: Signature data
  /// - parameter expectedData: The original data that you expected to be signed
  /// - returns: `True` when the signature is valid for the expected data, `False` otherwise.
  public func verify(signature: Array<UInt8>, for expectedData: Array<UInt8>) throws -> Bool {
    try self.verify(signature: signature.slice, for: expectedData.slice)
  }
}
