//
//  AES.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 21/11/14.
//  Copyright (c) 2014 Marcin Krzyzanowski. All rights reserved.
//

import Foundation

final public class AES {
    
    public enum AESVariant:Int {
        case aes128 = 1, aes192, aes256
        
        var Nk:Int { // Nk words
            return [4,6,8][self.rawValue - 1]
        }
        
        var Nb:Int { // Nb words
            return 4
        }
        
        var Nr:Int { // Nr
            return Nk + 6
        }
    }
    
    public let blockMode:CipherBlockMode
    public static let blockSize:Int = 16 // 128 /8
    
    public var variant:AESVariant {
        switch (self.key.count * 8) {
        case 128:
            return .aes128
        case 192:
            return .aes192
        case 256:
            return .aes256
        default:
            preconditionFailure("Unknown AES variant for given key.")
        }
    }
    private let key:[UInt8]
    private let iv:[UInt8]?
    public lazy var expandedKey:[UInt8] = { AES.expandKey(self.key, variant: self.variant) }()
    
    static private let sBox:[UInt8] = [
        0x63, 0x7c, 0x77, 0x7b, 0xf2, 0x6b, 0x6f, 0xc5, 0x30, 0x01, 0x67, 0x2b, 0xfe, 0xd7, 0xab, 0x76, 
        0xca, 0x82, 0xc9, 0x7d, 0xfa, 0x59, 0x47, 0xf0, 0xad, 0xd4, 0xa2, 0xaf, 0x9c, 0xa4, 0x72, 0xc0, 
        0xb7, 0xfd, 0x93, 0x26, 0x36, 0x3f, 0xf7, 0xcc, 0x34, 0xa5, 0xe5, 0xf1, 0x71, 0xd8, 0x31, 0x15, 
        0x04, 0xc7, 0x23, 0xc3, 0x18, 0x96, 0x05, 0x9a, 0x07, 0x12, 0x80, 0xe2, 0xeb, 0x27, 0xb2, 0x75, 
        0x09, 0x83, 0x2c, 0x1a, 0x1b, 0x6e, 0x5a, 0xa0, 0x52, 0x3b, 0xd6, 0xb3, 0x29, 0xe3, 0x2f, 0x84, 
        0x53, 0xd1, 0x00, 0xed, 0x20, 0xfc, 0xb1, 0x5b, 0x6a, 0xcb, 0xbe, 0x39, 0x4a, 0x4c, 0x58, 0xcf, 
        0xd0, 0xef, 0xaa, 0xfb, 0x43, 0x4d, 0x33, 0x85, 0x45, 0xf9, 0x02, 0x7f, 0x50, 0x3c, 0x9f, 0xa8, 
        0x51, 0xa3, 0x40, 0x8f, 0x92, 0x9d, 0x38, 0xf5, 0xbc, 0xb6, 0xda, 0x21, 0x10, 0xff, 0xf3, 0xd2, 
        0xcd, 0x0c, 0x13, 0xec, 0x5f, 0x97, 0x44, 0x17, 0xc4, 0xa7, 0x7e, 0x3d, 0x64, 0x5d, 0x19, 0x73, 
        0x60, 0x81, 0x4f, 0xdc, 0x22, 0x2a, 0x90, 0x88, 0x46, 0xee, 0xb8, 0x14, 0xde, 0x5e, 0x0b, 0xdb, 
        0xe0, 0x32, 0x3a, 0x0a, 0x49, 0x06, 0x24, 0x5c, 0xc2, 0xd3, 0xac, 0x62, 0x91, 0x95, 0xe4, 0x79, 
        0xe7, 0xc8, 0x37, 0x6d, 0x8d, 0xd5, 0x4e, 0xa9, 0x6c, 0x56, 0xf4, 0xea, 0x65, 0x7a, 0xae, 0x08, 
        0xba, 0x78, 0x25, 0x2e, 0x1c, 0xa6, 0xb4, 0xc6, 0xe8, 0xdd, 0x74, 0x1f, 0x4b, 0xbd, 0x8b, 0x8a, 
        0x70, 0x3e, 0xb5, 0x66, 0x48, 0x03, 0xf6, 0x0e, 0x61, 0x35, 0x57, 0xb9, 0x86, 0xc1, 0x1d, 0x9e, 
        0xe1, 0xf8, 0x98, 0x11, 0x69, 0xd9, 0x8e, 0x94, 0x9b, 0x1e, 0x87, 0xe9, 0xce, 0x55, 0x28, 0xdf, 
        0x8c, 0xa1, 0x89, 0x0d, 0xbf, 0xe6, 0x42, 0x68, 0x41, 0x99, 0x2d, 0x0f, 0xb0, 0x54, 0xbb, 0x16]
    
