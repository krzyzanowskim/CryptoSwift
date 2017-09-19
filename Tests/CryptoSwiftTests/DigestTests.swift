//
//  DigestTests.swift
//  CryptoSwiftTests
//
//  Created by Marcin Krzyzanowski on 06/07/14.
//  Copyright (C) 2014-2017 Krzyzanowski. All rights reserved.
//
// http://www.di-mgt.com.au/sha_testvectors.html (http://csrc.nist.gov/groups/ST/toolkit/documents/Examples/SHA_All.pdf)
//

import XCTest
import Foundation
@testable import CryptoSwift

final class DigestTests: XCTestCase {

    func testMD5() {
        XCTAssertEqual("123".md5(), "202cb962ac59075b964b07152d234b70", "MD5 calculation failed")
        XCTAssertEqual("".md5(), "d41d8cd98f00b204e9800998ecf8427e", "MD5 calculation failed")
        XCTAssertEqual("a".md5(), "0cc175b9c0f1b6a831c399e269772661", "MD5 calculation failed")
        XCTAssertEqual("abc".md5(), "900150983cd24fb0d6963f7d28e17f72", "MD5 calculation failed")
        XCTAssertEqual("message digest".md5(), "f96b697d7cb7938d525a2f31aaf161d0", "MD5 calculation failed")
        XCTAssertEqual("abcdefghijklmnopqrstuvwxyz".md5(), "c3fcd3d76192e4007dfb496cca67e13b", "MD5 calculation failed")
        XCTAssertEqual("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789".md5(), "d174ab98d277d9f5a5611c2c9f419d9f", "MD5 calculation failed")
        XCTAssertEqual("12345678901234567890123456789012345678901234567890123456789012345678901234567890".md5(), "57edf4a22be3c955ac49da2e2107b67a", "MD5 calculation failed")
    }

    func testSHA1() {
        XCTAssertEqual(SHA1().calculate(for: Array<UInt8>(hex: "616263")).toHexString(), "a9993e364706816aba3e25717850c26c9cd0d89d")
        XCTAssertEqual(SHA1().calculate(for: Array<UInt8>(hex: "")).toHexString(), "da39a3ee5e6b4b0d3255bfef95601890afd80709")
        XCTAssertEqual("abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq".sha1(), "84983e441c3bd26ebaae4aa1f95129e5e54670f1")
        XCTAssertEqual("abcdefghbcdefghicdefghijdefghijkefghijklfghijklmghijklmnhijklmnoijklmnopjklmnopqklmnopqrlmnopqrsmnopqrstnopqrstu".sha1(), "a49b2446a02c645bf419f995b67091253a04a259")
        XCTAssertEqual(Array<UInt8>(repeating: 0x61, count: 1_000_000).sha1(), Array<UInt8>(hex: "34aa973cd4c4daa4f61eeb2bdbad27316534016f"), "One million (1,000,000) repetitions of the character 'a' (0x61)")

        // https://github.com/krzyzanowskim/CryptoSwift/issues/363
        XCTAssertEqual("1477304791&1XpnGSRhOlZz2etXMeOdfNaHILTjW16U&8mpBBbzwsgs".sha1(), "0809bbf8489c594131c2030a84be364a0851a635", "Failed")
        XCTAssertEqual("1477304791&1XpnGSRhOlZz2etXMeOdfNaHILTjW16U&8mpBBbzwsgsa".sha1(), "d345b525ebada7becc8107c54e07fa88644471f5", "Failed")
        XCTAssertEqual("1477304791&1XpnGSRhOlZz2etXMeOdfNaHILTjW16U&8mpBBbzwsg".sha1(), "c106aa0a98606294ee35fd2d937e928ebb5339e0", "Failed")
    }

