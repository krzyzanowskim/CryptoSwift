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

import XCTest
@testable import CryptoSwift

final class ASN1Tests: XCTestCase {

  /// This test ensures that we get the same data out as we put in before and after encoding
  ///
  /// This test enforces that
  /// 1) The data provided to each of the `ASN1.Node`s is preserved across encoding and decoding.
  func testASN1NonDestructiveEncoding() throws {
    let arbitraryData = Data(hex: "0123456789")

    // Encode the serialized BigInteger
    let node: ASN1.Node = .sequence(nodes: [
      .integer(data: arbitraryData),
      .bitString(data: arbitraryData),
      .octetString(data: arbitraryData),
      .null,
      .objectIdentifier(data: arbitraryData)
    ])

    let encoded = ASN1.Encoder.encode(node)

    // Decode the Encoding
    let decoded = try ASN1.Decoder.decode(data: Data(encoded))
    guard case .sequence(let sequence) = decoded else {
      XCTFail("Failed to recover encoded SEQUENCE")
      return
    }

    XCTAssertEqual(sequence.count, 5)

    guard case .integer(let integerData) = sequence[0] else {
      XCTFail("Failed to recover encoded INTEGER")
      return
    }
    XCTAssertEqual(integerData, arbitraryData)

    guard case .bitString(let bitStringData) = sequence[1] else {
      XCTFail("Failed to recover encoded BITSTRING")
      return
    }
    XCTAssertEqual(bitStringData, arbitraryData)

    guard case .octetString(let octetData) = sequence[2] else {
      XCTFail("Failed to recover encoded OCTETSTRING")
      return
    }
    XCTAssertEqual(octetData, arbitraryData)

    guard case .null = sequence[3] else {
      XCTFail("Failed to recover encoded NULL")
      return
    }

    guard case .objectIdentifier(let objIDData) = sequence[4] else {
      XCTFail("Failed to recover encoded OBJECTIDENTIFIER")
      return
    }
    XCTAssertEqual(objIDData, arbitraryData)
  }

  /// The ASN1 Encoder / Decoder doesn't handle encoding / decoding Integers directly, it's your responsibility to accurately serialize your integers.
  /// - Note: In this example we're using BigInteger's serialization technique to encode / decode Integers, which isn't the default method for handling integers. https://www.strozhevsky.com/free_docs/asn1_by_simple_words.pdf
  ///
  /// This test enforces that
  /// 1) The data provided to the `ASN1.Node.integer` Node is preserved across encoding and decoding.
  func testASN1DecodePrimitiveInteger() throws {
    let tests = [
      0,
      -0,
      128,
      -128,
      136,
      -136,
      8388607,
      -8388607,
      3409934108352718734,
      -3409934108352718734
    ]

    for test in tests {
      let number = BigInteger(test)

      // Encode the serialized Integer
      let encoded = ASN1.Encoder.encode(.integer(data: number.serialize()))

      // Ensure the Integer Prefix was added
      XCTAssertEqual(Array<UInt8>(arrayLiteral: 0x02), Array(encoded.prefix(1)))

      // Decode the Encoding
      let decoded = try ASN1.Decoder.decode(data: Data(encoded))
      guard case .integer(let num) = decoded else {
        XCTFail("Failed to recover encoded integer")
        return
      }

      // Ensure the original BigInteger was recovered
      XCTAssertEqual(BigInteger(num), number)
    }
  }

  /// Another test showing that Integers are stored as arbitrary data and the proper serialization and signage are the responsibilities of the user and their application.
  ///
  /// This test enforces that
  /// 1) The data provided to the `ASN1.Node.integer` Node is preserved across encoding and decoding.
  func testASN1DecodeLargeBigInteger() throws {
    // Because INTEGERS are stored as arbitrary data we should be able to store an integer that would otherwise overflow by using the BigInteger library
    let largeBigInt = BigInteger("1541235134652345698374107823450134507610354876134950342785028743653")

    // Encode the serialized BigInteger
    let encoded = ASN1.Encoder.encode(.integer(data: largeBigInt.serialize()))

    // Decode the Encoding
    let decoded = try ASN1.Decoder.decode(data: Data(encoded))
    guard case .integer(let num) = decoded else {
      XCTFail("Failed to recover encoded integer")
      return
    }

    // Ensure the original BigInteger was recovered
    XCTAssertEqual(BigInteger(num), largeBigInt)
  }

