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

// MARK: Signatures & Verification

extension RSA: Signature {
  public func sign(_ bytes: ArraySlice<UInt8>) throws -> Array<UInt8> {
    try self.sign(Array(bytes), variant: .message_pkcs1v15_SHA256)
  }

  /// Signs the data using the Private key and the specified signature variant
  /// - Parameters:
  ///   - bytes: The data to be signed
  ///   - variant: The variant to use (`digest` variants expect a pre-hashed digest matching that of the specified hash function, `message` variants will hash the data using the specified hash function before signing it)
  /// - Returns: The signature of the data
  public func sign(_ bytes: Array<UInt8>, variant: SignatureVariant) throws -> Array<UInt8> {
    // Check for Private Exponent presence
    guard let d = d else { throw RSA.Error.noPrivateKey }

    // Hash & Encode Message
    let hashedAndEncoded = try RSA.hashedAndEncoded(bytes, variant: variant, keySizeInBytes: self.keySizeBytes)

    /// Calculate the Signature
    let signedData = BigUInteger(Data(hashedAndEncoded)).power(d, modulus: self.n).serialize().bytes

    return variant.formatSignedBytes(signedData, blockSize: self.keySizeBytes)
  }

  public func verify(signature: ArraySlice<UInt8>, for expectedData: ArraySlice<UInt8>) throws -> Bool {
    try self.verify(signature: Array(signature), for: Array(expectedData), variant: .message_pkcs1v15_SHA256)
  }

  /// Verifies whether a Signature is valid for the provided data
  /// - Parameters:
  ///   - signature: The signature to verify
  ///   - expectedData: The original data that you expected to have been signed
  ///   - variant: The variant used to sign the data
  /// - Returns: `True` when the signature is valid for the expected data, `False` otherwise.
  ///
  /// [IETF Verification Spec](https://datatracker.ietf.org/doc/html/rfc8017#section-8.2.2)
  public func verify(signature: Array<UInt8>, for bytes: Array<UInt8>, variant: SignatureVariant) throws -> Bool {
    /// Step 1: Ensure the signature is the same length as the key's modulus
    guard signature.count == self.keySizeBytes else { throw Error.invalidSignatureLength }

    /// Prepare the expected message for signature comparison
    var expectedData = try RSA.hashedAndEncoded(bytes, variant: variant, keySizeInBytes: self.keySizeBytes)
    if expectedData.count == self.keySizeBytes && expectedData.prefix(1) == [0x00] { expectedData = Array(expectedData.dropFirst()) }

    /// Step 2: 'Decrypt' the signature
    let signatureResult = BigUInteger(Data(signature)).power(self.e, modulus: self.n).serialize().bytes

    /// Step 3: Compare the 'decrypted' signature with the prepared / encoded expected message....
    guard signatureResult == expectedData else { return false }

    return true
  }

  /// Hashes and Encodes a message for signing and verifying
  ///
  /// - Note: [EMSA-PKCS1-v1_5](https://datatracker.ietf.org/doc/html/rfc8017#section-9.2)
  fileprivate static func hashedAndEncoded(_ bytes: [UInt8], variant: SignatureVariant, keySizeInBytes: Int) throws -> Array<UInt8> {
    /// 1.  Apply the hash function to the message M to produce a hash
    let hashedMessage = variant.calculateHash(bytes)

    guard variant.enforceLength(hashedMessage, keySizeInBytes: keySizeInBytes) else { throw RSA.Error.invalidMessageLengthForSigning }

    /// 2. Encode the algorithm ID for the hash function and the hash value into an ASN.1 value of type DigestInfo
    /// PKCS#1_15 DER Structure (OID == sha256WithRSAEncryption)
    let t = variant.encode(hashedMessage)

    if case .raw = variant { return t }

    /// 3.  If emLen < tLen + 11, output "intended encoded message length too short" and stop
    if keySizeInBytes < t.count + 11 { throw RSA.Error.invalidMessageLengthForSigning }

    /// 4.  Generate an octet string PS consisting of emLen - tLen - 3
    /// octets with hexadecimal value 0xff. The length of PS will be
    /// at least 8 octets.
    /// 5.  Concatenate PS, the DER encoding T, and other padding to form
    /// the encoded message EM as EM = 0x00 || 0x01 || PS || 0x00 || T.
    let padded = variant.pad(bytes: t, to: keySizeInBytes)

    /// Ensure the signature is of the correct length
    guard padded.count == keySizeInBytes else { throw RSA.Error.invalidMessageLengthForSigning }

    return padded
  }
}

