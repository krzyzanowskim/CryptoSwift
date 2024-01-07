////  CryptoSwift
//
//  Copyright (C) 2014-2023 Marcin Krzyżanowski <marcin@krzyzanowskim.com>
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
import XCTest
@testable import CryptoSwift

final class SignatureVerificationTests: XCTestCase {
    
  func testVerifySHA3Variants() {
      let testVectors: [SignatureVerificationTests.TestVector] = [
        SignatureVerificationTests.testVectorMessage_pkcs1v15_SHA3_256,
        SignatureVerificationTests.testVectorMessage_pkcs1v15_SHA3_384,
        SignatureVerificationTests.testVectorMessage_pkcs1v15_SHA3_512,
        SignatureVerificationTests.testVectorDigest_pkcs1v15_SHA3_256,
        SignatureVerificationTests.testVectorDigest_pkcs1v15_SHA3_384,
        SignatureVerificationTests.testVectorDigest_pkcs1v15_SHA3_512
      ]
      
    for testVector in testVectors {
      do {
        guard
          let publicDerData = Data(base64Encoded: testVector.publicDER)
        else {
          XCTFail("Corrupted data - publicDER")
          continue
        }
        
        let rsa = try RSA(publicDER: publicDerData.bytes)
        
        guard
          let signedMessageData = Data(base64Encoded: testVector.signedMessage)
        else {
          XCTFail("Corrupted data - signedMessage")
          continue
        }
        
        let result = try rsa.verify(signature: signedMessageData.bytes,
                                    for: testVector.originalMessage.bytes,
                                    variant: testVector.variant)
        XCTAssertTrue(result, "Verification failed for test vector with id `\(testVector.id)`")
        
      } catch let error {
        XCTFail("Failed with error \(error)")
      }
    }
  }

}

extension SignatureVerificationTests {
  struct TestVector {
    
    /// String to identify test vector. Used for logging purposes
    let id: String
    /// Public DER for RSA key
    let publicDER: String
    /// RSA signature variant
    let variant: RSA.SignatureVariant
    /// Original message that was signed
    let originalMessage: String
    /// Signed message
    let signedMessage: String
  }
  
  static let testVectorMessage_pkcs1v15_SHA3_256 = TestVector(
    id: "1",
    publicDER: "MIGJAoGBAJPTOQB0cqHPbrZO8Bnl77uFR8jgcYWmudETdRP57lCn/Q4v4Ga9OTqTkfbzX7DKq4WrrcPkx6/u4U4EVS6y7jyuq3Qn4VZMQPKiMiqRyRKhNKfC0i8SpMEhnIXGl824bi/YfV6arz0gicl24dP8C+HsO+WJGa7gtRs2d8hY2s+NAgMBAAE=",
    variant: .message_pkcs1v15_SHA3_256,
    originalMessage: "CryptoSwift Test",
    signedMessage: "IOIA/8NgoLVwtfto5Lnea7GLBXMddCAgQFBt38HVJpbEtuEcmu8uFs4sJuAHalH1iIe/cGPrwASRM94fSDKzuQ7XNX2Dwt8DBzu9BlAtEWq9GUSL/6DED0xJfqrl6G5rh+RRk9YYIk3TeI9H4HzsmIDFjp5hxFu0SedoR5DzEVM="
  )
  
  static let testVectorMessage_pkcs1v15_SHA3_384 = TestVector(
    id: "2",
    publicDER: "MIGJAoGBAJPTOQB0cqHPbrZO8Bnl77uFR8jgcYWmudETdRP57lCn/Q4v4Ga9OTqTkfbzX7DKq4WrrcPkx6/u4U4EVS6y7jyuq3Qn4VZMQPKiMiqRyRKhNKfC0i8SpMEhnIXGl824bi/YfV6arz0gicl24dP8C+HsO+WJGa7gtRs2d8hY2s+NAgMBAAE=",
    variant: .message_pkcs1v15_SHA3_384,
    originalMessage: "CryptoSwift Test",
    signedMessage: "J1qAdFj7iwlW6Mhyf5MfG2CN7BeUjKCFeCunBs2Hginwpcz/YfJgzNpGA93T+RBR4kLVuhs3OVILhwaMnTbgsMVNz0xLoZ5oegRADXDT1Ln3WuTUuqQH+RiMSILelgaHsU4fjj7jCC8wLFA2DtYm7aje1HF3ZRc/9SQSTREM5Gw="
  )
  