  /// This tests decodes an RSA Public Key from a Base64 DER Encoded representation
  ///
  /// This test enforces that
  /// 1) The decoding process yeilds the expected format.
  /// 2) The re-encoding of the data yeilds the exact same starting data.
  func testANS1DERDecodingPublicKey() throws {
    /// An example of an RSA Public Key ASN1 DER Encoding
    ///
    /// [IETF Spec RFC2313](https://datatracker.ietf.org/doc/html/rfc2313#section-7.1)
    /// ```
    /// =========================
    ///  RSA PublicKey Structure
    /// =========================
    ///
    /// RSAPublicKey ::= SEQUENCE {
    ///   modulus           INTEGER,  -- n
    ///   publicExponent    INTEGER,  -- e
    /// }
    /// ```
    let publicDER = """
    MIGJAoGBAMGeZvIG84vyKAATwKkKz2g+PeNaZ63rxk/zEnLGxkMCVKnUZ6jPAtzYOKM24949yIhfxYBC/bOCPwRK4wbr4YyIx3WB2v+Zcqe8pRM/BThUpNIx3K2+jbJBhAopf1GXJ3i31RuiLMh9HWhxzkVamz1KnDjCuTZguCRRHIv+r3XTAgMBAAE=
    """

    guard let publicDERData = Data(base64Encoded: publicDER) else {
      XCTFail("Failed to convert base64 string into data for decoding.")
      return
    }

    let decoded = try ASN1.Decoder.decode(data: publicDERData)

    // Ensure the first node is of type Sequence
    guard case .sequence(let nodes) = decoded else {
      XCTFail("Expected the top level node to be a sequence and it wasn't")
      return
    }

    // Ensure there are two nodes within the top level sequence (our integers, n and e)
    XCTAssertEqual(nodes.count, 2)

    // Ensure that the first node within our sequence is of type Integer
    guard case .integer(let n) = nodes[0] else {
      XCTFail("Expected an integer within our sequence and it wasn't")
      return
    }

    // Ensure the second node within our sequence is of type Integer
    guard case .integer(let e) = nodes[1] else {
      XCTFail("Expected an integer within our sequence and it wasn't")
      return
    }

    // Ensure that n contains the data we expected
    XCTAssertEqual(n.toHexString(), "00c19e66f206f38bf2280013c0a90acf683e3de35a67adebc64ff31272c6c6430254a9d467a8cf02dcd838a336e3de3dc8885fc58042fdb3823f044ae306ebe18c88c77581daff9972a7bca5133f053854a4d231dcadbe8db241840a297f51972778b7d51ba22cc87d1d6871ce455a9b3d4a9c38c2b93660b824511c8bfeaf75d3")

    // Ensure that e contains the data we expected
    XCTAssertEqual(e.toHexString(), "010001") // 65537

    // Re Encode the data
    let asn1: ASN1.Node = .sequence(nodes: [
      .integer(data: n),
      .integer(data: e)
    ])

    let encoded = ASN1.Encoder.encode(asn1)

    // Ensure the re-encoded data matches the original exactly
    XCTAssertEqual(Data(encoded), publicDERData)
    XCTAssertEqual(encoded, publicDERData.bytes)
    XCTAssertEqual(encoded.toBase64(), publicDER)
  }

