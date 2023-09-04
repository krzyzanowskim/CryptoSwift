//
//  CryptoSwift
//
//  Copyright (C) Marcin Krzyżanowski <marcin@krzyzanowskim.com>
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

import Foundation

/// This class implements the XChaCha20-Poly1305 Authenticated Encryption with
/// Associated Data (AEAD_XCHACHA20_POLY1305) construction, providing both encryption and authentication.
///
/// For more information about the XChaCha20-Poly1305 algorithm, refer to the IETF draft: https://datatracker.ietf.org/doc/html/draft-irtf-cfrg-xchacha
public final class AEADXChaCha20Poly1305: AEAD {

  /// The key length (in bytes) required for the XChaCha20 cipher (32 bytes).
  public static let kLen = 32 // key length

  /// The valid range of initialization vector lengths for the XChaCha20 cipher (12 bytes).
  public static var ivRange = Range<Int>(12...12)

  /// Encrypts the given plaintext using the XChaCha20 cipher and generates an authentication
  /// tag using the Poly1305 MAC.
  ///
  /// - Parameters:
  ///   - plainText: The plaintext to be encrypted.
  ///   - key: The encryption key.
  ///   - iv: The initialization vector.
  ///   - authenticationHeader: The authentication header.
  /// - Returns: A tuple containing the ciphertext and authentication tag.
  /// - Throws: An error if encryption fails.
  public static func encrypt(
    _ plainText: Array<UInt8>,
    key: Array<UInt8>,
    iv: Array<UInt8>,
    authenticationHeader: Array<UInt8>
  ) throws -> (cipherText: Array<UInt8>, authenticationTag: Array<UInt8>) {
    try AEADChaCha20Poly1305.encrypt(
      cipher: XChaCha20(key: key, iv: iv),
      plainText,
      key: key,
      iv: iv,
      authenticationHeader: authenticationHeader
    )
  }

  /// Decrypts the given ciphertext using the XChaCha20 cipher and verifies the authentication
  /// tag using the Poly1305 MAC.
  ///
  /// - Parameters:
  ///   - cipherText: The ciphertext to be decrypted.
  ///   - key: The decryption key.
  ///   - iv: The initialization vector.
  ///   - authenticationHeader: The authentication header.
  ///   - authenticationTag: The authentication tag.
  /// - Returns: A tuple containing the decrypted plaintext and a boolean value indicating
  ///   the success of the decryption and authentication process.
  /// - Throws: An error if decryption fails.
  public static func decrypt(
    _ cipherText: Array<UInt8>,
    key: Array<UInt8>,
    iv: Array<UInt8>,
    authenticationHeader: Array<UInt8>,
    authenticationTag: Array<UInt8>
  ) throws -> (plainText: Array<UInt8>, success: Bool) {
    try AEADChaCha20Poly1305.decrypt(
      cipher: XChaCha20(key: key, iv: iv),
      cipherText: cipherText,
      key: key,
      iv: iv,
      authenticationHeader: authenticationHeader,
      authenticationTag: authenticationTag
    )
  }
}
