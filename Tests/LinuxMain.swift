import XCTest
@testable import CryptoSwiftTests

XCTMain([
    testCase(DigestTests.allTests()),
    testCase(Poly1305Tests.allTests),
    testCase(HMACTests.allTests),
    testCase(AESTests.allTests()),
    testCase(BlowfishTests.allTests()),
    testCase(ChaCha20Tests.allTests()),
    testCase(RabbitTests.allTests()),
    testCase(ExtensionsTest.allTests()),
    testCase(PaddingTests.allTests),
    testCase(PBKDF.allTests()),
    testCase(RandomBytesSequenceTests.allTests),
    testCase(Access.allTests),
])
