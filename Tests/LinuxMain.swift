import XCTest

import Tests
import TestsPerformance

var tests = [XCTestCaseEntry]()
tests += Tests.__allTests()
// tests += TestsPerformance.__allTests()

XCTMain(tests)
