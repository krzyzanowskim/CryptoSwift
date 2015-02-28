//
//  CryptoSwiftTests.swift
//  CryptoSwiftTests
//
//  Created by Marcin Krzyzanowski on 06/07/14.
//  Copyright (c) 2014 Marcin Krzyzanowski. All rights reserved.
//

import XCTest
import CryptoSwift

class CryptoSwiftTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testMD5() {
        let data1:NSData = NSData(bytes: [0x31, 0x32, 0x33] as [UInt8], length: 3) // "1", "2", "3"
        if let hash = Hash.md5(data1).calculate() {
            XCTAssertEqual(hash.hexString, "202CB962AC59075B964B07152D234B70", "MD5 calculation failed");
        } else {
            XCTAssert(false, "Missing result")
        }
        
        var string:NSString = ""
        var data:NSData = string.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
        if let hashData = Hash.md5(data).calculate() {
            XCTAssertEqual(hashData.hexString, "D41D8CD98F00B204E9800998ECF8427E", "MD5 calculation failed")
        } else {
            XCTAssert(false, "Missing result")
        }
        
        if let hash = data1.md5() {
            XCTAssertEqual(hash.hexString, "202CB962AC59075B964B07152D234B70", "MD5 calculation failed");
        }
        
        if let hash = "123".md5() {
            XCTAssertEqual(hash, "202CB962AC59075B964B07152D234B70", "MD5 calculation failed");
        }
        
        if let hash = "".md5() {
            XCTAssertEqual(hash, "D41D8CD98F00B204E9800998ECF8427E", "MD5 calculation failed")
        } else {
            XCTAssert(false, "Hash for empty string is missing")
        }
        
        if let hash = "a".md5() {
            XCTAssertEqual(hash, "0CC175B9C0F1B6A831C399E269772661", "MD5 calculation failed")
        }
        
        if let hash = "abc".md5() {
            XCTAssertEqual(hash, "900150983CD24FB0D6963F7D28E17F72", "MD5 calculation failed")
        }
        
        if let hash = "message digest".md5() {
            XCTAssertEqual(hash, "F96B697D7CB7938D525A2F31AAF161D0", "MD5 calculation failed")
        }

        if let hash = "abcdefghijklmnopqrstuvwxyz".md5() {
            XCTAssertEqual(hash, "C3FCD3D76192E4007DFB496CCA67E13B", "MD5 calculation failed")
        }

