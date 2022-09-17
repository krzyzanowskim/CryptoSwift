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

import Foundation

// MARK: Cipher

extension RSA: Cipher {

  @inlinable
  public func encrypt(_ bytes: ArraySlice<UInt8>) throws -> Array<UInt8> {
    return try self.encrypt(Array<UInt8>(bytes), variant: .pksc1v15)
  }

  @inlinable
  public func encrypt(_ bytes: Array<UInt8>, variant: RSAEncryptionVariant) throws -> Array<UInt8> {
    // Prepare the data for the specified variant
    let preparedData = try variant.prepare(bytes, blockSize: self.keySizeBytes)

    // Encrypt the prepared data
    return try variant.formatEncryptedBytes(self.encryptPreparedBytes(preparedData), blockSize: self.keySizeBytes)
  }

  @inlinable
  internal func encryptPreparedBytes(_ bytes: Array<UInt8>) throws -> Array<UInt8> {
    // Calculate encrypted data
    return BigUInteger(Data(bytes)).power(self.e, modulus: self.n).serialize().bytes
  }

  @inlinable
  public func decrypt(_ bytes: ArraySlice<UInt8>) throws -> Array<UInt8> {
    return try self.decrypt(Array<UInt8>(bytes), variant: .pksc1v15)
  }

  @inlinable
  public func decrypt(_ bytes: Array<UInt8>, variant: RSAEncryptionVariant) throws -> Array<UInt8> {
    // Decrypt the data
    let decrypted = try self.decryptPreparedBytes(bytes)

    // Remove padding / unstructure data and return the raw plaintext
    return variant.removePadding(decrypted, blockSize: self.keySizeBytes)
  }

  @inlinable
  internal func decryptPreparedBytes(_ bytes: Array<UInt8>) throws -> Array<UInt8> {
    // Check for Private Exponent presence
    guard let d = d else { throw RSA.Error.noPrivateKey }

    // Calculate decrypted data
    return BigUInteger(Data(bytes)).power(d, modulus: self.n).serialize().bytes
  }
}

extension RSA {
  /// RSA Encryption Block Types
  /// - [RFC2313 8.1 - Encryption block formatting](https://datatracker.ietf.org/doc/html/rfc2313#section-8.1)
  public enum RSAEncryptionVariant {
    /// The `unsafe` encryption variant, is fully deterministic and doesn't format the inbound data in any way.
    ///
    /// - Warning: This is considered an unsafe method of encryption.
    case unsafe
    /// The `raw` encryption variant formats the inbound data with a deterministic padding scheme.
    ///
    /// - Warning: This is also considered to be an unsafe method of encryption, but matches the `Security` frameworks functionality.
    case raw
    /// The `pkcs1v15` encryption variant formats the inbound data with a non deterministic pseudo random padding scheme.
    ///
    /// [EME PKCS1v1.5 Padding Scheme Spec](https://datatracker.ietf.org/doc/html/rfc2313#section-8.1)
    case pksc1v15

    @inlinable
    internal func prepare(_ bytes: Array<UInt8>, blockSize: Int) throws -> Array<UInt8> {
      switch self {
        case .unsafe:
          return bytes
        case .raw:
          // We need at least 11 bytes of padding in order to safely encrypt messages
          // - block types 1 and 2 have this minimum padding requirement, block type 0 isn't specified, but we enforce the minimum padding length here to be safe.
          guard blockSize >= bytes.count + 11 else { throw RSA.Error.invalidMessageLengthForEncryption }
          return Array(repeating: 0x00, count: blockSize - bytes.count) + bytes
        case .pksc1v15:
          // The `Security` framework refuses to encrypt a zero byte message using the pkcs1v15 padding scheme, so we do the same
          guard !bytes.isEmpty else { throw RSA.Error.invalidMessageLengthForEncryption }
          // We need at least 11 bytes of random padding in order to safely encrypt messages (RFC2313 Section 8.1 - Note 6)
          guard blockSize >= bytes.count + 11 else { throw RSA.Error.invalidMessageLengthForEncryption }
          return Padding.eme_pkcs1v15.add(to: bytes, blockSize: blockSize)
      @unknown default:
        assertionFailure()
        return [UInt8](repeating: UInt8.random(in: 0..<UInt8.max), count: bytes.count)
      }
    }

    @inlinable
    internal func formatEncryptedBytes(_ bytes: Array<UInt8>, blockSize: Int) -> Array<UInt8> {
      switch self {
        case .unsafe:
          return bytes
        case .raw, .pksc1v15:
          // Format the encrypted bytes before returning
          return Array<UInt8>(repeating: 0x00, count: blockSize - bytes.count) + bytes
      @unknown default:
        assertionFailure()
        return [UInt8](repeating: UInt8.random(in: 0..<UInt8.max), count: bytes.count)
      }
    }

    @inlinable
    internal func removePadding(_ bytes: Array<UInt8>, blockSize: Int) -> Array<UInt8> {
      switch self {
        case .unsafe:
          return bytes
        case .raw:
          return bytes
        case .pksc1v15:
          // Convert the Octet String into an Integer Primitive using the BigInteger `serialize` method
          // (this effectively just prefixes the data with a 0x00 byte indicating that its a positive integer)
          return Padding.eme_pkcs1v15.remove(from: [0x00] + bytes, blockSize: blockSize)
      @unknown default:
        assertionFailure()
        return [UInt8](repeating: UInt8.random(in: 0..<UInt8.max), count: bytes.count)
      }
    }
  }
}