  /// This tests decodes an RSA Private Key from a Base64 DER Encoded representation
  ///
  /// This test enforces that
  /// 1) The decoding process yeilds the expected format.
  /// 2) The re-encoding of the data yeilds the exact same starting data.
  func testANS1DERDecodingPrivateKey() throws {
    /// An example of an RSA Private Key ASN1 DER Encoding
    ///
    /// [IETF Spec RFC2313](https://datatracker.ietf.org/doc/html/rfc2313#section-7.2)
    /// ```
    /// ==========================
    ///  RSA PrivateKey Structure
    /// ==========================
    ///
    /// RSAPrivateKey ::= SEQUENCE {
    ///   version           Version,
    ///   modulus           INTEGER,  -- n
    ///   publicExponent    INTEGER,  -- e
    ///   privateExponent   INTEGER,  -- d
    ///   prime1            INTEGER,  -- p
    ///   prime2            INTEGER,  -- q
    ///   exponent1         INTEGER,  -- d mod (p-1)
    ///   exponent2         INTEGER,  -- d mod (q-1)
    ///   coefficient       INTEGER,  -- (inverse of q) mod p
    ///   otherPrimeInfos   OtherPrimeInfos OPTIONAL
    /// }
    /// ```
    let privateDER = """
    MIICXQIBAAKBgQDBnmbyBvOL8igAE8CpCs9oPj3jWmet68ZP8xJyxsZDAlSp1GeozwLc2DijNuPePciIX8WAQv2zgj8ESuMG6+GMiMd1gdr/mXKnvKUTPwU4VKTSMdytvo2yQYQKKX9Rlyd4t9UboizIfR1occ5FWps9Spw4wrk2YLgkURyL/q910wIDAQABAoGAGJkNLxZe/pqHJmtcAJ3U98NgjW/A2EGp8iJJZ7eFHKJBK0pG2RVjobb+iw3AKU3kGh9AsijQnmufoeX5rblt7/ojgpfVhS7NHsKCi8Nx7U92bNnP0RP4mogpvzGWVknUdv6jW7dX83FKgEywbNKa5CPQk1XinqXL33gNjWdOh/ECQQDjdE4kNdVwKA59ddWRShvJiOMOG8+TjE5HvcZzKQ+UMlBwbknL5tIJE7KnN9ZEfNihVmyrMAzJAfe2PCyZAip/AkEA2esFkG+ScgeVYlGrUqrqUkvzj1j6F8R+8rGvCjq2WnDL8TzO7NoT7qivW/+6E9osX1WwWAtj/84eN7dvLLxCrQJBAN7GomZq58MzKIYPLH9iI3cwAJtn99ZfHKi9oipW9DBFW23TR6pTSDKlvVx0nwNzeEYFPOgqZstVhwZRR6kRawcCQHx/u0QTmjUvg/cR9bFbGFhAMDxbdzaQ+n4paXmMpZXyD3IZbZb/2JdnJBiJd4PUB7nHuOH0UANbfQQT9p42SFkCQQCcdFRTZEZv5TjmcUn0GBUzRmnswiRc1YEg81DSDlvD3dEIVSl6PLkzcNNItrgD5SfC5MxCv6PIUlJVhnkavEjS
    """

    guard let privateDERData = Data(base64Encoded: privateDER) else {
      XCTFail("Failed to convert base64 string into data for decoding.")
      return
    }

    let decoded = try ASN1.Decoder.decode(data: privateDERData)

    // Ensure the first Node is of type SEQUENCE
    guard case .sequence(let nodes) = decoded else {
      XCTFail("Expected the top level node to be a sequence and it wasn't")
      return
    }

    // Ensure there are nine (9) Nodes within the top level SEQUENCE
    XCTAssertEqual(nodes.count, 9)

    // Deconstruct the parameters
    guard case .integer(let version) = nodes[0] else {
      XCTFail("Expected an integer within our sequence and it wasn't")
      return
    }
    XCTAssertEqual(version, Data(hex: "00"))

    guard case .integer(let n) = nodes[1] else {
      XCTFail("Expected an integer within our sequence and it wasn't")
      return
    }
    XCTAssertEqual(n, Data(hex: "00c19e66f206f38bf2280013c0a90acf683e3de35a67adebc64ff31272c6c6430254a9d467a8cf02dcd838a336e3de3dc8885fc58042fdb3823f044ae306ebe18c88c77581daff9972a7bca5133f053854a4d231dcadbe8db241840a297f51972778b7d51ba22cc87d1d6871ce455a9b3d4a9c38c2b93660b824511c8bfeaf75d3"))

    guard case .integer(let e) = nodes[2] else {
      XCTFail("Expected an integer within our sequence and it wasn't")
      return
    }
    XCTAssertEqual(e, Data(hex: "010001"))

    guard case .integer(let d) = nodes[3] else {
      XCTFail("Expected an integer within our sequence and it wasn't")
      return
    }
    XCTAssertEqual(d, Data(hex: "18990d2f165efe9a87266b5c009dd4f7c3608d6fc0d841a9f2224967b7851ca2412b4a46d91563a1b6fe8b0dc0294de41a1f40b228d09e6b9fa1e5f9adb96deffa238297d5852ecd1ec2828bc371ed4f766cd9cfd113f89a8829bf31965649d476fea35bb757f3714a804cb06cd29ae423d09355e29ea5cbdf780d8d674e87f1"))

    guard case .integer(let p) = nodes[4] else {
      XCTFail("Expected an integer within our sequence and it wasn't")
      return
    }
    XCTAssertEqual(p, Data(hex: "00e3744e2435d570280e7d75d5914a1bc988e30e1bcf938c4e47bdc673290f943250706e49cbe6d20913b2a737d6447cd8a1566cab300cc901f7b63c2c99022a7f"))

    guard case .integer(let q) = nodes[5] else {
      XCTFail("Expected an integer within our sequence and it wasn't")
      return
    }
    XCTAssertEqual(q, Data(hex: "00d9eb05906f927207956251ab52aaea524bf38f58fa17c47ef2b1af0a3ab65a70cbf13cceecda13eea8af5bffba13da2c5f55b0580b63ffce1e37b76f2cbc42ad"))

    guard case .integer(let exp1) = nodes[6] else {
      XCTFail("Expected an integer within our sequence and it wasn't")
      return
    }
    XCTAssertEqual(exp1, Data(hex: "00dec6a2666ae7c33328860f2c7f62237730009b67f7d65f1ca8bda22a56f430455b6dd347aa534832a5bd5c749f03737846053ce82a66cb5587065147a9116b07"))

    guard case .integer(let exp2) = nodes[7] else {
      XCTFail("Expected an integer within our sequence and it wasn't")
      return
    }
    XCTAssertEqual(exp2, Data(hex: "7c7fbb44139a352f83f711f5b15b185840303c5b773690fa7e2969798ca595f20f72196d96ffd897672418897783d407b9c7b8e1f450035b7d0413f69e364859"))

    guard case .integer(let coefficient) = nodes[8] else {
      XCTFail("Expected an integer within our sequence and it wasn't")
      return
    }
    XCTAssertEqual(coefficient, Data(hex: "009c74545364466fe538e67149f41815334669ecc2245cd58120f350d20e5bc3ddd10855297a3cb93370d348b6b803e527c2e4cc42bfa3c852525586791abc48d2"))

    // Ensure re-encoding the data yeilds the exact same starting data
    let asn: ASN1.Node = .sequence(nodes: [
      .integer(data: version),
      .integer(data: n),
      .integer(data: e),
      .integer(data: d),
      .integer(data: p),
      .integer(data: q),
      .integer(data: exp1),
      .integer(data: exp2),
      .integer(data: coefficient)
    ])

    // Encode the ASN1 Nodes
    let encodedData = ASN1.Encoder.encode(asn)

    // Ensure the re-encoded data matches the original data exactly
    XCTAssertEqual(Data(encodedData), privateDERData)
    XCTAssertEqual(encodedData, privateDERData.bytes)
    XCTAssertEqual(encodedData.toBase64(), privateDER.replacingOccurrences(of: "\n", with: ""))
  }