    func testSHA2() {
        XCTAssertEqual(SHA2(variant: .sha224).calculate(for: Array<UInt8>(hex: "616263")).toHexString(), "23097d223405d8228642a477bda255b32aadbce4bda0b3f7e36c9da7")
        XCTAssertEqual(SHA2(variant: .sha256).calculate(for: Array<UInt8>(hex: "616263")).toHexString(), "ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad")
        XCTAssertEqual(SHA2(variant: .sha384).calculate(for: Array<UInt8>(hex: "616263")).toHexString(), "cb00753f45a35e8bb5a03d699ac65007272c32ab0eded1631a8b605a43ff5bed8086072ba1e7cc2358baeca134c825a7")
        XCTAssertEqual(SHA2(variant: .sha512).calculate(for: Array<UInt8>(hex: "616263")).toHexString(), "ddaf35a193617abacc417349ae20413112e6fa4e89a97ea20a9eeee64b55d39a2192992a274fc1a836ba3c23a3feebbd454d4423643ce80e2a9ac94fa54ca49f")

        XCTAssertEqual(SHA2(variant: .sha224).calculate(for: Array<UInt8>(hex: "")).toHexString(), "d14a028c2a3a2bc9476102bb288234c415a2b01f828ea62ac5b3e42f")
        XCTAssertEqual(SHA2(variant: .sha256).calculate(for: Array<UInt8>(hex: "")).toHexString(), "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855")
        XCTAssertEqual(SHA2(variant: .sha384).calculate(for: Array<UInt8>(hex: "")).toHexString(), "38b060a751ac96384cd9327eb1b1e36a21fdb71114be07434c0cc7bf63f6e1da274edebfe76f65fbd51ad2f14898b95b")
        XCTAssertEqual(SHA2(variant: .sha512).calculate(for: Array<UInt8>(hex: "")).toHexString(), "cf83e1357eefb8bdf1542850d66d8007d620e4050b5715dc83f4a921d36ce9ce47d0d13c5d85f2b0ff8318d2877eec2f63b931bd47417a81a538327af927da3e")

        XCTAssertEqual("abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq".sha224(), "75388b16512776cc5dba5da1fd890150b0c6455cb4f58b1952522525")
        XCTAssertEqual("abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq".sha256(), "248d6a61d20638b8e5c026930c3e6039a33ce45964ff2167f6ecedd419db06c1")
        XCTAssertEqual("abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq".sha384(), "3391fdddfc8dc7393707a65b1b4709397cf8b1d162af05abfe8f450de5f36bc6b0455a8520bc4e6f5fe95b1fe3c8452b")
        XCTAssertEqual("abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq".sha512(), "204a8fc6dda82f0a0ced7beb8e08a41657c16ef468b228a8279be331a703c33596fd15c13b1b07f9aa1d3bea57789ca031ad85c7a71dd70354ec631238ca3445")

        XCTAssertEqual("abcdefghbcdefghicdefghijdefghijkefghijklfghijklmghijklmnhijklmnoijklmnopjklmnopqklmnopqrlmnopqrsmnopqrstnopqrstu".sha224(), "c97ca9a559850ce97a04a96def6d99a9e0e0e2ab14e6b8df265fc0b3")
        XCTAssertEqual("abcdefghbcdefghicdefghijdefghijkefghijklfghijklmghijklmnhijklmnoijklmnopjklmnopqklmnopqrlmnopqrsmnopqrstnopqrstu".sha256(), "cf5b16a778af8380036ce59e7b0492370b249b11e8f07a51afac45037afee9d1")
        XCTAssertEqual("abcdefghbcdefghicdefghijdefghijkefghijklfghijklmghijklmnhijklmnoijklmnopjklmnopqklmnopqrlmnopqrsmnopqrstnopqrstu".sha384(), "09330c33f71147e83d192fc782cd1b4753111b173b3b05d22fa08086e3b0f712fcc7c71a557e2db966c3e9fa91746039")
        XCTAssertEqual("abcdefghbcdefghicdefghijdefghijkefghijklfghijklmghijklmnhijklmnoijklmnopjklmnopqklmnopqrlmnopqrsmnopqrstnopqrstu".sha512(), "8e959b75dae313da8cf4f72814fc143f8f7779c6eb9f7fa17299aeadb6889018501d289e4900f7e4331b99dec4b5433ac7d329eeb6dd26545e96e55b874be909")

        XCTAssertEqual(Array<UInt8>(repeating: 0x61, count: 1_000_000).sha224(), Array<UInt8>(hex: "20794655980c91d8bbb4c1ea97618a4bf03f42581948b2ee4ee7ad67"), "One million (1,000,000) repetitions of the character 'a' (0x61)")
        XCTAssertEqual(Array<UInt8>(repeating: 0x61, count: 1_000_000).sha256(), Array<UInt8>(hex: "cdc76e5c9914fb9281a1c7e284d73e67f1809a48a497200e046d39ccc7112cd0"), "One million (1,000,000) repetitions of the character 'a' (0x61)")
        XCTAssertEqual(Array<UInt8>(repeating: 0x61, count: 1_000_000).sha384(), Array<UInt8>(hex: "9d0e1809716474cb086e834e310a4a1ced149e9c00f248527972cec5704c2a5b07b8b3dc38ecc4ebae97ddd87f3d8985"), "One million (1,000,000) repetitions of the character 'a' (0x61)")
        XCTAssertEqual(Array<UInt8>(repeating: 0x61, count: 1_000_000).sha512(), Array<UInt8>(hex: "e718483d0ce769644e2e42c7bc15b4638e1f98b13b2044285632a803afa973ebde0ff244877ea60a4cb0432ce577c31beb009c5c2c49aa2e4eadb217ad8cc09b"), "One million (1,000,000) repetitions of the character 'a' (0x61)")

        XCTAssertEqual("Rosetta code".sha256(), "764faf5c61ac315f1497f9dfa542713965b785e5cc2f707d6468d7d1124cdfcf", "SHA256 calculation failed")
        XCTAssertEqual("The quick brown fox jumps over the lazy dog.".sha384(), "ed892481d8272ca6df370bf706e4d7bc1b5739fa2177aae6c50e946678718fc67a7af2819a021c2fc34e91bdb63409d7", "SHA384 calculation failed")
    }