extension RSA {
  public enum SignatureVariant {
    /// rsaSignatureRaw
    case raw
    /// Hashes the raw message using MD5 before signing the data
    case message_pkcs1v15_MD5
    /// Hashes the raw message using SHA1 before signing the data
    case message_pkcs1v15_SHA1
    /// Hashes the raw message using SHA224 before signing the data
    case message_pkcs1v15_SHA224
    /// Hashes the raw message using SHA256 before signing the data
    case message_pkcs1v15_SHA256
    /// Hashes the raw message using SHA384 before signing the data
    case message_pkcs1v15_SHA384
    /// Hashes the raw message using SHA512 before signing the data
    case message_pkcs1v15_SHA512
    /// Hashes the raw message using SHA512-224 before signing the data
    case message_pkcs1v15_SHA512_224
    /// Hashes the raw message using SHA512-256 before signing the data
    case message_pkcs1v15_SHA512_256
    /// Hashes the raw message using SHA3_256 before signing the data
    case message_pkcs1v15_SHA3_256
    /// Hashes the raw message using SHA3_384 before signing the data
    case message_pkcs1v15_SHA3_384
    /// Hashes the raw message using SHA3_512 before signing the data
    case message_pkcs1v15_SHA3_512
    /// This variant isn't supported yet
    case digest_pkcs1v15_RAW
    /// This variant expects that the data to be signed is a valid MD5 Hash Digest
    case digest_pkcs1v15_MD5
    /// This variant expects that the data to be signed is a valid SHA1 Hash Digest
    case digest_pkcs1v15_SHA1
    /// This variant expects that the data to be signed is a valid SHA224 Hash Digest
    case digest_pkcs1v15_SHA224
    /// This variant expects that the data to be signed is a valid SHA256 Hash Digest
    case digest_pkcs1v15_SHA256
    /// This variant expects that the data to be signed is a valid SHA384 Hash Digest
    case digest_pkcs1v15_SHA384
    /// This variant expects that the data to be signed is a valid SHA512 Hash Digest
    case digest_pkcs1v15_SHA512
    /// This variant expects that the data to be signed is a valid SHA512-224 Hash Digest
    case digest_pkcs1v15_SHA512_224
    /// This variant expects that the data to be signed is a valid SHA512-256 Hash Digest
    case digest_pkcs1v15_SHA512_256
    /// This variant expects that the data to be signed is a valid SHA3-256 Hash Digest
    case digest_pkcs1v15_SHA3_256
    /// This variant expects that the data to be signed is a valid SHA3-384 Hash Digest
    case digest_pkcs1v15_SHA3_384
    /// This variant expects that the data to be signed is a valid SHA3-512 Hash Digest
    case digest_pkcs1v15_SHA3_512
    
    internal var identifier: Array<UInt8> {
      switch self {
        case .raw, .digest_pkcs1v15_RAW: return []
        case .message_pkcs1v15_MD5, .digest_pkcs1v15_MD5: return Array<UInt8>(arrayLiteral: 0x2a, 0x86, 0x48, 0x86, 0xf7, 0x0d, 0x02, 0x05)
        case .message_pkcs1v15_SHA1, .digest_pkcs1v15_SHA1: return Array<UInt8>(arrayLiteral: 0x2b, 0x0e, 0x03, 0x02, 0x1a)
        case .message_pkcs1v15_SHA256, .digest_pkcs1v15_SHA256: return Array<UInt8>(arrayLiteral: 0x60, 0x86, 0x48, 0x01, 0x65, 0x03, 0x04, 0x02, 0x01)
        case .message_pkcs1v15_SHA384, .digest_pkcs1v15_SHA384: return Array<UInt8>(arrayLiteral: 0x60, 0x86, 0x48, 0x01, 0x65, 0x03, 0x04, 0x02, 0x02)
        case .message_pkcs1v15_SHA512, .digest_pkcs1v15_SHA512: return Array<UInt8>(arrayLiteral: 0x60, 0x86, 0x48, 0x01, 0x65, 0x03, 0x04, 0x02, 0x03)
        case .message_pkcs1v15_SHA224, .digest_pkcs1v15_SHA224: return Array<UInt8>(arrayLiteral: 0x60, 0x86, 0x48, 0x01, 0x65, 0x03, 0x04, 0x02, 0x04)
        case .message_pkcs1v15_SHA512_224, .digest_pkcs1v15_SHA512_224: return Array<UInt8>(arrayLiteral: 0x60, 0x86, 0x48, 0x01, 0x65, 0x03, 0x04, 0x02, 0x05)
        case .message_pkcs1v15_SHA512_256, .digest_pkcs1v15_SHA512_256: return Array<UInt8>(arrayLiteral: 0x60, 0x86, 0x48, 0x01, 0x65, 0x03, 0x04, 0x02, 0x06)
        case .message_pkcs1v15_SHA3_256, .digest_pkcs1v15_SHA3_256: return Array<UInt8>(arrayLiteral: 0x60, 0x86, 0x48, 0x01, 0x65, 0x03, 0x04, 0x02, 0x08)
        case .message_pkcs1v15_SHA3_384, .digest_pkcs1v15_SHA3_384: return Array<UInt8>(arrayLiteral: 0x60, 0x86, 0x48, 0x01, 0x65, 0x03, 0x04, 0x02, 0x09)
        case .message_pkcs1v15_SHA3_512, .digest_pkcs1v15_SHA3_512: return Array<UInt8>(arrayLiteral: 0x60, 0x86, 0x48, 0x01, 0x65, 0x03, 0x04, 0x02, 0x0A)
      }
    }
    