    static private let invSBox:[UInt8] = [
        0x52, 0x09, 0x6a, 0xd5, 0x30, 0x36, 0xa5, 0x38, 0xbf, 0x40, 0xa3,
        0x9e, 0x81, 0xf3, 0xd7, 0xfb, 0x7c, 0xe3, 0x39, 0x82, 0x9b, 0x2f,
        0xff, 0x87, 0x34, 0x8e, 0x43, 0x44, 0xc4, 0xde, 0xe9, 0xcb, 0x54,
        0x7b, 0x94, 0x32, 0xa6, 0xc2, 0x23, 0x3d, 0xee, 0x4c, 0x95, 0x0b,
        0x42, 0xfa, 0xc3, 0x4e, 0x08, 0x2e, 0xa1, 0x66, 0x28, 0xd9, 0x24,
        0xb2, 0x76, 0x5b, 0xa2, 0x49, 0x6d, 0x8b, 0xd1, 0x25, 0x72, 0xf8,
        0xf6, 0x64, 0x86, 0x68, 0x98, 0x16, 0xd4, 0xa4, 0x5c, 0xcc, 0x5d,
        0x65, 0xb6, 0x92, 0x6c, 0x70, 0x48, 0x50, 0xfd, 0xed, 0xb9, 0xda,
        0x5e, 0x15, 0x46, 0x57, 0xa7, 0x8d, 0x9d, 0x84, 0x90, 0xd8, 0xab,
        0x00, 0x8c, 0xbc, 0xd3, 0x0a, 0xf7, 0xe4, 0x58, 0x05, 0xb8, 0xb3,
        0x45, 0x06, 0xd0, 0x2c, 0x1e, 0x8f, 0xca, 0x3f, 0x0f, 0x02, 0xc1,
        0xaf, 0xbd, 0x03, 0x01, 0x13, 0x8a, 0x6b, 0x3a, 0x91, 0x11, 0x41,
        0x4f, 0x67, 0xdc, 0xea, 0x97, 0xf2, 0xcf, 0xce, 0xf0, 0xb4, 0xe6,
        0x73, 0x96, 0xac, 0x74, 0x22, 0xe7, 0xad, 0x35, 0x85, 0xe2, 0xf9,
        0x37, 0xe8, 0x1c, 0x75, 0xdf, 0x6e, 0x47, 0xf1, 0x1a, 0x71, 0x1d,
        0x29, 0xc5, 0x89, 0x6f, 0xb7, 0x62, 0x0e, 0xaa, 0x18, 0xbe, 0x1b,
        0xfc, 0x56, 0x3e, 0x4b, 0xc6, 0xd2, 0x79, 0x20, 0x9a, 0xdb, 0xc0,
        0xfe, 0x78, 0xcd, 0x5a, 0xf4, 0x1f, 0xdd, 0xa8, 0x33, 0x88, 0x07,
        0xc7, 0x31, 0xb1, 0x12, 0x10, 0x59, 0x27, 0x80, 0xec, 0x5f, 0x60,
        0x51, 0x7f, 0xa9, 0x19, 0xb5, 0x4a, 0x0d, 0x2d, 0xe5, 0x7a, 0x9f,
        0x93, 0xc9, 0x9c, 0xef, 0xa0, 0xe0, 0x3b, 0x4d, 0xae, 0x2a, 0xf5,
        0xb0, 0xc8, 0xeb, 0xbb, 0x3c, 0x83, 0x53, 0x99, 0x61, 0x17, 0x2b,
        0x04, 0x7e, 0xba, 0x77, 0xd6, 0x26, 0xe1, 0x69, 0x14, 0x63, 0x55,
        0x21, 0x0c, 0x7d]
    
