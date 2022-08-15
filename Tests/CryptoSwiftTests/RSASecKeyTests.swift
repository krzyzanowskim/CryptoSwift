//
//  RSASecKeyTests.swift
//
//
//  Created by Brandon Toms on 7/6/22.
//

#if canImport(Security)

  import Security
  import XCTest
  @testable import CryptoSwift

  final class RSASecKeyTests: XCTestCase {

    // MARK: SecKey <-> RSA Interoperability

    // From CryptoSwift RSA -> External Representation -> SecKey
    func testRSAExternalRepresentationPrivate() throws {

      // Generate a CryptoSwift RSA Key
      let rsaCryptoSwift = try RSA(keySize: 1024)

      // Get the key's rawExternalRepresentation
      let rsaCryptoSwiftRawRep = try rsaCryptoSwift.privateKeyDER()

      // We should be able to instantiate an RSA SecKey from this data
      let attributes: [String: Any] = [
        kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
        kSecAttrKeyClass as String: kSecAttrKeyClassPrivate,
        kSecAttrKeySizeInBits as String: 1024,
        kSecAttrIsPermanent as String: false
      ]
      var error: Unmanaged<CFError>?
      guard let rsaSecKey = SecKeyCreateWithData(Data(rsaCryptoSwiftRawRep) as CFData, attributes as CFDictionary, &error) else {
        XCTFail("Error constructing SecKey from raw key data: \(error.debugDescription)")
        return
      }

      // Get the SecKey's external representation
      var externalRepError: Unmanaged<CFError>?
      guard let rsaSecKeyRawRep = SecKeyCopyExternalRepresentation(rsaSecKey, &externalRepError) as? Data else {
        XCTFail("Failed to copy external representation for RSA SecKey")
        return
      }

      // Ensure both the CryptoSwift Ext Rep and the SecKey Ext Rep match
      XCTAssertEqual(rsaSecKeyRawRep, Data(rsaCryptoSwiftRawRep))
      XCTAssertEqual(rsaSecKeyRawRep, try rsaCryptoSwift.externalRepresentation())
    }

    /// From CryptoSwift RSA -> External Representation -> SecKey
    func testRSAExternalRepresentationPublic() throws {

      // Generate a CryptoSwift RSA Key
      let rsaCryptoSwift = try RSA(keySize: 1024)

      // Get the key's rawExternalRepresentation
      let rsaCryptoSwiftRawRep = try rsaCryptoSwift.publicKeyDER()

      // We should be able to instantiate an RSA SecKey from this data
      let attributes: [String: Any] = [
        kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
        kSecAttrKeyClass as String: kSecAttrKeyClassPublic,
        kSecAttrKeySizeInBits as String: 1024,
        kSecAttrIsPermanent as String: false
      ]
      var error: Unmanaged<CFError>?
      guard let rsaSecKey = SecKeyCreateWithData(Data(rsaCryptoSwiftRawRep) as CFData, attributes as CFDictionary, &error) else {
        XCTFail("Error constructing SecKey from raw key data: \(error.debugDescription)")
        return
      }

      // Get the SecKey's external representation
      var externalRepError: Unmanaged<CFError>?
      guard let rsaSecKeyRawRep = SecKeyCopyExternalRepresentation(rsaSecKey, &externalRepError) as? Data else {
        XCTFail("Failed to copy external representation for RSA SecKey")
        return
      }

      // Ensure both the CryptoSwift Ext Rep and the SecKey Ext Rep match
      XCTAssertEqual(rsaSecKeyRawRep, Data(rsaCryptoSwiftRawRep))
      XCTAssertEqual(rsaSecKeyRawRep, try rsaCryptoSwift.publicKeyExternalRepresentation())
    }

    /// From SecKey -> External Representation -> CryptoSwift RSA
    func testSecKeyExternalRepresentationPrivate() throws {
      // Generate a SecKey RSA Key
      let parameters: [CFString: Any] = [
        kSecAttrKeyType: kSecAttrKeyTypeRSA,
        kSecAttrKeySizeInBits: 1024
      ]

      var error: Unmanaged<CFError>?

      // Generate the RSA SecKey
      guard let rsaSecKey = SecKeyCreateRandomKey(parameters as CFDictionary, &error) else {
        XCTFail("Key Generation Error: \(error.debugDescription)")
        return
      }

      // Lets grab the external representation
      var externalRepError: Unmanaged<CFError>?
      guard let rsaSecKeyRawRep = SecKeyCopyExternalRepresentation(rsaSecKey, &externalRepError) as? Data else {
        XCTFail("Failed to copy external representation for RSA SecKey")
        return
      }

      // Ensure we can import the private RSA key into CryptoSwift
      let rsaCryptoSwift = try RSA(rawRepresentation: rsaSecKeyRawRep)

      XCTAssertNotNil(rsaCryptoSwift.d)
      XCTAssertEqual(rsaSecKeyRawRep, try rsaCryptoSwift.externalRepresentation())
    }

    /// From SecKey -> External Representation -> CryptoSwift RSA
    func testSecKeyExternalRepresentationPublic() throws {
      // Generate a SecKey RSA Key
      let parameters: [CFString: Any] = [
        kSecAttrKeyType: kSecAttrKeyTypeRSA,
        kSecAttrKeySizeInBits: 1024
      ]

      var error: Unmanaged<CFError>?

      // Generate the RSA SecKey
      guard let rsaSecKey = SecKeyCreateRandomKey(parameters as CFDictionary, &error) else {
        XCTFail("Key Generation Error: \(error.debugDescription)")
        return
      }

      // Extract the public key from the private RSA SecKey
      guard let rsaSecKeyPublic = SecKeyCopyPublicKey(rsaSecKey) else {
        XCTFail("Public Key Extraction Error")
        return
      }

      // Lets grab the external representation of the public key
      var externalRepError: Unmanaged<CFError>?
      guard let rsaSecKeyRawRep = SecKeyCopyExternalRepresentation(rsaSecKeyPublic, &externalRepError) as? Data else {
        XCTFail("Failed to copy external representation for RSA SecKey")
        return
      }

      // Ensure we can import the private RSA key into CryptoSwift
      let rsaCryptoSwift = try RSA(rawRepresentation: rsaSecKeyRawRep)

      XCTAssertNil(rsaCryptoSwift.d)
      XCTAssertEqual(rsaSecKeyRawRep, try rsaCryptoSwift.externalRepresentation())
    }

    func testRSASecKey() throws {

      let tests = 1
      let messageToSign: String = "RSA Keys!"

      for _ in 0..<tests {

        // Generate a SecKey RSA Key
        let parameters: [CFString: Any] = [
          kSecAttrKeyType: kSecAttrKeyTypeRSA,
          kSecAttrKeySizeInBits: 1024
        ]

        var error: Unmanaged<CFError>?

        // Generate the RSA SecKey
        guard let rsaSecKey = SecKeyCreateRandomKey(parameters as CFDictionary, &error) else {
          XCTFail("Key Generation Error: \(error.debugDescription)")
          break
        }

        // Lets grab the external representation
        var externalRepError: Unmanaged<CFError>?
        guard let rsaSecKeyRawRep = SecKeyCopyExternalRepresentation(rsaSecKey, &externalRepError) as? Data else {
          XCTFail("Failed to copy external representation for RSA SecKey")
          break
        }

        // Ensure we can import the private RSA key into CryptoSwift
        let rsaCryptoSwift = try RSA(rawRepresentation: rsaSecKeyRawRep)

        // Sign the message with both keys and ensure their the same
        let csSignature = try rsaCryptoSwift.sign(messageToSign.bytes, variant: .message_pkcs1v15_SHA256)

        let skSignature = try secKeySign(messageToSign.bytes, variant: .rsaSignatureMessagePKCS1v15SHA256, withKey: rsaSecKey)

        XCTAssertEqual(csSignature, skSignature.bytes, "Signature don't match!")

        XCTAssertTrue(try rsaCryptoSwift.verify(signature: skSignature.bytes, for: messageToSign.bytes, variant: .message_pkcs1v15_SHA256))
        XCTAssertTrue(try self.secKeyVerify(csSignature, forBytes: messageToSign.bytes, usingVariant: .rsaSignatureMessagePKCS1v15SHA256, withKey: rsaSecKey))

        // Encrypt with SecKey
        let skEncryption = try secKeyEncrypt(messageToSign.bytes, usingVariant: .rsaEncryptionRaw, withKey: rsaSecKey)
        // Decrypt with CryptoSwift Key
        XCTAssertEqual(try rsaCryptoSwift.decrypt(skEncryption.bytes, variant: .unsafe), messageToSign.bytes, "CryptoSwift Decryption of SecKey Encryption Failed")

        // Encrypt with CryptoSwift
        let csEncryption = try rsaCryptoSwift.encrypt(messageToSign.bytes, variant: .unsafe)
        // Decrypt with SecKey
        XCTAssertEqual(try self.secKeyDecrypt(csEncryption, usingVariant: .rsaEncryptionRaw, withKey: rsaSecKey).bytes, messageToSign.bytes, "SecKey Decryption of CryptoSwift Encryption Failed")

        //print(csEncryption)
        //print(skEncryption.bytes)
        XCTAssertEqual(csEncryption, skEncryption.bytes, "Encrypted Data Does Not Match")

        // Encrypt with SecKey
        let skEncryption2 = try secKeyEncrypt(messageToSign.bytes, usingVariant: .rsaEncryptionPKCS1, withKey: rsaSecKey)
        // Decrypt with CryptoSwift Key
        XCTAssertEqual(try rsaCryptoSwift.decrypt(skEncryption2.bytes, variant: .pksc1v15), messageToSign.bytes, "CryptoSwift Decryption of SecKey Encryption Failed")

        // Encrypt with CryptoSwift
        let csEncryption2 = try rsaCryptoSwift.encrypt(messageToSign.bytes, variant: .pksc1v15)
        // Decrypt with SecKey
        XCTAssertEqual(try self.secKeyDecrypt(csEncryption2, usingVariant: .rsaEncryptionPKCS1, withKey: rsaSecKey).bytes, messageToSign.bytes, "SecKey Decryption of CryptoSwift Encryption Failed")

        print(csEncryption2.count)
        print(skEncryption2.bytes.count)
      }
    }

    private func secKeySign(_ bytes: Array<UInt8>, variant: SecKeyAlgorithm, withKey key: SecKey) throws -> Data {
      var error: Unmanaged<CFError>?

      // Sign the data
      guard let signature = SecKeyCreateSignature(
        key,
        variant,
        Data(bytes) as CFData,
        &error
      ) as Data?
      else { throw NSError(domain: "Failed to sign bytes: \(bytes)", code: 0) }

      return signature
    }

    private func secKeyVerify(_ signature: Array<UInt8>, forBytes bytes: Array<UInt8>, usingVariant variant: SecKeyAlgorithm, withKey key: SecKey) throws -> Bool {
      let pubKey = SecKeyCopyPublicKey(key)!

      var error: Unmanaged<CFError>?

      // Perform the signature verification
      let result = SecKeyVerifySignature(
        pubKey,
        variant,
        Data(bytes) as CFData,
        Data(signature) as CFData,
        &error
      )

      // Throw the error if we encountered one...
      if let error = error { throw error.takeRetainedValue() as Error }

      // return the result of the verification
      return result
    }

    private func secKeyEncrypt(_ bytes: Array<UInt8>, usingVariant variant: SecKeyAlgorithm, withKey key: SecKey) throws -> Data {
      let pubKey = SecKeyCopyPublicKey(key)!

      var error: Unmanaged<CFError>?

      guard let encryptedData = SecKeyCreateEncryptedData(pubKey, variant, Data(bytes) as CFData, &error) else {
        throw NSError(domain: "Error Encrypting Data: \(error.debugDescription)", code: 0, userInfo: nil)
      }

      // Throw the error if we encountered one...
      if let error = error { throw error.takeRetainedValue() as Error }

      // return the result of the encryption
      return encryptedData as Data
    }

    private func secKeyDecrypt(_ bytes: Array<UInt8>, usingVariant variant: SecKeyAlgorithm, withKey key: SecKey) throws -> Data {
      var error: Unmanaged<CFError>?
      guard let decryptedData = SecKeyCreateDecryptedData(key, variant, Data(bytes) as CFData, &error) else {
        throw NSError(domain: "Error Decrypting Data: \(error.debugDescription)", code: 0, userInfo: nil)
      }
      return (decryptedData as Data).drop { $0 == 0x00 }
    }

    func testCreateTestFixture() throws {

      let keySize = 1056
      let messages = [
        "",
        "👋",
        "RSA Keys",
        "CryptoSwift RSA Keys!",
        "CryptoSwift RSA Keys are really cool! They support encrypting / decrypting messages, signing and verifying signed messages, and importing and exporting encrypted keys for use between sessions 🔐"
      ]
      print(messages.map { $0.bytes.count })

      /// Generate a SecKey RSA Key
      let parameters: [CFString: Any] = [
        kSecAttrKeyType: kSecAttrKeyTypeRSA,
        kSecAttrKeySizeInBits: keySize
      ]

      var error: Unmanaged<CFError>?

      // Generate the RSA SecKey
      guard let rsaSecKey = SecKeyCreateRandomKey(parameters as CFDictionary, &error) else {
        XCTFail("Key Generation Error: \(error.debugDescription)")
        return
      }

      // Extract the public key from the private RSA SecKey
      guard let rsaSecKeyPublic = SecKeyCopyPublicKey(rsaSecKey) else {
        XCTFail("Public Key Extraction Error")
        return
      }

      /// Lets grab the external representation of the public key
      var publicExternalRepError: Unmanaged<CFError>?
      guard let publicRSASecKeyRawRep = SecKeyCopyExternalRepresentation(rsaSecKeyPublic, &publicExternalRepError) as? Data else {
        XCTFail("Failed to copy external representation for RSA SecKey")
        return
      }

      /// Lets grab the external representation of the public key
      var privateExternalRepError: Unmanaged<CFError>?
      guard let privateRSASecKeyRawRep = SecKeyCopyExternalRepresentation(rsaSecKey, &privateExternalRepError) as? Data else {
        XCTFail("Failed to copy external representation for RSA SecKey")
        return
      }

      var template = FixtureTemplate2
      template = template.replacingOccurrences(of: "{{KEY_SIZE}}", with: "\(keySize)")
      template = template.replacingOccurrences(of: "{{PUBLIC_DER}}", with: "\(publicRSASecKeyRawRep.base64EncodedString())")
      template = template.replacingOccurrences(of: "{{PRIVATE_DER}}", with: "\(privateRSASecKeyRawRep.base64EncodedString())")

      var messageEntries: [String] = []
      for message in messages {
        var messageTemplate = MessageTemplate
        messageTemplate = messageTemplate.replacingOccurrences(of: "{{PLAINTEXT_MESSAGE}}", with: message)

        let encryptedMessages = try encrypt(data: message.data(using: .utf8)!, with: rsaSecKeyPublic)
        messageTemplate = messageTemplate.replacingOccurrences(of: "{{ENCRYPTED_MESSAGES}}", with: encryptedMessages.joined(separator: ",\n\t\t  "))

        let signedMessages = try sign(message: message.data(using: .utf8)!, using: rsaSecKey)
        messageTemplate = messageTemplate.replacingOccurrences(of: "{{SIGNED_MESSAGES}}", with: signedMessages.joined(separator: ",\n\t\t  "))

        messageEntries.append(messageTemplate)
      }

      template = template.replacingOccurrences(of: "{{MESSAGE_TEMPLATES}}", with: "\(messageEntries.joined(separator: ",\n\t"))")

      print(template)
    }
  }

  extension RSASecKeyTests {
    static func allTests() -> [(String, (RSASecKeyTests) -> () throws -> Void)] {
      let tests = [
        ("testRSAExternalRepresentationPrivate", testRSAExternalRepresentationPrivate),
        ("testRSAExternalRepresentationPublic", testRSAExternalRepresentationPublic),
        ("testSecKeyExternalRepresentationPrivate", testSecKeyExternalRepresentationPrivate),
        ("testSecKeyExternalRepresentationPublic", testSecKeyExternalRepresentationPublic)
      ]

      return tests
    }
  }

  private let FixtureTemplate = """
    static let RSA_{{KEY_SIZE}} = Fixture(
      keySize: {{KEY_SIZE}},
      publicDER: \"\"\"
  {{PUBLIC_DER}}
  \"\"\",
      privateDER: \"\"\"
  {{PRIVATE_DER}}
  \"\"\",
      rawMessage: [
        {{PLAINTEXT_MESSAGE}}
      ],
      encryptedMessage: [
        {{ENCRYPTED_MESSAGES}}
      ],
      signedMessages: [
        {{SIGNED_MESSAGES}}
      ]
    )
  """

  private let FixtureTemplate2 = """
    static let RSA_{{KEY_SIZE}} = Fixture(
      keySize: {{KEY_SIZE}},
      publicDER: \"\"\"
  {{PUBLIC_DER}}
  \"\"\",
      privateDER: \"\"\"
  {{PRIVATE_DER}}
  \"\"\",
      messages: [
        {{MESSAGE_TEMPLATES}}
      ]
    )
  """

  private let MessageTemplate = """
  "{{PLAINTEXT_MESSAGE}}": (
    encryptedMessage: [
      {{ENCRYPTED_MESSAGES}}
    ],
    signedMessage: [
      {{SIGNED_MESSAGES}}
    ]
  )
  """

  //encryptedMessage: [
