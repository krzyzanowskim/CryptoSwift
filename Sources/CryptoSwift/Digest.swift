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

@available(*, renamed: "Digest")
public typealias Hash = Digest

/// Hash functions to calculate Digest.
public struct Digest {
  /// Calculate MD5 Digest
  /// - parameter bytes: input message
  /// - returns: Digest bytes
  public static func md5(_ bytes: Array<UInt8>) -> Array<UInt8> {
    MD5().calculate(for: bytes)
  }

  /// Calculate SHA1 Digest
  /// - parameter bytes: input message
  /// - returns: Digest bytes
  public static func sha1(_ bytes: Array<UInt8>) -> Array<UInt8> {
    SHA1().calculate(for: bytes)
  }

  /// Calculate SHA2-224 Digest
  /// - parameter bytes: input message
  /// - returns: Digest bytes
  public static func sha224(_ bytes: Array<UInt8>) -> Array<UInt8> {
    self.sha2(bytes, variant: .sha224)
  }

  /// Calculate SHA2-256 Digest
  /// - parameter bytes: input message
  /// - returns: Digest bytes
  public static func sha256(_ bytes: Array<UInt8>) -> Array<UInt8> {
    self.sha2(bytes, variant: .sha256)
  }

  /// Calculate SHA2-384 Digest
  /// - parameter bytes: input message
  /// - returns: Digest bytes
  public static func sha384(_ bytes: Array<UInt8>) -> Array<UInt8> {
    self.sha2(bytes, variant: .sha384)
  }

  /// Calculate SHA2-512 Digest
  /// - parameter bytes: input message
  /// - returns: Digest bytes
  public static func sha512(_ bytes: Array<UInt8>) -> Array<UInt8> {
    self.sha2(bytes, variant: .sha512)
  }

  /// Calculate SHA2 Digest
  /// - parameter bytes: input message
  /// - parameter variant: SHA-2 variant
  /// - returns: Digest bytes
  public static func sha2(_ bytes: Array<UInt8>, variant: SHA2.Variant) -> Array<UInt8> {
    SHA2(variant: variant).calculate(for: bytes)
  }

  /// Calculate SHA3 Digest
  /// - parameter bytes: input message
  /// - parameter variant: SHA-3 variant
  /// - returns: Digest bytes
  public static func sha3(_ bytes: Array<UInt8>, variant: SHA3.Variant) -> Array<UInt8> {
    SHA3(variant: variant).calculate(for: bytes)
  }
}
