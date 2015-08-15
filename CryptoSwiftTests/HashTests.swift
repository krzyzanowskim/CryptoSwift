//
//  CryptoSwiftTests.swift
//  CryptoSwiftTests
//
//  Created by Marcin Krzyzanowski on 06/07/14.
//  Copyright (c) 2014 Marcin Krzyzanowski. All rights reserved.
//

import XCTest
import CryptoSwift

final class CryptoSwiftTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testMD5() {
        let data1:NSData = NSData(bytes: [0x31, 0x32, 0x33] as [UInt8], length: 3) // "1", "2", "3"
        if let hash = Hash.md5(data1).calculate() {
            XCTAssertEqual(hash.toHexString(), "202cb962ac59075b964b07152d234b70", "MD5 calculation failed");
        } else {
            XCTAssert(false, "Missing result")
        }
        
        var string:NSString = ""
        var data:NSData = string.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
        if let hashData = Hash.md5(data).calculate() {
            XCTAssertEqual(hashData.toHexString(), "d41d8cd98f00b204e9800998ecf8427e", "MD5 calculation failed")
        } else {
            XCTAssert(false, "Missing result")
        }
        
        if let hash = data1.md5() {
            XCTAssertEqual(hash.toHexString(), "202cb962ac59075b964b07152d234b70", "MD5 calculation failed");
        }
        
        if let hash = "123".md5() {
            XCTAssertEqual(hash, "202cb962ac59075b964b07152d234b70", "MD5 calculation failed");
        }
        
        if let hash = "".md5() {
            XCTAssertEqual(hash, "d41d8cd98f00b204e9800998ecf8427e", "MD5 calculation failed")
        } else {
            XCTAssert(false, "Hash for empty string is missing")
        }
        
        if let hash = "a".md5() {
            XCTAssertEqual(hash, "0cc175b9c0f1b6a831c399e269772661", "MD5 calculation failed")
        }
        
        if let hash = "abc".md5() {
            XCTAssertEqual(hash, "900150983cd24fb0d6963f7d28e17f72", "MD5 calculation failed")
        }
        
        if let hash = "message digest".md5() {
            XCTAssertEqual(hash, "f96b697d7cb7938d525a2f31aaf161d0", "MD5 calculation failed")
        }

        if let hash = "abcdefghijklmnopqrstuvwxyz".md5() {
            XCTAssertEqual(hash, "c3fcd3d76192e4007dfb496cca67e13b", "MD5 calculation failed")
        }

