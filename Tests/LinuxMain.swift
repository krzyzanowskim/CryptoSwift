@testable import Tests
@testable import TestsPerformance
import XCTest

var tests = [
    testCase(DigestTests.allTests()),
    testCase(Poly1305Tests.allTests),
    testCase(HMACTests.allTests),
    testCase(CMACTests.allTests),
    testCase(AESTests.allTests()),
    testCase(BlowfishTests.allTests()),
    testCase(ChaCha20Tests.allTests()),
    testCase(RabbitTests.allTests()),
    testCase(ExtensionsTest.allTests()),
    testCase(PaddingTests.allTests),
    testCase(PBKDF.allTests()),
    testCase(RandomBytesSequenceTests.allTests),
    testCase(Access.allTests),
]

#if !CI
    tests += [
        testCase(DigestTestsPerf.allTests()),
        testCase(AESTestsPerf.allTests()),
        testCase(ChaCha20TestsPerf.allTests()),
        testCase(RabbitTestsPerf.allTests()),
        testCase(ExtensionsTestPerf.allTests()),
        testCase(PBKDFPerf.allTests()),
    ]
#endif

XCTMain(tests)