//  "algid:encrypt:RSA:raw": "{{ENCRYPTED_RAW}}",
//  "algid:encrypt:RSA:PKCS1": "{{ENCRYPTED_PKCS1}}"
  //],
  //signedMessages: [
//  "algid:sign:RSA:raw"                    : "{{SIGNATURE_RAW}}",
//  "algid:sign:RSA:digest-PKCS1v15"        : "{{SIGNATURE_DIGEST_PKCS1v15}}",
//  "algid:sign:RSA:digest-PKCS1v15:SHA1"   : "{{SIGNATURE_DIGEST_PKCS1v15_SHA1}}",
//  "algid:sign:RSA:digest-PKCS1v15:SHA224" : "{{SIGNATURE_DIGEST_PKCS1v15_SHA224}}",
//  "algid:sign:RSA:digest-PKCS1v15:SHA256" : "{{SIGNATURE_DIGEST_PKCS1v15_SHA256}}",
//  "algid:sign:RSA:digest-PKCS1v15:SHA384" : "{{SIGNATURE_DIGEST_PKCS1v15_SHA384}}",
//  "algid:sign:RSA:digest-PKCS1v15:SHA512" : "{{SIGNATURE_DIGEST_PKCS1v15_SHA512}}",
//  "algid:sign:RSA:message-PKCS1v15:SHA1"  : "{{SIGNATURE_MESSAGE_PKCS1v15_SHA1}}",
//  "algid:sign:RSA:message-PKCS1v15:SHA224": "{{SIGNATURE_MESSAGE_PKCS1v15_SHA224}}",
//  "algid:sign:RSA:message-PKCS1v15:SHA256": "{{SIGNATURE_MESSAGE_PKCS1v15_SHA256}}",
//  "algid:sign:RSA:message-PKCS1v15:SHA384": "{{SIGNATURE_MESSAGE_PKCS1v15_SHA384}}",
//  "algid:sign:RSA:message-PKCS1v15:SHA512": "{{SIGNATURE_MESSAGE_PKCS1v15_SHA512}}"
  //]

  //private func printHexData16BytesWide(_ bytes:[UInt8]) {
