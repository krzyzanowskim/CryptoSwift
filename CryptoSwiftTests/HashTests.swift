//
//  CryptoSwiftTests.swift
//  CryptoSwiftTests
//
//  Created by Marcin Krzyzanowski on 06/07/14.
//  Copyright (c) 2014 Marcin Krzyzanowski. All rights reserved.
//

import XCTest
@testable import CryptoSwift

final class CryptoSwiftTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testMD5_data() {
        let data = [0x31, 0x32, 0x33] as [UInt8] // "1", "2", "3"
        XCTAssertEqual(Hash.md5(data).calculate(), [0x20,0x2c,0xb9,0x62,0xac,0x59,0x07,0x5b,0x96,0x4b,0x07,0x15,0x2d,0x23,0x4b,0x70], "MD5 calculation failed");
    }

    func testMD5_emptyString() {
        let data:NSData = "".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
        XCTAssertEqual(Hash.md5(data.arrayOfBytes()).calculate(), [0xd4,0x1d,0x8c,0xd9,0x8f,0x00,0xb2,0x04,0xe9,0x80,0x09,0x98,0xec,0xf8,0x42,0x7e], "MD5 calculation failed")
    }

    func testMD5_string() {
        XCTAssertEqual("123".md5(), "202cb962ac59075b964b07152d234b70", "MD5 calculation failed");
        XCTAssertEqual("".md5(), "d41d8cd98f00b204e9800998ecf8427e", "MD5 calculation failed")
        XCTAssertEqual("a".md5(), "0cc175b9c0f1b6a831c399e269772661", "MD5 calculation failed")
        XCTAssertEqual("abc".md5(), "900150983cd24fb0d6963f7d28e17f72", "MD5 calculation failed")
        XCTAssertEqual("message digest".md5(), "f96b697d7cb7938d525a2f31aaf161d0", "MD5 calculation failed")
        XCTAssertEqual("abcdefghijklmnopqrstuvwxyz".md5(), "c3fcd3d76192e4007dfb496cca67e13b", "MD5 calculation failed")
        XCTAssertEqual("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789".md5(), "d174ab98d277d9f5a5611c2c9f419d9f", "MD5 calculation failed")
        XCTAssertEqual("12345678901234567890123456789012345678901234567890123456789012345678901234567890".md5(), "57edf4a22be3c955ac49da2e2107b67a", "MD5 calculation failed")
    }
    
    func testMD5PerformanceSwift() {
        self.measureMetrics([XCTPerformanceMetric_WallClockTime], automaticallyStartMeasuring: false, forBlock: { () -> Void in
            let buf = UnsafeMutablePointer<UInt8>(calloc(1024 * 1024, sizeof(UInt8)))
            let data = NSData(bytes: buf, length: 1024 * 1024)
            let arr = data.arrayOfBytes()
            self.startMeasuring()
                Hash.md5(arr).calculate()
            self.stopMeasuring()
            buf.dealloc(1024 * 1024)
            buf.destroy()
        })
    }
    
    func testMD5PerformanceCommonCrypto() {
        self.measureMetrics([XCTPerformanceMetric_WallClockTime], automaticallyStartMeasuring: false, forBlock: { () -> Void in
            let buf = UnsafeMutablePointer<UInt8>(calloc(1024 * 1024, sizeof(UInt8)))
            let data = NSData(bytes: buf, length: 1024 * 1024)
            let outbuf = UnsafeMutablePointer<UInt8>.alloc(Int(CC_MD5_DIGEST_LENGTH))
            self.startMeasuring()
                CC_MD5(data.bytes, CC_LONG(data.length), outbuf)
            //let output = NSData(bytes: outbuf, length: Int(CC_MD5_DIGEST_LENGTH));
            self.stopMeasuring()
            outbuf.dealloc(Int(CC_MD5_DIGEST_LENGTH))
            outbuf.destroy()
            buf.dealloc(1024 * 1024)
            buf.destroy()
        })
    }
    
    func testSHA1() {
        let data:NSData = NSData(bytes: [0x31, 0x32, 0x33] as [UInt8], length: 3)
        if let hash = data.sha1() {
            XCTAssertEqual(hash.toHexString(), "40bd001563085fc35165329ea1ff5c5ecbdbbeef", "SHA1 calculation failed");
        }
        
        XCTAssertEqual("abc".sha1(), "a9993e364706816aba3e25717850c26c9cd0d89d", "SHA1 calculation failed")
        XCTAssertEqual("abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq".sha1(), "84983e441c3bd26ebaae4aa1f95129e5e54670f1", "SHA1 calculation failed")
        XCTAssertEqual("".sha1(), "da39a3ee5e6b4b0d3255bfef95601890afd80709", "SHA1 calculation failed")
    }
    
    func testSHA224() {
        let data:NSData = NSData(bytes: [0x31, 0x32, 0x33] as [UInt8], length: 3)
        if let hash = data.sha224() {
            XCTAssertEqual(hash.toHexString(), "78d8045d684abd2eece923758f3cd781489df3a48e1278982466017f", "SHA224 calculation failed");
        }
    }

    func testSHA256() {
        let data:NSData = NSData(bytes: [0x31, 0x32, 0x33] as [UInt8], length: 3)
        if let hash = data.sha256() {
            XCTAssertEqual(hash.toHexString(), "a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3", "SHA256 calculation failed");
        }
        
        XCTAssertEqual("Rosetta code".sha256(), "764faf5c61ac315f1497f9dfa542713965b785e5cc2f707d6468d7d1124cdfcf", "SHA256 calculation failed")
        XCTAssertEqual("".sha256(), "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855", "SHA256 calculation failed")
    }

    func testSHA384() {
        let data:NSData = NSData(bytes: [49, 50, 51] as [UInt8], length: 3)
        if let hash = data.sha384() {
            XCTAssertEqual(hash.toHexString(), "9a0a82f0c0cf31470d7affede3406cc9aa8410671520b727044eda15b4c25532a9b5cd8aaf9cec4919d76255b6bfb00f", "SHA384 calculation failed");
        }
        
        XCTAssertEqual("The quick brown fox jumps over the lazy dog.".sha384(), "ed892481d8272ca6df370bf706e4d7bc1b5739fa2177aae6c50e946678718fc67a7af2819a021c2fc34e91bdb63409d7", "SHA384 calculation failed");
        XCTAssertEqual("".sha384(), "38b060a751ac96384cd9327eb1b1e36a21fdb71114be07434c0cc7bf63f6e1da274edebfe76f65fbd51ad2f14898b95b", "SHA384 calculation failed")
    }

    func testSHA512() {
        let data:NSData = NSData(bytes: [49, 50, 51] as [UInt8], length: 3)
        if let hash = data.sha512() {
            XCTAssertEqual(hash.toHexString(), "3c9909afec25354d551dae21590bb26e38d53f2173b8d3dc3eee4c047e7ab1c1eb8b85103e3be7ba613b31bb5c9c36214dc9f14a42fd7a2fdb84856bca5c44c2", "SHA512 calculation failed");
        }
        
        XCTAssertEqual("The quick brown fox jumps over the lazy dog.".sha512(), "91ea1245f20d46ae9a037a989f54f1f790f0a47607eeb8a14d12890cea77a1bbc6c7ed9cf205e67b7f2b8fd4c7dfd3a7a8617e45f3c463d481c7e586c39ac1ed", "SHA512 calculation failed");
        XCTAssertEqual("".sha512(), "cf83e1357eefb8bdf1542850d66d8007d620e4050b5715dc83f4a921d36ce9ce47d0d13c5d85f2b0ff8318d2877eec2f63b931bd47417a81a538327af927da3e", "SHA512 calculation failed")
    }
    
    func testCRC32() {
        let data:NSData = NSData(bytes: [49, 50, 51] as [UInt8], length: 3)
        if let crc = data.crc32(nil) {
            XCTAssertEqual(crc.toHexString(), "884863d2", "CRC32 calculation failed");
        }
        
        XCTAssertEqual("".crc32(nil), "00000000", "CRC32 calculation failed");
    }
    
    func testCRC16() {
        let result = CRC().crc16([49,50,51,52,53,54,55,56,57] as [UInt8])
        XCTAssert(result == 0xBB3D, "CRC16 failed")
    }
    
    func testChecksum() {
        let data:NSData = NSData(bytes: [49, 50, 51] as [UInt8], length: 3)
        XCTAssert(data.checksum() == 0x96, "Invalid checksum")
    }

}