    // Parameters for Linear Congruence Generators
    static private let Rcon:[UInt8] = [
        0x8d, 0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80, 0x1b, 0x36, 0x6c, 0xd8, 0xab, 0x4d, 0x9a,
        0x2f, 0x5e, 0xbc, 0x63, 0xc6, 0x97, 0x35, 0x6a, 0xd4, 0xb3, 0x7d, 0xfa, 0xef, 0xc5, 0x91, 0x39,
        0x72, 0xe4, 0xd3, 0xbd, 0x61, 0xc2, 0x9f, 0x25, 0x4a, 0x94, 0x33, 0x66, 0xcc, 0x83, 0x1d, 0x3a,
        0x74, 0xe8, 0xcb, 0x8d, 0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80, 0x1b, 0x36, 0x6c, 0xd8,
        0xab, 0x4d, 0x9a, 0x2f, 0x5e, 0xbc, 0x63, 0xc6, 0x97, 0x35, 0x6a, 0xd4, 0xb3, 0x7d, 0xfa, 0xef,
        0xc5, 0x91, 0x39, 0x72, 0xe4, 0xd3, 0xbd, 0x61, 0xc2, 0x9f, 0x25, 0x4a, 0x94, 0x33, 0x66, 0xcc,
        0x83, 0x1d, 0x3a, 0x74, 0xe8, 0xcb, 0x8d, 0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80, 0x1b,
        0x36, 0x6c, 0xd8, 0xab, 0x4d, 0x9a, 0x2f, 0x5e, 0xbc, 0x63, 0xc6, 0x97, 0x35, 0x6a, 0xd4, 0xb3,
        0x7d, 0xfa, 0xef, 0xc5, 0x91, 0x39, 0x72, 0xe4, 0xd3, 0xbd, 0x61, 0xc2, 0x9f, 0x25, 0x4a, 0x94,
        0x33, 0x66, 0xcc, 0x83, 0x1d, 0x3a, 0x74, 0xe8, 0xcb, 0x8d, 0x01, 0x02, 0x04, 0x08, 0x10, 0x20,
        0x40, 0x80, 0x1b, 0x36, 0x6c, 0xd8, 0xab, 0x4d, 0x9a, 0x2f, 0x5e, 0xbc, 0x63, 0xc6, 0x97, 0x35,
        0x6a, 0xd4, 0xb3, 0x7d, 0xfa, 0xef, 0xc5, 0x91, 0x39, 0x72, 0xe4, 0xd3, 0xbd, 0x61, 0xc2, 0x9f,
        0x25, 0x4a, 0x94, 0x33, 0x66, 0xcc, 0x83, 0x1d, 0x3a, 0x74, 0xe8, 0xcb, 0x8d, 0x01, 0x02, 0x04,
        0x08, 0x10, 0x20, 0x40, 0x80, 0x1b, 0x36, 0x6c, 0xd8, 0xab, 0x4d, 0x9a, 0x2f, 0x5e, 0xbc, 0x63,
        0xc6, 0x97, 0x35, 0x6a, 0xd4, 0xb3, 0x7d, 0xfa, 0xef, 0xc5, 0x91, 0x39, 0x72, 0xe4, 0xd3, 0xbd,
        0x61, 0xc2, 0x9f, 0x25, 0x4a, 0x94, 0x33, 0x66, 0xcc, 0x83, 0x1d, 0x3a, 0x74, 0xe8, 0xcb, 0x8d]
    
    public init?(key:[UInt8], iv:[UInt8], blockMode:CipherBlockMode = .CBC) {
        self.key = key
        self.iv = iv
        self.blockMode = blockMode
        
        if (blockMode.needIV && iv.count != AES.blockSize) {
            assert(false, "Block size and Initialization Vector must be the same length!")
            return nil
        }
    }
    
    convenience public init?(key:[UInt8], blockMode:CipherBlockMode = .CBC) {
        // default IV is all 0x00...
        let defaultIV = [UInt8](count: AES.blockSize, repeatedValue: 0)
        self.init(key: key, iv: defaultIV, blockMode: blockMode)
    }
    