    func testSHA3() {
        XCTAssertEqual(SHA3(variant: .sha224).calculate(for: Array<UInt8>(hex: "616263")).toHexString(), "e642824c3f8cf24ad09234ee7d3c766fc9a3a5168d0c94ad73b46fdf")
        XCTAssertEqual(SHA3(variant: .sha256).calculate(for: Array<UInt8>(hex: "616263")).toHexString(), "3a985da74fe225b2045c172d6bd390bd855f086e3e9d525b46bfe24511431532")
        XCTAssertEqual(SHA3(variant: .sha384).calculate(for: Array<UInt8>(hex: "616263")).toHexString(), "ec01498288516fc926459f58e2c6ad8df9b473cb0fc08c2596da7cf0e49be4b298d88cea927ac7f539f1edf228376d25")
        XCTAssertEqual(SHA3(variant: .sha512).calculate(for: Array<UInt8>(hex: "616263")).toHexString(), "b751850b1a57168a5693cd924b6b096e08f621827444f70d884f5d0240d2712e10e116e9192af3c91a7ec57647e3934057340b4cf408d5a56592f8274eec53f0")

        XCTAssertEqual(SHA3(variant: .sha224).calculate(for: Array<UInt8>(hex: "")).toHexString(), "6b4e03423667dbb73b6e15454f0eb1abd4597f9a1b078e3f5b5a6bc7")
        XCTAssertEqual(SHA3(variant: .sha256).calculate(for: Array<UInt8>(hex: "")).toHexString(), "a7ffc6f8bf1ed76651c14756a061d662f580ff4de43b49fa82d80a4b80f8434a")
        XCTAssertEqual(SHA3(variant: .sha384).calculate(for: Array<UInt8>(hex: "")).toHexString(), "0c63a75b845e4f7d01107d852e4c2485c51a50aaaa94fc61995e71bbee983a2ac3713831264adb47fb6bd1e058d5f004")
        XCTAssertEqual(SHA3(variant: .sha512).calculate(for: Array<UInt8>(hex: "")).toHexString(), "a69f73cca23a9ac5c8b567dc185a756e97c982164fe25859e0d1dcc1475c80a615b2123af1f5f94c11e3e9402c3ac558f500199d95b6d3e301758586281dcd26")

        XCTAssertEqual("abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq".sha3(.sha224), "8a24108b154ada21c9fd5574494479ba5c7e7ab76ef264ead0fcce33")
        XCTAssertEqual("abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq".sha3(.sha256), "41c0dba2a9d6240849100376a8235e2c82e1b9998a999e21db32dd97496d3376")
        XCTAssertEqual("abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq".sha3(.sha384), "991c665755eb3a4b6bbdfb75c78a492e8c56a22c5c4d7e429bfdbc32b9d4ad5aa04a1f076e62fea19eef51acd0657c22")
        XCTAssertEqual("abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq".sha3(.sha512), "04a371e84ecfb5b8b77cb48610fca8182dd457ce6f326a0fd3d7ec2f1e91636dee691fbe0c985302ba1b0d8dc78c086346b533b49c030d99a27daf1139d6e75e")

        XCTAssertEqual("abcdefghbcdefghicdefghijdefghijkefghijklfghijklmghijklmnhijklmnoijklmnopjklmnopqklmnopqrlmnopqrsmnopqrstnopqrstu".sha3(.sha224), "543e6868e1666c1a643630df77367ae5a62a85070a51c14cbf665cbc")
        XCTAssertEqual("abcdefghbcdefghicdefghijdefghijkefghijklfghijklmghijklmnhijklmnoijklmnopjklmnopqklmnopqrlmnopqrsmnopqrstnopqrstu".sha3(.sha256), "916f6061fe879741ca6469b43971dfdb28b1a32dc36cb3254e812be27aad1d18")
        XCTAssertEqual("abcdefghbcdefghicdefghijdefghijkefghijklfghijklmghijklmnhijklmnoijklmnopjklmnopqklmnopqrlmnopqrsmnopqrstnopqrstu".sha3(.sha384), "79407d3b5916b59c3e30b09822974791c313fb9ecc849e406f23592d04f625dc8c709b98b43b3852b337216179aa7fc7")
        XCTAssertEqual("abcdefghbcdefghicdefghijdefghijkefghijklfghijklmghijklmnhijklmnoijklmnopjklmnopqklmnopqrlmnopqrsmnopqrstnopqrstu".sha3(.sha512), "afebb2ef542e6579c50cad06d2e578f9f8dd6881d7dc824d26360feebf18a4fa73e3261122948efcfd492e74e82e2189ed0fb440d187f382270cb455f21dd185")

        XCTAssertEqual(Array<UInt8>(repeating: 0x61, count: 1_000_000).sha3(.sha224), Array<UInt8>(hex: "d69335b93325192e516a912e6d19a15cb51c6ed5c15243e7a7fd653c"), "One million (1,000,000) repetitions of the character 'a' (0x61)")
        XCTAssertEqual(Array<UInt8>(repeating: 0x61, count: 1_000_000).sha3(.sha256), Array<UInt8>(hex: "5c8875ae474a3634ba4fd55ec85bffd661f32aca75c6d699d0cdcb6c115891c1"), "One million (1,000,000) repetitions of the character 'a' (0x61)")
        XCTAssertEqual(Array<UInt8>(repeating: 0x61, count: 1_000_000).sha3(.sha384), Array<UInt8>(hex: "eee9e24d78c1855337983451df97c8ad9eedf256c6334f8e948d252d5e0e76847aa0774ddb90a842190d2c558b4b8340"), "One million (1,000,000) repetitions of the character 'a' (0x61)")
        XCTAssertEqual(Array<UInt8>(repeating: 0x61, count: 1_000_000).sha3(.sha512), Array<UInt8>(hex: "3c3a876da14034ab60627c077bb98f7e120a2a5370212dffb3385a18d4f38859ed311d0a9d5141ce9cc5c66ee689b266a8aa18ace8282a0e0db596c90b0a7b87"), "One million (1,000,000) repetitions of the character 'a' (0x61)")
    }

