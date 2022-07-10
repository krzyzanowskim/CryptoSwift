//
//  CryptoSwift
//
//  Copyright (C) 2014-2021 Marcin Krzyżanowski <marcin@krzyzanowskim.com>
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

#if canImport(Security)

  import Security
  import XCTest
  @testable import CryptoSwift

  final class RSASecKeyTests: XCTestCase {

    // MARK: SecKey <-> RSA Interoperability

    /// From RSA -> External Representation -> SecKey
    func testRSAExternalRepresentationPrivate() throws {

      /// Generate a CryptoSwift RSA Key
      let rsaCryptoSwift = try RSA(keySize: 1024)

      /// Get the key's rawExternalRepresentation
      let rsaCryptoSwiftRawRep = try rsaCryptoSwift.privateKeyDER()

      /// We should be able to instantiate an RSA SecKey from this data
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

      /// Get the SecKey's external representation
      var externalRepError: Unmanaged<CFError>?
      guard let rsaSecKeyRawRep = SecKeyCopyExternalRepresentation(rsaSecKey, &externalRepError) as? Data else {
        XCTFail("Failed to copy external representation for RSA SecKey")
        return
      }

      // Ensure both the CryptoSwift Ext Rep and the SecKey Ext Rep match
      XCTAssertEqual(rsaSecKeyRawRep, Data(rsaCryptoSwiftRawRep))
      XCTAssertEqual(rsaSecKeyRawRep, try rsaCryptoSwift.externalRepresentation())
    }

    /// From RSA -> External Representation -> SecKey
    func testRSAExternalRepresentationPublic() throws {

      /// Generate a CryptoSwift RSA Key
      let rsaCryptoSwift = try RSA(keySize: 1024)

      /// Get the key's rawExternalRepresentation
      let rsaCryptoSwiftRawRep = try rsaCryptoSwift.publicKeyDER()

      /// We should be able to instantiate an RSA SecKey from this data
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

      /// Get the SecKey's external representation
      var externalRepError: Unmanaged<CFError>?
      guard let rsaSecKeyRawRep = SecKeyCopyExternalRepresentation(rsaSecKey, &externalRepError) as? Data else {
        XCTFail("Failed to copy external representation for RSA SecKey")
        return
      }

      // Ensure both the CryptoSwift Ext Rep and the SecKey Ext Rep match
      XCTAssertEqual(rsaSecKeyRawRep, Data(rsaCryptoSwiftRawRep))
      XCTAssertEqual(rsaSecKeyRawRep, try rsaCryptoSwift.publicKeyExternalRepresentation())
    }

    /// SecKey -> External Representation -> CryptoSwift RSA
    func testSecKeyExternalRepresentationPrivate() throws {
      /// Generate a SecKey RSA Key
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

      /// Lets grab the external representation
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

    /// SecKey -> External Representation -> CryptoSwift RSA
    func testSecKeyExternalRepresentationPublic() throws {
      /// Generate a SecKey RSA Key
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

      /// Lets grab the external representation of the public key
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

#endif
