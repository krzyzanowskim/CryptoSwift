import XCTest

import CryptoSwiftTests
import TestsPerformance

var tests = [XCTestCaseEntry]()
tests += CryptoSwiftTests.__allTests()
tests += TestsPerformance.__allTests()

XCTMain(tests)
