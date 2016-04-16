//
//  CryptoSalsa20Test.swift
//  KdbxParser
//
//  Created by Dennis Michaelis on 27.03.16.
//  Copyright © 2016 Dennis Michaelis. All rights reserved.
//

import XCTest
import CryptoSwift

class CryptoSalsa20Test: XCTestCase {
    
    var c: Salsa20?

    override func setUp() {
        super.setUp()
        
        let pbKey: [UInt8] = [0x0F, 0x62, 0xB5, 0x08, 0x5B, 0xAE, 0x01, 0x54,
                              0xA7, 0xFA, 0x4D, 0xA0, 0xF3, 0x46, 0x99, 0xEC,
                              0x3F, 0x92, 0xE5, 0x38, 0x8B, 0xDE, 0x31, 0x84,
                              0xD7, 0x2A, 0x7D, 0xD0, 0x23, 0x76, 0xC9, 0x1C]
        let pbIV: [UInt8] = [0x28, 0x8F, 0xF6, 0x5D, 0xC4, 0x2B, 0x92, 0xF9]
        
        c = Salsa20(key: pbKey, iv: pbIV)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    /**
     Run some Tests with expected results and reset of Salsa20 cipher
     */
    func testExample() {
        //Test 1
        let pbExpected: [UInt8] = [0x5E, 0x5E, 0x71, 0xF9, 0x01, 0x99, 0x34, 0x03,
                                   0x04, 0xAB, 0xB2, 0x2A, 0x37, 0xB6, 0x62, 0x5B]
        var pb: [UInt8] = [0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                           0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]
        try! pb = (c?.encrypt(pb))!
        XCTAssertEqual(pbExpected, pb, "Salsa20 --> Test 1 failed!")
        
        //re-run Test 1 without reset
        pb = [0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
              0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]
        try! pb = (c?.encrypt(pb))!
        XCTAssertNotEqual(pbExpected, pb, "Salsa20 --> Test 1 without reset failed! Expected value should NOT expected value from Test 1")
        
        //re-run Test 1 after reset
        c?.reset()
        pb = [0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
              0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]
        try! pb = (c?.encrypt(pb))!
        XCTAssertEqual(pbExpected, pb, "Salsa20 --> Test 1 with reset failed! xpected value should expected value from Test 1")
        
        //Test 2
        var nPos = CryptoSalsa20Test.salsa20ToPos(c!, nPos: pb.count, nTargetPos: 65536);
        
        let pbExpected2: [UInt8] = [0xAB, 0xF3, 0x9A, 0x21, 0x0E, 0xEE, 0x89, 0x59,
                                    0x8B, 0x71, 0x33, 0x37, 0x70, 0x56, 0xC2, 0xFE]
        pb = [UInt8](count: 16,  repeatedValue: 0)
        try! pb = (c?.encrypt(pb))!
        XCTAssertEqual(pbExpected2, pb, "Salsa20 --> Test 2 failed!")
        
        //Test 3
        let pbExpected3: [UInt8] = [0x1B, 0xA8, 0x9D, 0xBD, 0x3F, 0x98, 0x83, 0x97,
                                    0x28, 0xF5, 0x67, 0x91, 0xD5, 0xB7, 0xCE, 0x23]
        
        nPos = CryptoSalsa20Test.salsa20ToPos(c!, nPos: nPos + pb.count, nTargetPos: 131008);
        pb = [UInt8](count: 16,  repeatedValue: 0)
        try! pb = (c?.encrypt(pb))!
        
        XCTAssertEqual(pbExpected3, pb, "Salsa20  --> Test 3 failed!");
        
        //reset cipher for more tests
        c!.reset()
    }
    
    /**
     Disabled Test, should run very, very long, until reached 1.18059162 Zettabytes
     */
    func disabled_testLimitExceeded() {
        let pb = [UInt8](count: 4096*1024, repeatedValue: 0)
        
        //define a clean start
        c!.reset()
        
        //count needed rounds until buffer before buffer reaches limit
        let roundsOkCount = Int(pow(2.0, 70.0)/Double(pb.count)-1)
        
        for _ in 0..<roundsOkCount {
            try! c?.encrypt(pb)
        }
        XCTAssertTrue(true, "All until here ok")
        
        //run one again to reach limit of cipher, which should throw an eception
        do {
            try c!.encrypt(pb)
            XCTFail("Salsa20 sould had thrown a Limit exceeded Exception")
        } catch Salsa20.Error.LimitOfNonceExceeded {
            XCTAssertTrue(true, "Limit is correctly exceeded")
        } catch {
            XCTFail("Salsa20 sould had thrown a Limit exceeded Exception")
        }
    }
    
    /**
     Test based on Test-Vector-File of "ECRYPT Stream Cipher Project"
     */
    func testVectors() {
        //load Test-Vectors from file
        let testVectors = loadTestVectors()
        
        //Test all Test-Vectors
        for i in 0..<testVectors.count {
            let vector = testVectors[i]
            
            //initialize new Salsa20 cipher
            self.c = Salsa20(key: vector.key, iv: vector.iv)
            var pb = [UInt8](count: vector.stream4Pos.endIndex+1,  repeatedValue: 0)
            //lets encrypt
            try! pb = (self.c?.encrypt(pb))!
            XCTAssertEqual(vector.stream1, Array(pb[vector.stream1Pos]), "Test: \(vector.name) - Stream 1 does not Equals")
            XCTAssertEqual(vector.stream2, Array(pb[vector.stream2Pos]), "Test: \(vector.name) - Stream 2 does not Equals")
            XCTAssertEqual(vector.stream3, Array(pb[vector.stream3Pos]), "Test: \(vector.name) - Stream 3 does not Equals")
            XCTAssertEqual(vector.stream4, Array(pb[vector.stream4Pos]), "Test: \(vector.name) - Stream 4 does not Equals")
            
            //build XOR of complete cipher block
            let xorDigits = self.generateXorDigits(pb, blockSize: vector.xorDigits.count)
            XCTAssertEqual(vector.xorDigits, xorDigits, "Test: \(vector.name) - XOR-Digits does not Equals")
        }
    }
    
    /**
     Run a performance test
     */
    func testSalsa20Performance() {
        let key:[UInt8] = [0x2b,0x7e,0x15,0x16,0x28,0xae,0xd2,0xa6,0xab,0xf7,0x15,0x88,0x09,0xcf,0x4f,0x3c];
        let iv:[UInt8] = [0x00,0x01,0x02,0x03,0x04,0x05,0x06,0x07,0x08,0x09,0x0A,0x0B,0x0C,0x0D,0x0E,0x0F]
        let message = [UInt8](count: (1024 * 1024) * 1, repeatedValue: 7)
        measureMetrics([XCTPerformanceMetric_WallClockTime], automaticallyStartMeasuring: true, forBlock: { () -> Void in
            let encrypted = try! Salsa20(key: key, iv: iv)?.encrypt(message)
            self.stopMeasuring()
            XCTAssert(encrypted != nil, "not encrypted")
        })
    }
    
    /* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
     * Helper Functions
     * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
    
    /**
     Run Sasla20 cipher some rounds with random buffer sizes to a defined position
     
     - parameter c:          The Salsa20 cipher
     - parameter nPos:       Define the start position
     - parameter nTargetPos: Define the end position
     
     - returns: return the end defnied position
     */
    internal static func salsa20ToPos(c: Salsa20, nPos: Int, nTargetPos: Int) -> Int {
        var tmp = nPos
        //run until defined positon is reached
        while(tmp < nTargetPos) {
            //create a random buffer size
            let x = Int(arc4random_uniform(513))
            //check if random buffer size is greater then defined position, and cut it off to defined position
            let nGen = min(nTargetPos - tmp, x)
            //create buffer of random size with 0 filles
            var pb = [UInt8](count:nGen, repeatedValue: 0)
            //encrypt and run Salsa20 cipher to the defined position
            try! pb = c.encrypt(pb)
            //save run size
            tmp += nGen
        }
        return nTargetPos
    }

    /**
     Helper function which load the Test-Vector-Data from a File
     
     - returns: Returns the data as an array of SalsaTestVector
     */
    private func loadTestVectors() -> [SalsaTestVector] {
        var ret: [SalsaTestVector] = []
        //Parse test vector file via RegEx
        let testVectorPattern: String = "(?sm)(Set\\s\\d+,\\svector#\\s*\\d+:)$\\s+?key\\s=\\s([0-9A-F]{32,32}$(?:\\s+[0-9A-F]{32,32}$)?)\\s+IV\\s=\\s([0-9A-F]{16,16}$)\\s+stream\\[(\\d+\\.\\.\\d+)\\]\\s=((?:\\s+[0-9A-F]{32,32}$){4,4})\\s+stream\\[(\\d+\\.\\.\\d+)\\]\\s=((?:\\s+[0-9A-F]{32,32}$){4,4})\\s+stream\\[(\\d+\\.\\.\\d+)\\]\\s=((?:\\s+[0-9A-F]{32,32}$){4,4})\\s+stream\\[(\\d+\\.\\.\\d+)\\]\\s=((?:\\s+[0-9A-F]{32,32}$){4,4})\\s+xor-digest\\s=((?:\\s+[0-9A-F]{32,32}$){4,4})"
        let bundle = NSBundle(forClass: self.dynamicType)
        let vectorFileName = bundle.pathForResource("verified.salsa20.test-vectors", ofType: "txt")!
        
        do {
            let vectorFile = try NSString(contentsOfFile: vectorFileName, encoding: NSASCIIStringEncoding)
            let regex = try NSRegularExpression(pattern: testVectorPattern, options: [.CaseInsensitive])
            let matches = regex.matchesInString(vectorFile as String, options: [], range: NSMakeRange(0, vectorFile.length))
            
            if matches.count > 0 {
                //create for every match an object
                for match in matches {
                    let testVectorName = vectorFile.substringWithRange(match.rangeAtIndex(1))
                    let key = String(vectorFile.substringWithRange(match.rangeAtIndex(2)).characters.filter({![" ","\n","\r"].contains($0)}))
                    let iv = String(vectorFile.substringWithRange(match.rangeAtIndex(3)).characters.filter({![" ","\n","\r"].contains($0)}))
                    let stream1Pos = vectorFile.substringWithRange(match.rangeAtIndex(4))
                    let stream1 = String(vectorFile.substringWithRange(match.rangeAtIndex(5)).characters.filter({![" ","\n","\r"].contains($0)}))
                    let stream2Pos = vectorFile.substringWithRange(match.rangeAtIndex(6))
                    let stream2 = String(vectorFile.substringWithRange(match.rangeAtIndex(7)).characters.filter({![" ","\n","\r"].contains($0)}))
                    let stream3Pos = vectorFile.substringWithRange(match.rangeAtIndex(8))
                    let stream3 = String(vectorFile.substringWithRange(match.rangeAtIndex(9)).characters.filter({![" ","\n","\r"].contains($0)}))
                    let stream4Pos = vectorFile.substringWithRange(match.rangeAtIndex(10))
                    let stream4 = String(vectorFile.substringWithRange(match.rangeAtIndex(11)).characters.filter({![" ","\n","\r"].contains($0)}))
                    let xorDigists = String(vectorFile.substringWithRange(match.rangeAtIndex(12)).characters.filter({![" ","\n","\r"].contains($0)}))
                    
                    ret.append(SalsaTestVector(name: testVectorName, key: key, iv: iv, stream1Pos: stream1Pos, stream1: stream1,
                                               stream2Pos: stream2Pos, stream2: stream2, stream3Pos: stream3Pos, stream3: stream3,
                                               stream4Pos: stream4Pos, stream4: stream4, xorDigits: xorDigists))
                    
                }
            }
        } catch {
            XCTFail("Failed to load Test-Vector-File \"\(vectorFileName)\". \(error)")
        }
        return ret
    }

    /**
     Helper function to create a XOR array of an defined block size
     
     - parameter data: The data which will be XORed
     - parameter size: The size of the XOR array
     
     - returns: Return an array of the defined block size with the XORed data
     */
    private func generateXorDigits(data: [UInt8], blockSize size: Int) -> [UInt8] {
        var ret = [UInt8](count: size, repeatedValue: 0)
        
        for i in 0..<data.count/size {
            //initialize the chunk index positions
            let startIdx = i*size
            var endIdx = i*size+size
            if endIdx > data.count {
                endIdx = data.count
            }
            
            //load a data chunk of the block size from the data
            let chunk = data[startIdx..<endIdx]
            
            //create the xor data block
            for i in 0..<ret.count {
                ret[i] ^= chunk[i+startIdx]
            }
        }
        
        return ret
    }
    
    /**
     *  A data structure to represent a Test-Vector of the Test-Vector data file
     */
    private struct SalsaTestVector {
        let name: String
        let key: [UInt8]
        let iv: [UInt8]
        let stream1Pos: Range<Int>
        let stream1: [UInt8]
        let stream2Pos: Range<Int>
        let stream2: [UInt8]
        let stream3Pos: Range<Int>
        let stream3: [UInt8]
        let stream4Pos: Range<Int>
        let stream4: [UInt8]
        let xorDigits: [UInt8]
        
        /**
         Initialize the data structure
         
         - parameter name:       The name of the Test-Case
         - parameter key:        The key for the Salsa20 test
         - parameter iv:         The Initial Vector for the Salsa20 test
         - parameter stream1Pos: The position of the data chunk of stream1
         - parameter stream1:    The first data chunk of the encrypted data
         - parameter stream2Pos: The position of the data chunk of stream2
         - parameter stream2:    The second data chunk of the encrypted data
         - parameter stream3Pos: The position of the data chunk of stream3
         - parameter stream3:    The third data chunk of the encrypted data
         - parameter stream4Pos: The position of the data chunk of stream4
         - parameter stream4:    The fourth data chunk of the encrypted data
         - parameter xorDigits:  The XOR representation of the complete encrypted data
         
         - returns: The initialized data structure
         */
        init(name: String, let key: String, iv: String, stream1Pos: String, stream1: String,
             stream2Pos: String, stream2: String, stream3Pos: String, stream3: String,
             stream4Pos: String, stream4: String, xorDigits: String) {
            self.name = name
            self.key = CryptoSalsa20Test.SalsaTestVector.hexToUInt8Array(key)
            self.iv = CryptoSalsa20Test.SalsaTestVector.hexToUInt8Array(iv)
            self.stream1Pos = CryptoSalsa20Test.SalsaTestVector.strToRange(stream1Pos)
            self.stream1 = CryptoSalsa20Test.SalsaTestVector.hexToUInt8Array(stream1)
            self.stream2Pos = CryptoSalsa20Test.SalsaTestVector.strToRange(stream2Pos)
            self.stream2 = CryptoSalsa20Test.SalsaTestVector.hexToUInt8Array(stream2)
            self.stream3Pos = CryptoSalsa20Test.SalsaTestVector.strToRange(stream3Pos)
            self.stream3 = CryptoSalsa20Test.SalsaTestVector.hexToUInt8Array(stream3)
            self.stream4Pos = CryptoSalsa20Test.SalsaTestVector.strToRange(stream4Pos)
            self.stream4 = CryptoSalsa20Test.SalsaTestVector.hexToUInt8Array(stream4)
            self.xorDigits = CryptoSalsa20Test.SalsaTestVector.hexToUInt8Array(xorDigits)
        }
        
        /**
         Convert a hexadecimal String to an UInt8-Byte-Array
         
         - parameter hexStr: A hex String which will be converted
         
         - returns: Returns the UInt8-Byte-Array of the hexadecimal String data
         */
        static func hexToUInt8Array(hexStr: String) -> [UInt8] {
            if (hexStr.characters.count % 2) != 0 {
                XCTFail("Hex-String count not even: \(hexStr)")
            }
            var ret = [UInt8](count: hexStr.characters.count/2, repeatedValue: 0)
            
            var tmp = hexStr.characters
            for i in 0..<ret.count {
                let hex = String(tmp.popFirst()!)+String(tmp.popFirst()!)
                ret[i] = UInt8(hex,radix: 16)!
            }
            return ret
        }
        
        /**
         Convert a String of the format <Number>..<Number> into a Range of Int
         
         - parameter rangeStr: The String with a Range definition
         
         - returns: The Range of Int from the String
         */
        static func strToRange(rangeStr: String) -> Range<Int> {
            var ret: Range<Int>
            
            let splitStr = rangeStr.componentsSeparatedByString("..")
            ret = Range<Int>(Int(splitStr[0])!...Int(splitStr[1])!)
            
            return ret
        }
    }

}