    func testMD5Data() {
        let data = [0x31, 0x32, 0x33] as Array<UInt8> // "1", "2", "3"
        XCTAssertEqual(Digest.md5(data), [0x20, 0x2c, 0xb9, 0x62, 0xac, 0x59, 0x07, 0x5b, 0x96, 0x4b, 0x07, 0x15, 0x2d, 0x23, 0x4b, 0x70], "MD5 calculation failed")
    }

    func testMD5Updates() {
        do {
            var hash = MD5()
            _ = try hash.update(withBytes: [0x31, 0x32])
            _ = try hash.update(withBytes: [0x33])
            let result = try hash.finish()
            XCTAssertEqual(result, [0x20, 0x2c, 0xb9, 0x62, 0xac, 0x59, 0x07, 0x5b, 0x96, 0x4b, 0x07, 0x15, 0x2d, 0x23, 0x4b, 0x70])
        } catch {
            XCTFail()
        }
    }

    func testSHA1Updatable1() {
        do {
            var hash = SHA1()
            _ = try hash.update(withBytes: [0x31, 0x32])
            _ = try hash.update(withBytes: [0x33])
            XCTAssertEqual(try hash.finish().toHexString(), "40bd001563085fc35165329ea1ff5c5ecbdbbeef", "Failed")
        } catch {
            XCTFail()
        }
    }