    convenience public init?(key:String, iv:String, blockMode:CipherBlockMode = .CBC) {
        if let kkey = key.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)?.arrayOfBytes(), let iiv = iv.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)?.arrayOfBytes() {
            self.init(key: kkey, iv: iiv, blockMode: blockMode)
        } else {
            self.init(key: [UInt8](), iv: [UInt8](), blockMode: blockMode) //FIXME: this is due Swift bug, remove this line later, when fixed
            return nil
        }
    }
    
    /**
    Encrypt message. If padding is necessary, then PKCS7 padding is added and needs to be removed after decryption.
    
    :param: message Plaintext data
    
    :returns: Encrypted data
    */

    public func encrypt(bytes:[UInt8], padding:Padding? = PKCS7()) -> [UInt8]? {
        var finalBytes = bytes;

        if let padding = padding {
            finalBytes = padding.add(bytes, blockSize: AES.blockSize)
        } else if (bytes.count % AES.blockSize != 0) {
            assert(false, "AES block size exceeded!");
            return nil
        }

        let blocks = finalBytes.chunks(AES.blockSize) // 0.34
        return blockMode.encryptBlocks(blocks, iv: self.iv, cipherOperation: encryptBlock)
    }
    
    private func encryptBlock(block:[UInt8]) -> [UInt8]? {
        var out:[UInt8] = [UInt8]()
        
        autoreleasepool { () -> () in
            var state:[[UInt8]] = [[UInt8]](count: variant.Nb, repeatedValue: [UInt8](count: variant.Nb, repeatedValue: 0))
            for (i, row) in enumerate(state) {
                for (j, val) in enumerate(row) {
                    state[j][i] = block[i * row.count + j]
                }
            }
            
            state = addRoundKey(state,expandedKey, 0)
            
            for roundCount in 1..<variant.Nr {
                subBytes(&state)
                state = shiftRows(state)
                state = mixColumns(state)
                state = addRoundKey(state, expandedKey, roundCount)
            }
            
            subBytes(&state)
            state = shiftRows(state)
            state = addRoundKey(state, expandedKey, variant.Nr)


            out = [UInt8](count: state.count * state.first!.count, repeatedValue: 0)
            for i in 0..<state.count {
                for j in 0..<state[i].count {
                    out[(i * 4) + j] = state[j][i]
                }
            }
        }
        return out
    }
    
    public func decrypt(bytes:[UInt8], padding:Padding? = PKCS7()) -> [UInt8]? {
        if (bytes.count % AES.blockSize != 0) {
            assert(false,"AES block size exceeded!")
            return nil
        }
        
        let blocks = bytes.chunks(AES.blockSize)
        let out:[UInt8]?
        if (blockMode == .CFB) {
            // CFB uses encryptBlock to decrypt
            out = blockMode.decryptBlocks(blocks, iv: self.iv, cipherOperation: encryptBlock)
        } else {
            out = blockMode.decryptBlocks(blocks, iv: self.iv, cipherOperation: decryptBlock)
        }
        
        if let out = out, let padding = padding {
            return padding.remove(out, blockSize: nil)
        }
        
        return out;
    }
    
    private func decryptBlock(block:[UInt8]) -> [UInt8]? {
        var state:[[UInt8]] = [[UInt8]](count: variant.Nb, repeatedValue: [UInt8](count: variant.Nb, repeatedValue: 0))
        for (i, row) in enumerate(state) {
            for (j, val) in enumerate(row) {
                state[j][i] = block[i * row.count + j]
            }
        }
        
        state = addRoundKey(state,expandedKey, variant.Nr)
        
        for roundCount in reverse(1..<variant.Nr) {
            state = invShiftRows(state)
            state = invSubBytes(state)
            state = addRoundKey(state, expandedKey, roundCount)
            state = invMixColumns(state)
        }
        
        state = invShiftRows(state)
        state = invSubBytes(state)
        state = addRoundKey(state, expandedKey, 0)
        
        var out:[UInt8] = [UInt8]()
        for i in 0..<state.count {
            for j in 0..<state[0].count {
                out.append(state[j][i])
            }
        }
        
        return out
    }
    
    static private func expandKey(key:[UInt8], variant:AESVariant) -> [UInt8] {
        
        /*
        * Function used in the Key Expansion routine that takes a four-byte
        * input word and applies an S-box to each of the four bytes to
        * produce an output word.
        */
        func subWord(word:[UInt8]) -> [UInt8] {
            var result = word
            for i in 0..<4 {
                result[i] = self.sBox[Int(word[i])]
            }
            return result
        }

        var w = [UInt8](count: variant.Nb * (variant.Nr + 1) * 4, repeatedValue: 0)
        for i in 0..<variant.Nk {
            for wordIdx in 0..<4 {
                w[(4*i)+wordIdx] = key[(4*i)+wordIdx]
            }
        }
        
        var tmp:[UInt8]
        for (var i = variant.Nk; i < variant.Nb * (variant.Nr + 1); i++) {
            tmp = [UInt8](count: 4, repeatedValue: 0)
            
            for wordIdx in 0..<4 {
                tmp[wordIdx] = w[4*(i-1)+wordIdx]
            }
            if ((i % variant.Nk) == 0) {
                let rotWord = rotateLeft(UInt32.withBytes(tmp), 8).bytes(sizeof(UInt32)) // RotWord
                tmp = subWord(rotWord)
                tmp[0] = tmp[0] ^ Rcon[i/variant.Nk]
            } else if (variant.Nk > 6 && (i % variant.Nk) == 4) {
                tmp = subWord(tmp)
            }

            // xor array of bytes
            for wordIdx in 0..<4 {
                w[4*i+wordIdx] = w[4*(i-variant.Nk)+wordIdx]^tmp[wordIdx];
            }
        }
        return w;
    }
}

extension AES {
    
    // byte substitution with table (S-box)
    public func subBytes(inout state:[[UInt8]]) {
        for (i,row) in enumerate(state) {
            for (j,value) in enumerate(row) {
                state[i][j] = AES.sBox[Int(value)]
            }
        }
    }
    