  static let testVectorMessage_pkcs1v15_SHA3_512 = TestVector(
    id: "3",
    publicDER: "MIGJAoGBAJPTOQB0cqHPbrZO8Bnl77uFR8jgcYWmudETdRP57lCn/Q4v4Ga9OTqTkfbzX7DKq4WrrcPkx6/u4U4EVS6y7jyuq3Qn4VZMQPKiMiqRyRKhNKfC0i8SpMEhnIXGl824bi/YfV6arz0gicl24dP8C+HsO+WJGa7gtRs2d8hY2s+NAgMBAAE=",
    variant: .message_pkcs1v15_SHA3_512,
    originalMessage: "CryptoSwift Test",
    signedMessage: "KMmRIptAPCZV7I/6gRN6wUQekRm+sxXWtoAyxC7PPiSBNd9XJTVVrEUnEfpnupI6uum+r9YxAT5Ha0S5XrYlojHZFLW3gZHLAKmRBushg8YRfqK68cDLYBshuqBlf5nuQZDU+7LTBh6Jnup2rGbQj1Bra9X9Hl9uZmoPY8Uoh/g="
  )
  
  static let testVectorDigest_pkcs1v15_SHA3_256 = TestVector(
    id: "4",
    publicDER: "MIGJAoGBAJPTOQB0cqHPbrZO8Bnl77uFR8jgcYWmudETdRP57lCn/Q4v4Ga9OTqTkfbzX7DKq4WrrcPkx6/u4U4EVS6y7jyuq3Qn4VZMQPKiMiqRyRKhNKfC0i8SpMEhnIXGl824bi/YfV6arz0gicl24dP8C+HsO+WJGa7gtRs2d8hY2s+NAgMBAAE=",
    variant: .digest_pkcs1v15_SHA3_256,
    originalMessage: "CryptoSwift Test",
    signedMessage: "Oj3CBwMQIEGrQwFuqIXklqOJG6pdaS5Kjal+sAKoMvEzXCB0h8K8w9YNt/XIOD9fJXdUaG0XR6RB8eEQxh/u6pYZPVUwssyA//FUjWLgKOecNkaca+EK98iIkivjVdEGK7yVhcQHJF19EfpZahVWWlEUCT02g8niomkWUHWIlo8="
  )
  
  static let testVectorDigest_pkcs1v15_SHA3_384 = TestVector(
    id: "5",
    publicDER: "MIGJAoGBAJPTOQB0cqHPbrZO8Bnl77uFR8jgcYWmudETdRP57lCn/Q4v4Ga9OTqTkfbzX7DKq4WrrcPkx6/u4U4EVS6y7jyuq3Qn4VZMQPKiMiqRyRKhNKfC0i8SpMEhnIXGl824bi/YfV6arz0gicl24dP8C+HsO+WJGa7gtRs2d8hY2s+NAgMBAAE=",
    variant: .digest_pkcs1v15_SHA3_384,
    originalMessage: "CryptoSwift Test",
    signedMessage: "ZCn19KmnT/QdzcNm077uopZeIxkR5EECX0po2QypPTYorYa9dGTm3nKR0mMr/G2C7ukrR2a8j5WPf4hXi1rlzOoFNufpbyQB33I9INleN7FjASmoxFcw6TyFNeMPN+TwKj9MVTEkZ7HtPL0bBsD8E08eRCDwk3UYdUjcvZcOdzw="
  )
  
  static let testVectorDigest_pkcs1v15_SHA3_512 = TestVector(
    id: "6",
    publicDER: "MIGJAoGBAJPTOQB0cqHPbrZO8Bnl77uFR8jgcYWmudETdRP57lCn/Q4v4Ga9OTqTkfbzX7DKq4WrrcPkx6/u4U4EVS6y7jyuq3Qn4VZMQPKiMiqRyRKhNKfC0i8SpMEhnIXGl824bi/YfV6arz0gicl24dP8C+HsO+WJGa7gtRs2d8hY2s+NAgMBAAE=",
    variant: .digest_pkcs1v15_SHA3_512,
    originalMessage: "CryptoSwift Test",
    signedMessage: "bk1/rtzt64ZApavxPrUEnsG/tN7nN6ITV3NKY0IR1i/3S4bkxIMulRsBPINpksTAafxrSm6EsLAmOPrqjwGycqRjSRi8/S6roUE/TIno2dGfO5e4eVKCQtD6I+CHA0Xji3X1k627vaYZqpTMFuMk8serfjMTHFe46s6S+f/64as="
  )
}