        if let hash = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789".md5() {
            XCTAssertEqual(hash, "D174AB98D277D9F5A5611C2C9F419D9F", "MD5 calculation failed")
        }

        if let hash = "12345678901234567890123456789012345678901234567890123456789012345678901234567890".md5() {
            XCTAssertEqual(hash, "57EDF4A22BE3C955AC49DA2E2107B67A", "MD5 calculation failed")
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
            XCTAssertEqual(hash.hexString, "40BD001563085FC35165329EA1FF5C5ECBDBBEEF", "SHA1 calculation failed");
        }
        
        if let hash = "abc".sha1() {
            XCTAssertEqual(hash, "A9993E364706816ABA3E25717850C26C9CD0D89D", "SHA1 calculation failed")
        }

        if let hash = "abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq".sha1() {
            XCTAssertEqual(hash, "84983E441C3BD26EBAAE4AA1F95129E5E54670F1", "SHA1 calculation failed")
        }
        
        if let hash = "".sha1() {
            XCTAssertEqual(hash, "DA39A3EE5E6B4B0D3255BFEF95601890AFD80709", "SHA1 calculation failed")
        } else {
            XCTAssert(false, "SHA1 calculation failed")
        }
        
    }
    
    func testSHA224() {
        var data:NSData = NSData(bytes: [0x31, 0x32, 0x33] as [UInt8], length: 3)
        if let hash = data.sha224() {
            XCTAssertEqual(hash.hexString, "78D8045D684ABD2EECE923758F3CD781489DF3A48E1278982466017F", "SHA224 calculation failed");
        }
    }

    func testSHA256() {
        var data:NSData = NSData(bytes: [0x31, 0x32, 0x33] as [UInt8], length: 3)
        if let hash = data.sha256() {
            XCTAssertEqual(hash.hexString, "A665A45920422F9D417E4867EFDC4FB8A04A1F3FFF1FA07E998E86F7F7A27AE3", "SHA256 calculation failed");
        }
        
        if let hash = "Rosetta code".sha256() {
            XCTAssertEqual(hash, "764FAF5C61AC315F1497F9DFA542713965B785E5CC2F707D6468D7D1124CDFCF", "SHA256 calculation failed")
        }
        
        if let hash = "".sha256() {
            XCTAssertEqual(hash, "E3B0C44298FC1C149AFBF4C8996FB92427AE41E4649B934CA495991B7852B855", "SHA256 calculation failed")
        } else {
            XCTAssert(false, "SHA256 calculation failed")
        }

    }

    func testSHA384() {
        var data:NSData = NSData(bytes: [49, 50, 51] as [UInt8], length: 3)
        if let hash = data.sha384() {
            XCTAssertEqual(hash.hexString, "9A0A82F0C0CF31470D7AFFEDE3406CC9AA8410671520B727044EDA15B4C25532A9B5CD8AAF9CEC4919D76255B6BFB00F", "SHA384 calculation failed");
        }
        
        if let hash = "The quick brown fox jumps over the lazy dog.".sha384() {
            XCTAssertEqual(hash, "ED892481D8272CA6DF370BF706E4D7BC1B5739FA2177AAE6C50E946678718FC67A7AF2819A021C2FC34E91BDB63409D7", "SHA384 calculation failed");
        }
        
        if let hash = "".sha384() {
            XCTAssertEqual(hash, "38B060A751AC96384CD9327EB1B1E36A21FDB71114BE07434C0CC7BF63F6E1DA274EDEBFE76F65FBD51AD2F14898B95B", "SHA384 calculation failed")
        } else {
            XCTAssert(false, "SHA384 calculation failed")
        }
    }

    func testSHA512() {
        var data:NSData = NSData(bytes: [49, 50, 51] as [UInt8], length: 3)
        if let hash = data.sha512() {
            XCTAssertEqual(hash.hexString, "3C9909AFEC25354D551DAE21590BB26E38D53F2173B8D3DC3EEE4C047E7AB1C1EB8B85103E3BE7BA613B31BB5C9C36214DC9F14A42FD7A2FDB84856BCA5C44C2", "SHA512 calculation failed");
        }
        
        if let hash = "The quick brown fox jumps over the lazy dog.".sha512() {
            XCTAssertEqual(hash, "91EA1245F20D46AE9A037A989F54F1F790F0A47607EEB8A14D12890CEA77A1BBC6C7ED9CF205E67B7F2B8FD4C7DFD3A7A8617E45F3C463D481C7E586C39AC1ED", "SHA512 calculation failed");
        }
        
        if let hash = "".sha512() {
            XCTAssertEqual(hash, "CF83E1357EEFB8BDF1542850D66D8007D620E4050B5715DC83F4A921D36CE9CE47D0D13C5D85F2B0FF8318D2877EEC2F63B931BD47417A81A538327AF927DA3E", "SHA512 calculation failed")
        } else {
            XCTAssert(false, "SHA512 calculation failed")
        }
    }
    
    func testCRC32() {
        var data:NSData = NSData(bytes: [49, 50, 51] as [UInt8], length: 3)
        if let crc = data.crc32() {
            XCTAssertEqual(crc.hexString, "884863D2", "CRC32 calculation failed");
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

        self.waitForExpectationsWithTimeout(10, handler: { (error) -> Void in
            XCTAssertNil(error, "CRC32 async failed")
        })
    }
}
