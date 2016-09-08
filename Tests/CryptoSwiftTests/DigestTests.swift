//
//  DigestTests.swift
//  CryptoSwiftTests
//
//  Created by Marcin Krzyzanowski on 06/07/14.
//  Copyright (c) 2014 Marcin Krzyzanowski. All rights reserved.
//
// http://www.di-mgt.com.au/sha_testvectors.html (http://csrc.nist.gov/groups/ST/toolkit/documents/Examples/SHA_All.pdf)
//

import XCTest
import Foundation
@testable import CryptoSwift

final class DigestTests: XCTestCase {
    
    func testMD5Data() {
        let data = [0x31, 0x32, 0x33] as Array<UInt8> // "1", "2", "3"
        XCTAssertEqual(Digest.md5(data), [0x20,0x2c,0xb9,0x62,0xac,0x59,0x07,0x5b,0x96,0x4b,0x07,0x15,0x2d,0x23,0x4b,0x70], "MD5 calculation failed");
    }

    func testMD5String() {
        XCTAssertEqual("123".md5(), "202cb962ac59075b964b07152d234b70", "MD5 calculation failed");
        XCTAssertEqual("".md5(), "d41d8cd98f00b204e9800998ecf8427e", "MD5 calculation failed")
        XCTAssertEqual("a".md5(), "0cc175b9c0f1b6a831c399e269772661", "MD5 calculation failed")
        XCTAssertEqual("abc".md5(), "900150983cd24fb0d6963f7d28e17f72", "MD5 calculation failed")
        XCTAssertEqual("message digest".md5(), "f96b697d7cb7938d525a2f31aaf161d0", "MD5 calculation failed")
        XCTAssertEqual("abcdefghijklmnopqrstuvwxyz".md5(), "c3fcd3d76192e4007dfb496cca67e13b", "MD5 calculation failed")
        XCTAssertEqual("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789".md5(), "d174ab98d277d9f5a5611c2c9f419d9f", "MD5 calculation failed")
        XCTAssertEqual("12345678901234567890123456789012345678901234567890123456789012345678901234567890".md5(), "57edf4a22be3c955ac49da2e2107b67a", "MD5 calculation failed")
    }

    func testMD5Updates() {
        do {
            var hash = MD5()
            let _ = try hash.update(withBytes: [0x31, 0x32])
            let _ = try hash.update(withBytes: [0x33])
            let result = try hash.finish()
            XCTAssertEqual(result, [0x20,0x2c,0xb9,0x62,0xac,0x59,0x07,0x5b,0x96,0x4b,0x07,0x15,0x2d,0x23,0x4b,0x70])
        } catch {
            XCTFail()
        }
    }

    func testMD5PerformanceSwift() {
        self.measureMetrics([XCTPerformanceMetric_WallClockTime], automaticallyStartMeasuring: false, for: { () -> Void in
            let arr = Array<UInt8>(repeating: 200, count: 1024 * 1024)
            self.startMeasuring()
            _ = Digest.md5(arr)
            self.stopMeasuring()
        })
    }
    
    func testSHA1() {
        let data:Data = Data(bytes: UnsafePointer<UInt8>([0x31, 0x32, 0x33] as Array<UInt8>), count: 3)
        if let hash = data.sha1() {
            XCTAssertEqual(hash.toHexString(), "40bd001563085fc35165329ea1ff5c5ecbdbbeef", "SHA1 calculation failed");
        }
        
        XCTAssertEqual("abc".sha1(), "a9993e364706816aba3e25717850c26c9cd0d89d", "SHA1 calculation failed")
        XCTAssertEqual("abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq".sha1(), "84983e441c3bd26ebaae4aa1f95129e5e54670f1", "SHA1 calculation failed")
        XCTAssertEqual("".sha1(), "da39a3ee5e6b4b0d3255bfef95601890afd80709", "SHA1 calculation failed")
    }
    
    func testSHA224() {
        let data:Data = Data(bytes: UnsafePointer<UInt8>([0x31, 0x32, 0x33] as Array<UInt8>), count: 3)
        if let hash = data.sha224() {
            XCTAssertEqual(hash.toHexString(), "78d8045d684abd2eece923758f3cd781489df3a48e1278982466017f", "SHA224 calculation failed");
        }
    }

    func testSHA256() {
        let data:Data = Data(bytes: UnsafePointer<UInt8>([0x31, 0x32, 0x33] as Array<UInt8>), count: 3)
        if let hash = data.sha256() {
            XCTAssertEqual(hash.toHexString(), "a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3", "SHA256 calculation failed");
        }
        
        XCTAssertEqual("Rosetta code".sha256(), "764faf5c61ac315f1497f9dfa542713965b785e5cc2f707d6468d7d1124cdfcf", "SHA256 calculation failed")
        XCTAssertEqual("".sha256(), "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855", "SHA256 calculation failed")
    }