    internal func calculateHash(_ bytes: Array<UInt8>) -> Array<UInt8> {
      switch self {
        case .message_pkcs1v15_MD5:
          return Digest.md5(bytes)
        case .message_pkcs1v15_SHA1:
          return Digest.sha1(bytes)
        case .message_pkcs1v15_SHA224:
          return Digest.sha224(bytes)
        case .message_pkcs1v15_SHA256:
          return Digest.sha256(bytes)
        case .message_pkcs1v15_SHA384:
          return Digest.sha384(bytes)
        case .message_pkcs1v15_SHA512:
          return Digest.sha512(bytes)
        case .message_pkcs1v15_SHA512_224:
          return Digest.sha2(bytes, variant: .sha224)
        case .message_pkcs1v15_SHA512_256:
          return Digest.sha2(bytes, variant: .sha256)
        case .message_pkcs1v15_SHA3_256:
          return Digest.sha3(bytes, variant: .sha256)
        case .message_pkcs1v15_SHA3_384:
          return Digest.sha3(bytes, variant: .sha384)
        case .message_pkcs1v15_SHA3_512:
          return Digest.sha3(bytes, variant: .sha512)
        case .raw,
            .digest_pkcs1v15_RAW,
            .digest_pkcs1v15_MD5,
            .digest_pkcs1v15_SHA1,
            .digest_pkcs1v15_SHA224,
            .digest_pkcs1v15_SHA256,
            .digest_pkcs1v15_SHA384,
            .digest_pkcs1v15_SHA512,
            .digest_pkcs1v15_SHA512_224,
            .digest_pkcs1v15_SHA512_256,
            .digest_pkcs1v15_SHA3_256,
            .digest_pkcs1v15_SHA3_384,
            .digest_pkcs1v15_SHA3_512:
        return bytes
      }
    }
    
    internal func enforceLength(_ bytes: Array<UInt8>, keySizeInBytes: Int) -> Bool {
      switch self {
        case .raw, .digest_pkcs1v15_RAW:
          return bytes.count <= keySizeInBytes
        case .digest_pkcs1v15_MD5:
          return bytes.count <= 16
        case .digest_pkcs1v15_SHA1:
          return bytes.count <= 20
        case .digest_pkcs1v15_SHA224:
          return bytes.count <= 28
        case .digest_pkcs1v15_SHA256, .digest_pkcs1v15_SHA3_256:
          return bytes.count <= 32
        case .digest_pkcs1v15_SHA384, .digest_pkcs1v15_SHA3_384:
          return bytes.count <= 48
        case .digest_pkcs1v15_SHA512, .digest_pkcs1v15_SHA3_512:
          return bytes.count <= 64
        case .digest_pkcs1v15_SHA512_224:
          return bytes.count <= 28
        case .digest_pkcs1v15_SHA512_256:
          return bytes.count <= 32
        case .message_pkcs1v15_MD5,
            .message_pkcs1v15_SHA1,
            .message_pkcs1v15_SHA224,
            .message_pkcs1v15_SHA256,
            .message_pkcs1v15_SHA384,
            .message_pkcs1v15_SHA512,
            .message_pkcs1v15_SHA512_224,
            .message_pkcs1v15_SHA512_256,
            .message_pkcs1v15_SHA3_256,
            .message_pkcs1v15_SHA3_384,
            .message_pkcs1v15_SHA3_512:
        return true
      }
    }

    internal func encode(_ bytes: Array<UInt8>) -> Array<UInt8> {
      switch self {
        case .raw, .digest_pkcs1v15_RAW:
          return bytes

        default:
          let asn: ASN1.Node = .sequence(nodes: [
            .sequence(nodes: [
              .objectIdentifier(data: Data(self.identifier)),
              .null
            ]),
            .octetString(data: Data(bytes))
          ])

          return ASN1.Encoder.encode(asn)
      }
    }

    /// Right now the only Padding Scheme supported is [EMCS-PKCS1v15](https://www.rfc-editor.org/rfc/rfc8017#section-9.2) (others include [EMSA-PSS](https://www.rfc-editor.org/rfc/rfc8017#section-9.1))
    internal func pad(bytes: Array<UInt8>, to blockSize: Int) -> Array<UInt8> {
      switch self {
        case .raw:
          return bytes
        default:
          return Padding.emsa_pkcs1v15.add(to: bytes, blockSize: blockSize)
      }
    }

    /// Zero pads a signature to the specified block size
    /// - Parameters:
    ///   - bytes: The signed bytes
    ///   - blockSize: The block size to pad until
    /// - Returns: A zero padded (prepended) bytes array of length blockSize
    internal func formatSignedBytes(_ bytes: Array<UInt8>, blockSize: Int) -> Array<UInt8> {
      switch self {
        default:
          // Format the encrypted bytes before returning
          return Array<UInt8>(repeating: 0x00, count: blockSize - bytes.count) + bytes
      }
    }
  }
}