//    print(bytes.toHexString().split(intoChunksOfLength: 32).map { $0.split(intoChunksOfLength: 2).map { "0x\($0.uppercased())" }.joined(separator: ", ") }.joined(separator: ",\n"))
  //}

  private func initSecKey(rawRepresentation unsafe: Data) throws -> SecKey {
    let attributes: [String: Any] = [
      kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
      kSecAttrKeyClass as String: kSecAttrKeyClassPrivate,
      kSecAttrKeySizeInBits as String: 1024,
      kSecAttrIsPermanent as String: false
    ]

    var error: Unmanaged<CFError>?
    guard let secKey = SecKeyCreateWithData(unsafe as CFData, attributes as CFDictionary, &error) else {
      throw NSError(domain: "Error constructing SecKey from raw key data: \(error.debugDescription)", code: 0, userInfo: nil)
    }

    return secKey
  }

  private func sign(message: Data, using key: SecKey) throws -> [String] {
    let algorithms: [SecKeyAlgorithm] = [
      .rsaSignatureRaw,
      //.rsaSignatureDigestPSSSHA1,
      //.rsaSignatureDigestPSSSHA224,
      //.rsaSignatureDigestPSSSHA256,
      //.rsaSignatureDigestPSSSHA384,
      //.rsaSignatureDigestPSSSHA512,
      .rsaSignatureDigestPKCS1v15Raw,
      .rsaSignatureDigestPKCS1v15SHA1,
      .rsaSignatureDigestPKCS1v15SHA224,
      .rsaSignatureDigestPKCS1v15SHA256,
      .rsaSignatureDigestPKCS1v15SHA384,
      .rsaSignatureDigestPKCS1v15SHA512,
      //.rsaSignatureMessagePSSSHA1,
      //.rsaSignatureMessagePSSSHA224,
      //.rsaSignatureMessagePSSSHA256,
      //.rsaSignatureMessagePSSSHA384,
      //.rsaSignatureMessagePSSSHA512,
      .rsaSignatureMessagePKCS1v15SHA1,
      .rsaSignatureMessagePKCS1v15SHA224,
      .rsaSignatureMessagePKCS1v15SHA256,
      .rsaSignatureMessagePKCS1v15SHA384,
      .rsaSignatureMessagePKCS1v15SHA512,
    ]

    var sigs: [String] = []

    for algo in algorithms {
      var error: Unmanaged<CFError>?

      // Sign the data
      guard let signature = SecKeyCreateSignature(
        key,
        algo,
        message as CFData,
        &error
      ) as Data?
      else {
        print("\"\(algo.rawValue)\": \"nil\",")
        sigs.append("\"\(algo.rawValue)\": \"\"")
        continue
      }

      // Throw the error if we encountered one
      if let error = error { print("\"\(algo.rawValue)\": \"\(error.takeRetainedValue())\","); continue }

      // Append the signature
      sigs.append("\"\(algo.rawValue)\": \"\(signature.base64EncodedString())\"")
    }

    return sigs
  }

  private func encrypt(data: Data, with key: SecKey) throws -> [String] {
    let algorithms: [SecKeyAlgorithm] = [
      .rsaEncryptionRaw,
      .rsaEncryptionPKCS1
    ]

    var encryptions: [String] = []

    for algo in algorithms {
      var error: Unmanaged<CFError>?
      guard let encryptedData = SecKeyCreateEncryptedData(key, algo, data as CFData, &error) as? Data else {
        print("\"\(algo.rawValue)\": \"\(error?.takeRetainedValue().localizedDescription ?? "nil")\",")
        encryptions.append("\"\(algo.rawValue)\": \"\"")
        continue
      }
      encryptions.append("\"\(algo.rawValue)\": \"\(encryptedData.base64EncodedString())\"")
    }

    return encryptions
  }

#endif