        if let hash = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789".md5() {
            XCTAssertEqual(hash, "d174ab98d277d9f5a5611c2c9f419d9f", "MD5 calculation failed")
        }

        if let hash = "12345678901234567890123456789012345678901234567890123456789012345678901234567890".md5() {
            XCTAssertEqual(hash, "57edf4a22be3c955ac49da2e2107b67a", "MD5 calculation failed")
        }
    }
    
    func testMD5PerformanceSwift() {
        self.measureMetrics([XCTPerformanceMetric_WallClockTime], automaticallyStartMeasuring: false, forBlock: { () -> Void in
            let buf = UnsafeMutablePointer<UInt8>(calloc(2048, sizeof(UInt8)))
            let data = NSData(bytes: buf, length: 2048)
            self.startMeasuring()
            Hash.md5(data).calculate()
            self.stopMeasuring()
            buf.dealloc(1024)
            buf.destroy()
        })
    }
    
    func testMD5PerformanceCommonCrypto() {
        self.measureMetrics([XCTPerformanceMetric_WallClockTime], automaticallyStartMeasuring: false, forBlock: { () -> Void in
            let buf = UnsafeMutablePointer<UInt8>(calloc(2048, sizeof(UInt8)))
            let data = NSData(bytes: buf, length: 2048)
            self.startMeasuring()
            var outbuf = UnsafeMutablePointer<UInt8>.alloc(Int(CC_MD5_DIGEST_LENGTH))
            CC_MD5(data.bytes, CC_LONG(data.length), outbuf)
            let output = NSData(bytes: outbuf, length: Int(CC_MD5_DIGEST_LENGTH));
            outbuf.dealloc(Int(CC_MD5_DIGEST_LENGTH))
            outbuf.destroy()
            self.stopMeasuring()
            buf.dealloc(1024)
            buf.destroy()
        })
    }
    
    func testSHA1() {
        var data:NSData = NSData(bytes: [0x31, 0x32, 0x33] as [UInt8], length: 3)
        if let hash = data.sha1() {
            XCTAssertEqual(hash.toHexString(), "40bd001563085fc35165329ea1ff5c5ecbdbbeef", "SHA1 calculation failed");
        }
        
        if let hash = "abc".sha1() {
            XCTAssertEqual(hash, "a9993e364706816aba3e25717850c26c9cd0d89d", "SHA1 calculation failed")
        }

        if let hash = "abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq".sha1() {
            XCTAssertEqual(hash, "84983e441c3bd26ebaae4aa1f95129e5e54670f1", "SHA1 calculation failed")
        }
        
        if let hash = "".sha1() {
            XCTAssertEqual(hash, "da39a3ee5e6b4b0d3255bfef95601890afd80709", "SHA1 calculation failed")
        } else {
            XCTAssert(false, "SHA1 calculation failed")
        }
        
    }
    
    func testSHA224() {
        var data:NSData = NSData(bytes: [0x31, 0x32, 0x33] as [UInt8], length: 3)
        if let hash = data.sha224() {
            XCTAssertEqual(hash.toHexString(), "78d8045d684abd2eece923758f3cd781489df3a48e1278982466017f", "SHA224 calculation failed");
        }
    }

    func testSHA256() {
        var data:NSData = NSData(bytes: [0x31, 0x32, 0x33] as [UInt8], length: 3)
        if let hash = data.sha256() {
            XCTAssertEqual(hash.toHexString(), "a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3", "SHA256 calculation failed");
        }
        
        if let hash = "Rosetta code".sha256() {
            XCTAssertEqual(hash, "764faf5c61ac315f1497f9dfa542713965b785e5cc2f707d6468d7d1124cdfcf", "SHA256 calculation failed")
        }
        
        if let hash = "".sha256() {
            XCTAssertEqual(hash, "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855", "SHA256 calculation failed")
        } else {
            XCTAssert(false, "SHA256 calculation failed")
        }

    }

    func testSHA384() {
        var data:NSData = NSData(bytes: [49, 50, 51] as [UInt8], length: 3)
        if let hash = data.sha384() {
            XCTAssertEqual(hash.toHexString(), "9a0a82f0c0cf31470d7affede3406cc9aa8410671520b727044eda15b4c25532a9b5cd8aaf9cec4919d76255b6bfb00f", "SHA384 calculation failed");
        }
        
        if let hash = "The quick brown fox jumps over the lazy dog.".sha384() {
            XCTAssertEqual(hash, "ed892481d8272ca6df370bf706e4d7bc1b5739fa2177aae6c50e946678718fc67a7af2819a021c2fc34e91bdb63409d7", "SHA384 calculation failed");
        }
        
        if let hash = "".sha384() {
            XCTAssertEqual(hash, "38b060a751ac96384cd9327eb1b1e36a21fdb71114be07434c0cc7bf63f6e1da274edebfe76f65fbd51ad2f14898b95b", "SHA384 calculation failed")
        } else {
            XCTAssert(false, "SHA384 calculation failed")
        }
    }

    func testSHA512() {
        var data:NSData = NSData(bytes: [49, 50, 51] as [UInt8], length: 3)
        if let hash = data.sha512() {
            XCTAssertEqual(hash.toHexString(), "3c9909afec25354d551dae21590bb26e38d53f2173b8d3dc3eee4c047e7ab1c1eb8b85103e3be7ba613b31bb5c9c36214dc9f14a42fd7a2fdb84856bca5c44c2", "SHA512 calculation failed");
        }
        
        if let hash = "The quick brown fox jumps over the lazy dog.".sha512() {
            XCTAssertEqual(hash, "91ea1245f20d46ae9a037a989f54f1f790f0a47607eeb8a14d12890cea77a1bbc6c7ed9cf205e67b7f2b8fd4c7dfd3a7a8617e45f3c463d481c7e586c39ac1ed", "SHA512 calculation failed");
        }
        
        if let hash = "".sha512() {
            XCTAssertEqual(hash, "cf83e1357eefb8bdf1542850d66d8007d620e4050b5715dc83f4a921d36ce9ce47d0d13c5d85f2b0ff8318d2877eec2f63b931bd47417a81a538327af927da3e", "SHA512 calculation failed")
        } else {
            XCTAssert(false, "SHA512 calculation failed")
        }
    }
    
    func testCRC32() {
        var data:NSData = NSData(bytes: [49, 50, 51] as [UInt8], length: 3)
        if let crc = data.crc32() {
            XCTAssertEqual(crc.toHexString(), "884863d2", "CRC32 calculation failed");
        }
        
        if let crc = "".crc32() {
            XCTAssertEqual(crc, "00000000", "CRC32 calculation failed");
        } else {
            XCTAssert(false, "CRC32 calculation failed")
        }
    }
    
    func testCRC32Async() {
        let expect = expectationWithDescription("CRC32")
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), { () -> Void in
            self.testCRC32()
            expect.fulfill()
        })

        waitForExpectationsWithTimeout(10, handler: { (error) -> Void in
            XCTAssertNil(error, "CRC32 async failed")
        })
    }
}