    public func invSubBytes(state:[[UInt8]]) -> [[UInt8]] {
        var result = state
        for (i,row) in enumerate(state) {
            for (j,value) in enumerate(row) {
                result[i][j] = AES.invSBox[Int(value)]
            }
        }
        return result
    }
    
    // Applies a cyclic shift to the last 3 rows of a state matrix.
    public func shiftRows(state:[[UInt8]]) -> [[UInt8]] {
        var result = state
        for r in 1..<4 {
            for c in 0..<variant.Nb {
                result[r][c] = state[r][(c + r) % variant.Nb]
            }
        }
        return result
    }
    
    public func invShiftRows(state:[[UInt8]]) -> [[UInt8]] {
        var result = state
        for r in 1..<4 {
            for c in 0..<variant.Nb {
                result[r][(c + r) % variant.Nb] = state[r][c]
            }
        }
        return result
    }
    
    // Multiplies two polynomials
    public func multiplyPolys(a:UInt8, _ b:UInt8) -> UInt8 {
        var a = a, b = b
        var p:UInt8 = 0, hbs:UInt8 = 0
        
        for i in 0..<8 {
            if (b & 1 == 1) {
                p ^= a
            }
            hbs = a & 0x80
            a <<= 1
            if (hbs > 0) {
                a ^= 0x1B
            }
            b >>= 1
        }
        return p
    }
    
    public func matrixMultiplyPolys(matrix:[[UInt8]], _ array:[UInt8]) -> [UInt8] {
        var returnArray:[UInt8] = [UInt8](count: array.count, repeatedValue: 0)
        for (i, row) in enumerate(matrix) {
            for (j, boxVal) in enumerate(row) {
                returnArray[i] = multiplyPolys(boxVal, array[j]) ^ returnArray[i]
            }
        }
        return returnArray
    }

    public func addRoundKey(state:[[UInt8]], _ expandedKeyW:[UInt8], _ round:Int) -> [[UInt8]] {
        var newState = [[UInt8]](count: state.count, repeatedValue: [UInt8](count: variant.Nb, repeatedValue: 0))
        let idxRow = 4*variant.Nb*round
        for c in 0..<variant.Nb {
            let idxCol = variant.Nb*c
            newState[0][c] = state[0][c] ^ expandedKeyW[idxRow+idxCol+0]
            newState[1][c] = state[1][c] ^ expandedKeyW[idxRow+idxCol+1]
            newState[2][c] = state[2][c] ^ expandedKeyW[idxRow+idxCol+2]
            newState[3][c] = state[3][c] ^ expandedKeyW[idxRow+idxCol+3]
        }
        return newState
    }
    
    // mixes data (independently of one another)
    public func mixColumns(state:[[UInt8]]) -> [[UInt8]] {
        var state = state
        var colBox:[[UInt8]] = [[2,3,1,1],[1,2,3,1],[1,1,2,3],[3,1,1,2]]
        
        var rowMajorState = [[UInt8]](count: state.count, repeatedValue: [UInt8](count: state.first!.count, repeatedValue: 0)) //state.map({ val -> [UInt8] in return val.map { _ in return 0 } }) // zeroing
        var newRowMajorState = rowMajorState
        
        for i in 0..<state.count {
            for j in 0..<state[0].count {
                rowMajorState[j][i] = state[i][j]
            }
        }
        
        for (i, row) in enumerate(rowMajorState) {
            newRowMajorState[i] = matrixMultiplyPolys(colBox, row)
        }
        
        for i in 0..<state.count {
            for j in 0..<state[0].count {
                state[i][j] = newRowMajorState[j][i]
            }
        }
        
        return state
    }
    
    public func invMixColumns(state:[[UInt8]]) -> [[UInt8]] {
        var state = state
        var invColBox:[[UInt8]] = [[14,11,13,9],[9,14,11,13],[13,9,14,11],[11,13,9,14]]
        
        var colOrderState = state.map({ val -> [UInt8] in return val.map { _ in return 0 } }) // zeroing
        
        for i in 0..<state.count {
            for j in 0..<state[0].count {
                colOrderState[j][i] = state[i][j]
            }
        }
        
        var newState = state.map({ val -> [UInt8] in return val.map { _ in return 0 } })
        
        for (i, row) in enumerate(colOrderState) {
            newState[i] = matrixMultiplyPolys(invColBox, row)
        }
        
        for i in 0..<state.count {
            for j in 0..<state[0].count {
                state[i][j] = newState[j][i]
            }
        }
        
        return state
    }
}