    func testSHA1Updatable2() {
        do {
            var hash = SHA1()
            _ = try hash.update(withBytes: [0x31, 0x32])
            _ = try hash.update(withBytes: [0x33])
            _ = try hash.update(withBytes: Array<UInt8>(repeating: 0x33, count: 64))
            XCTAssertEqual(try hash.finish().toHexString(), "0e659367eff83a6b868a35b96ac305b270025e86", "Failed")
        } catch {
            XCTFail()
        }
    }

    func testCRC32() {
        let data: Data = Data(bytes: UnsafePointer<UInt8>([49, 50, 51] as Array<UInt8>), count: 3)
        XCTAssertEqual(data.crc32(seed: nil).toHexString(), "884863d2", "CRC32 calculation failed")

        XCTAssertEqual("".crc32(seed: nil), "00000000", "CRC32 calculation failed")
    }

    func testCRC32NotReflected() {
        let bytes: Array<UInt8> = [0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37, 0x38, 0x39]
        let data: Data = Data(bytes: UnsafePointer<UInt8>(bytes), count: bytes.count)
        XCTAssertEqual(data.crc32(seed: nil, reflect: false).toHexString(), "fc891918", "CRC32 (with reflection) calculation failed")

        XCTAssertEqual("".crc32(seed: nil, reflect: false), "00000000", "CRC32 (with reflection) calculation failed")
    }

    func testCRC16() {
        let result = Checksum.crc16([49, 50, 51, 52, 53, 54, 55, 56, 57] as Array<UInt8>)
        XCTAssert(result == 0xbb3d, "CRC16 failed")
    }

    func testChecksum() {
        let data: Data = Data(bytes: UnsafePointer<UInt8>([49, 50, 51] as Array<UInt8>), count: 3)
        XCTAssert(data.checksum() == 0x96, "Invalid checksum")
    }
}

#if !CI

    extension DigestTests {

        func testMD5Performance() {
            measureMetrics([XCTPerformanceMetric.wallClockTime], automaticallyStartMeasuring: false) {
                let arr = Array<UInt8>(repeating: 200, count: 1024 * 1024)
                self.startMeasuring()
                _ = Digest.md5(arr)
                self.stopMeasuring()
            }
        }

        func testSHA1Performance() {
            measureMetrics([XCTPerformanceMetric.wallClockTime], automaticallyStartMeasuring: false) {
                let arr = Array<UInt8>(repeating: 200, count: 1024 * 1024)
                self.startMeasuring()
                _ = Digest.sha1(arr)
                self.stopMeasuring()
            }
        }

        // Keep it to compare
        /*
        func testSHA1PerformanceCC() {
            measureMetrics([XCTPerformanceMetric.wallClockTime], automaticallyStartMeasuring: false) {
                let arr = Array<UInt8>(repeating: 200, count: 1024 * 1024)
                self.startMeasuring()
                var digest = Array<UInt8>(repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))
                CC_SHA1(arr, CC_LONG(arr.count), &digest)
                self.stopMeasuring()
            }
        }
         */
    }

#endif

extension DigestTests {

    static func allTests() -> [(String, (DigestTests) -> () -> Void)] {
        var tests = [
            ("testMD5", testMD5),
            ("testSHA1", testSHA1),
            ("testSHA2", testSHA2),
            ("testSHA3", testSHA3),
            ("testMD5Data", testMD5Data),
            ("testMD5Updates", testMD5Updates),
            ("testSHA1Updatable1", testSHA1Updatable1),
            ("testSHA1Updatable2", testSHA1Updatable2),
            ("testCRC32", testCRC32),
            ("testCRC32NotReflected", testCRC32NotReflected),
            ("testCRC16", testCRC16),
            ("testChecksum", testChecksum),
        ]

        #if !CI
            tests += [
                ("testMD5Performance", testMD5Performance),
                ("testSHA1Performance", testSHA1Performance),
            ]
        #endif

        return tests
    }
}