  /// This tests decodes an Encrypted RSA Private Key from a Base64 PEM Encoded representation
  ///
  /// This test enforces that
  /// 1) The decoding process yeilds the expected format.
  /// 2) The re-encoding of the data yeilds the exact same starting data.
  func testASN1DecodingEncryptedPEM() throws {
    /// ==========================
    ///  Encrypted PEM Structure
    /// ==========================
    ///
    /// EncryptedPrivateKey ::= SEQUENCE {
    ///
    ///   PEMStructure ::= SEQUENCE {
    ///     pemObjID  OBJECTIDENTIFIER
    ///
    ///     EncryptionAlgorithms ::= SEQUENCE {
    ///
    ///       PBKDFAlgorithms ::= SEQUENCE {
    ///         pbkdfObjID  OBJECTIDENTIFIER
    ///         PBKDFParams ::= SEQUENCE {
    ///           salt OCTETSTRING,
    ///           iterations INTEGER
    ///         }
    ///       },
    ///
    ///       CIPHERAlgorithms ::= SEQUENCE {
    ///         cipherObjID  OBJECTIDENTIFIER,
    ///         iv           OCTETSTRING
    ///       }
    ///     }
    ///   }
    ///   encryptedData OCTETSTRING
    /// }
    ///
    /// /*
    ///  * Generated with
    ///  * openssl genpkey -algorithm RSA
    ///  *   -pkeyopt rsa_keygen_bits:1024
    ///  *   -pkeyopt rsa_keygen_pubexp:65537
    ///  *   -out foo.pem
    ///  * openssl pkcs8 -in foo.pem -topk8 -v2 aes-128-cbc -passout pass:mypassword
    ///  */
    let encryptedPEMFormat = """
    MIICzzBJBgkqhkiG9w0BBQ0wPDAbBgkqhkiG9w0BBQwwDgQIP5QK2RfqUl4CAggA
    MB0GCWCGSAFlAwQBAgQQj3OyM9gnW2dd/eRHkxjGrgSCAoCpM5GZB0v27cxzZsGc
    O4/xqgwB0c/bSJ6QogtYU2KVoc7ZNQ5q9jtzn3I4ONvneOkpm9arzYz0FWnJi2C3
    BPiF0D1NkfvjvMLv56bwiG2A1oBECacyAb2pXYeJY7SdtYKvcbgs3jx65uCm6TF2
    BylteH+n1ewTQN9DLfASp1n81Ajq9lQGaK03SN2MUtcAPp7N9gnxJrlmDGeqlPRs
    KpQYRcot+kE6Ew8a5jAr7mAxwpqvr3SM4dMvADZmRQsM4Uc/9+YMUdI52DG87EWc
    0OUB+fnQ8jw4DZgOE9KKM5/QTWc3aEw/dzXr/YJsrv01oLazhqVHnEMG0Nfr0+DP
    q+qac1AsCsOb71VxaRlRZcVEkEfAq3gidSPD93qmlDrCnmLYTilcLanXUepda7ez
    qhjkHtpwBLN5xRZxOn3oUuLGjk8VRwfmFX+RIMYCyihjdmbEDYpNUVkQVYFGi/F/
    1hxOyl9yhGdL0hb9pKHH10GGIgoqo4jSTLlb4ennihGMHCjehAjLdx/GKJkOWShy
    V9hj8rAuYnRNb+tUW7ChXm1nLq14x9x1tX0ciVVn3ap/NoMkbFTr8M3pJ4bQlpAn
    wCT2erYqwQtgSpOJcrFeph9TjIrNRVE7Zlmr7vayJrB/8/oPssVdhf82TXkna4fB
    PcmO0YWLa117rfdeNM/Duy0ThSdTl39Qd+4FxqRZiHjbt+l0iSa/nOjTv1TZ/QqF
    wqrO6EtcM45fbFJ1Y79o2ptC2D6MB4HKJq9WCt064/8zQCVx3XPbb3X8Z5o/6koy
    ePGbz+UtSb9xczvqpRCOiFLh2MG1dUgWuHazjOtUcVWvilKnkjCMzZ9s1qG0sUDj
    nPyn
    """

    guard let pemData = Data(base64Encoded: encryptedPEMFormat.replacingOccurrences(of: "\n", with: "")) else {
      XCTFail("Failed to convert base64 string to data")
      return
    }

    let asn = try ASN1.Decoder.decode(data: pemData)

    // Ensure the first node is a Sequence
    guard case .sequence(let encryptedPEMWrapper) = asn else {
      XCTFail("Expected top level Node to be a SEQUENCE object")
      return
    }
    // Ensure the first Sequence contains exactly 2 nodes (another Sequence and our OctetString of encrypted data)
    XCTAssertEqual(encryptedPEMWrapper.count, 2)

    // Ensure the first node within the top level sequence is another sequence
    guard case .sequence(let encryptionInfoWrapper) = encryptedPEMWrapper[0] else {
      XCTFail("Expected the first Node within our top level SEQUENCE to be a SEQUENCE object and it wasn't")
      return
    }
    // Ensure this sequence contains exactly two nodes (the PEMs ObjectIdentifier and another sequence that houses the encryption algorithms)
    XCTAssertEqual(encryptionInfoWrapper.count, 2)

    // Ensure the first Node is the PEM's OBJECTIDENTIFIER Node
    guard case .objectIdentifier(let pemObjID) = encryptionInfoWrapper[0] else {
      XCTFail("Expected an OBJECTIDENTIFIER and it wasn't")
      return
    }

    // Ensure the second Node is another SEQUENCE Node
    guard case .sequence(let encryptionAlgorithmsWrapper) = encryptionInfoWrapper[1] else {
      XCTFail("Expected another SEQUENCE Node and it wasn't")
      return
    }
    // Ensure this sequence contains exactly two nodes (the PEMs ObjectIdentifier and another sequence that houses the encryption algorithms)
    XCTAssertEqual(encryptionAlgorithmsWrapper.count, 2)

    // Ensure the first Node is another SEQUENCE Node
    guard case .sequence(let pbkdfAlgorithmWrapper) = encryptionAlgorithmsWrapper[0] else {
      XCTFail("Expected another SEQUENCE Node and it wasn't")
      return
    }
    // Ensure this sequence contains exactly two nodes (the PBKDF ObjectIdentifier and another sequence that houses the PBKDF params)
    XCTAssertEqual(pbkdfAlgorithmWrapper.count, 2)

    guard case .objectIdentifier(let pbkdfObjID) = pbkdfAlgorithmWrapper[0] else {
      XCTFail("Expected an OBJECTIDENTIFIER and it wasn't")
      return
    }
    guard case .sequence(let pbkdfParamsWrapper) = pbkdfAlgorithmWrapper[1] else {
      XCTFail("Expected an OCTETSTRING and it wasn't")
      return
    }
    // Ensure this sequence contains exactly two nodes (the PBKDF Salt as an OCTETSTRING and the PBKDF Iterations as an INTEGER)
    XCTAssertEqual(pbkdfParamsWrapper.count, 2)
    guard case .octetString(let pbkdfSalt) = pbkdfParamsWrapper[0] else {
      XCTFail("Expected an OCTETSTRING and it wasn't")
      return
    }
    guard case .integer(let pbkdfIterations) = pbkdfParamsWrapper[1] else {
      XCTFail("Expected an INTEGER and it wasn't")
      return
    }

    // Ensure the second Node is another SEQUENCE Node
    guard case .sequence(let cipherAlgorithmWrapper) = encryptionAlgorithmsWrapper[1] else {
      XCTFail("Expected another SEQUENCE Node and it wasn't")
      return
    }
    // Ensure this sequence contains exactly two nodes (the CIPHER ObjectIdentifier and an OCTETSTRING that contains the CIPHERs InitialVector)
    XCTAssertEqual(cipherAlgorithmWrapper.count, 2)

    guard case .objectIdentifier(let cipherObjID) = cipherAlgorithmWrapper[0] else {
      XCTFail("Expected an OBJECTIDENTIFIER and it wasn't")
      return
    }
    guard case .octetString(let cipherInitialVector) = cipherAlgorithmWrapper[1] else {
      XCTFail("Expected an OCTETSTRING and it wasn't")
      return
    }

    // Ensure the last (2nd) Node in the top level SEQUENCE Node is an OCTETSTRING that contains the encrypted key data
    guard case .octetString(let encryptedData) = encryptedPEMWrapper[1] else {
      XCTFail("Expected the last Node in the first SEQUENCE Node to be an OCTETSTRING and it wasn't")
      return
    }

    // Now lets ensure we can re encode the object and get back the exact same data
    let nodes: ASN1.Node = .sequence(nodes: [
      .sequence(nodes: [
        .objectIdentifier(data: pemObjID),
        .sequence(nodes: [
          .sequence(nodes: [
            .objectIdentifier(data: pbkdfObjID),
            .sequence(nodes: [
              .octetString(data: pbkdfSalt),
              .integer(data: pbkdfIterations)
            ])
          ]),
          .sequence(nodes: [
            .objectIdentifier(data: cipherObjID),
            .octetString(data: cipherInitialVector)
          ])
        ])
      ]),
      .octetString(data: encryptedData)
    ])

    // Encode the ASN1 Nodes
    let encodedData = ASN1.Encoder.encode(nodes)

    // Ensure the re-encoded data matches the original data exactly
    XCTAssertEqual(Data(encodedData), pemData)
    XCTAssertEqual(encodedData, pemData.bytes)
    XCTAssertEqual(encodedData.toBase64(), encryptedPEMFormat.replacingOccurrences(of: "\n", with: ""))
  }

  static let allTests = [
    ("testASN1NonDestructiveEncoding", testASN1NonDestructiveEncoding),
    ("testASN1DecodePrimitiveInteger", testASN1DecodePrimitiveInteger),
    ("testASN1DecodeLargeBigInteger", testASN1DecodeLargeBigInteger),
    ("testANS1DERDecodingPublicKey", testANS1DERDecodingPublicKey),
    ("testANS1DERDecodingPrivateKey", testANS1DERDecodingPrivateKey),
    ("testASN1DecodingEncryptedPEM", testASN1DecodingEncryptedPEM)
  ]
}