    func testSHA384() {
        let data:Data = Data(bytes: UnsafePointer<UInt8>([49, 50, 51] as Array<UInt8>), count: 3)
        if let hash = data.sha384() {
            XCTAssertEqual(hash.toHexString(), "9a0a82f0c0cf31470d7affede3406cc9aa8410671520b727044eda15b4c25532a9b5cd8aaf9cec4919d76255b6bfb00f", "SHA384 calculation failed");
        }
        
        XCTAssertEqual("The quick brown fox jumps over the lazy dog.".sha384(), "ed892481d8272ca6df370bf706e4d7bc1b5739fa2177aae6c50e946678718fc67a7af2819a021c2fc34e91bdb63409d7", "SHA384 calculation failed");
        XCTAssertEqual("".sha384(), "38b060a751ac96384cd9327eb1b1e36a21fdb71114be07434c0cc7bf63f6e1da274edebfe76f65fbd51ad2f14898b95b", "SHA384 calculation failed")
        XCTAssertEqual("abcdefghbcdefghicdefghijdefghijkefghijklfghijklmghijklmnhijklmnoijklmnopjklmnopqklmnopqrlmnopqrsmnopqrstnopqrstu".sha384(), "09330c33f71147e83d192fc782cd1b4753111b173b3b05d22fa08086e3b0f712fcc7c71a557e2db966c3e9fa91746039", "SHA384 calculation failed")
    }

    func testSHA512() {
        XCTAssertEqual("abc".sha512(), "ddaf35a193617abacc417349ae20413112e6fa4e89a97ea20a9eeee64b55d39a2192992a274fc1a836ba3c23a3feebbd454d4423643ce80e2a9ac94fa54ca49f", "length 24 bits");
        XCTAssertEqual("".sha512(), "cf83e1357eefb8bdf1542850d66d8007d620e4050b5715dc83f4a921d36ce9ce47d0d13c5d85f2b0ff8318d2877eec2f63b931bd47417a81a538327af927da3e", "the bit string of length 0");
        XCTAssertEqual("abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq".sha512(), "204a8fc6dda82f0a0ced7beb8e08a41657c16ef468b228a8279be331a703c33596fd15c13b1b07f9aa1d3bea57789ca031ad85c7a71dd70354ec631238ca3445", "length 448 bits");
        XCTAssertEqual("abcdefghbcdefghicdefghijdefghijkefghijklfghijklmghijklmnhijklmnoijklmnopjklmnopqklmnopqrlmnopqrsmnopqrstnopqrstu".sha512(), "8e959b75dae313da8cf4f72814fc143f8f7779c6eb9f7fa17299aeadb6889018501d289e4900f7e4331b99dec4b5433ac7d329eeb6dd26545e96e55b874be909", "length 896 bits");

        XCTAssertEqual(Array<UInt8>(repeating: 0x61, count: 1000000).sha512(), Array<UInt8>(hex: "e718483d0ce769644e2e42c7bc15b4638e1f98b13b2044285632a803afa973ebde0ff244877ea60a4cb0432ce577c31beb009c5c2c49aa2e4eadb217ad8cc09b"), "One million (1,000,000) repetitions of the character 'a' (0x61)")
    }
    
    func testCRC32() {
        let data:Data = Data(bytes: UnsafePointer<UInt8>([49, 50, 51] as Array<UInt8>), count: 3)
        if let crc = data.crc32(seed: nil) {
            XCTAssertEqual(crc.toHexString(), "884863d2", "CRC32 calculation failed");
        }
        
        XCTAssertEqual("".crc32(seed: nil), "00000000", "CRC32 calculation failed");
    }
    
    func testCRC32NotReflected() {
        let bytes : Array<UInt8> = [0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37, 0x38, 0x39]
        let data:Data = Data(bytes: UnsafePointer<UInt8>(bytes), count: bytes.count)
        if let crc = data.crc32(seed: nil, reflect: false) {
            XCTAssertEqual(crc.toHexString(), "fc891918", "CRC32 (with reflection) calculation failed");
        }
        
        XCTAssertEqual("".crc32(seed: nil, reflect: false), "00000000", "CRC32 (with reflection) calculation failed");
    }
    
    func testCRC16() {
        let result = Checksum.crc16([49,50,51,52,53,54,55,56,57] as Array<UInt8>)
        XCTAssert(result == 0xBB3D, "CRC16 failed")
    }
    
    func testChecksum() {
        let data:Data = Data(bytes: UnsafePointer<UInt8>([49, 50, 51] as Array<UInt8>), count: 3)
        XCTAssert(data.checksum() == 0x96, "Invalid checksum")
    }

    static let allTests =  [
        ("testMD5Data", testMD5Data),
        ("testMD5String", testMD5String),
        ("testMD5Updates", testMD5Updates),
        ("testMD5PerformanceSwift", testMD5PerformanceSwift),
        ("testSHA1", testSHA1),
        ("testSHA224", testSHA224),
        ("testSHA256", testSHA256),
        ("testSHA384", testSHA384),
        ("testSHA512", testSHA512),
        ("testCRC32", testCRC32),
        ("testCRC32NotReflected", testCRC32NotReflected),
        ("testCRC15", testCRC16),
        ("testChecksum", testChecksum)
    ]
}
