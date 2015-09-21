//
//  AES.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 21/11/14.
//  Copyright (c) 2014 Marcin Krzyzanowski. All rights reserved.
//

import Foundation

final public class AES {
    
    enum Error: ErrorType {
        case BlockSizeExceeded
    }
    
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
    public lazy var expandedKey:[UInt8] = { self.expandKey(self.key, variant: self.variant) }()
    
    private lazy var sBoxes:(sBox:[UInt8], invSBox:[UInt8]) = self.calculateSBox()
    private lazy var sBox:[UInt8] = self.sBoxes.sBox
    private lazy var invSBox:[UInt8] = self.sBoxes.invSBox
    
    // Parameters for Linear Congruence Generators
    private let Rcon:[UInt8] = [
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
        }
        else {
            return nil
        }
    }
    
    /**
    Encrypt message. If padding is necessary, then PKCS7 padding is added and needs to be removed after decryption.
    
    - parameter message: Plaintext data
    
    - returns: Encrypted data
    */
    
    public func encrypt(bytes:[UInt8], padding:Padding? = PKCS7()) throws -> [UInt8] {
        var finalBytes = bytes;
        
        if let padding = padding {
            finalBytes = padding.add(bytes, blockSize: AES.blockSize)
        } else if bytes.count % AES.blockSize != 0 {
            throw Error.BlockSizeExceeded
        }
        
        let blocks = finalBytes.chunks(AES.blockSize) // 0.34
        return try blockMode.encryptBlocks(blocks, iv: self.iv, cipherOperation: encryptBlock)
    }
    
    private func encryptBlock(block:[UInt8]) -> [UInt8]? {
        var out:[UInt8] = [UInt8]()
        
        autoreleasepool { () -> () in
            var state:[[UInt8]] = [[UInt8]](count: variant.Nb, repeatedValue: [UInt8](count: variant.Nb, repeatedValue: 0))
            for (i, row) in state.enumerate() {
                for (j, _) in row.enumerate() {
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
    
    public func decrypt(bytes:[UInt8], padding:Padding? = PKCS7()) throws -> [UInt8] {
        if bytes.count % AES.blockSize != 0 {
            throw Error.BlockSizeExceeded
        }
        
        let blocks = bytes.chunks(AES.blockSize)
        let out:[UInt8]
        switch (blockMode) {
        case .CFB, .CTR:
            // CFB, CTR uses encryptBlock to decrypt
            out = try blockMode.decryptBlocks(blocks, iv: self.iv, cipherOperation: encryptBlock)
        default:
            out = try blockMode.decryptBlocks(blocks, iv: self.iv, cipherOperation: decryptBlock)
        }
        
        if let padding = padding {
            return padding.remove(out, blockSize: nil)
        }
        
        return out
    }
    
    private func decryptBlock(block:[UInt8]) -> [UInt8]? {
        var state:[[UInt8]] = [[UInt8]](count: variant.Nb, repeatedValue: [UInt8](count: variant.Nb, repeatedValue: 0))
        for (i, row) in state.enumerate() {
            for (j, _) in row.enumerate() {
                state[j][i] = block[i * row.count + j]
            }
        }
        
        state = addRoundKey(state,expandedKey, variant.Nr)
        
        for roundCount in (1..<variant.Nr).reverse() {
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
    
    private func expandKey(key:[UInt8], variant:AESVariant) -> [UInt8] {
        
        /*
        * Function used in the Key Expansion routine that takes a four-byte
        * input word and applies an S-box to each of the four bytes to
        * produce an output word.
        */
        func subWord(word:[UInt8]) -> [UInt8] {
            var result = word
            for i in 0..<4 {
                result[i] = sBox[Int(word[i])]
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
        for (i,row) in state.enumerate() {
            for (j,value) in row.enumerate() {
                state[i][j] = sBox[Int(value)]
            }
        }
    }
    
    public func invSubBytes(state:[[UInt8]]) -> [[UInt8]] {
        var result = state
        for (i,row) in state.enumerate() {
            for (j,value) in row.enumerate() {
                result[i][j] = invSBox[Int(value)]
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
        
        for _ in 0..<8 {
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
        for (i, row) in matrix.enumerate() {
            for (j, boxVal) in row.enumerate() {
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
        let colBox:[[UInt8]] = [[2,3,1,1],[1,2,3,1],[1,1,2,3],[3,1,1,2]]
        
        var rowMajorState = [[UInt8]](count: state.count, repeatedValue: [UInt8](count: state.first!.count, repeatedValue: 0)) //state.map({ val -> [UInt8] in return val.map { _ in return 0 } }) // zeroing
        var newRowMajorState = rowMajorState
        
        for i in 0..<state.count {
            for j in 0..<state[0].count {
                rowMajorState[j][i] = state[i][j]
            }
        }
        
        for (i, row) in rowMajorState.enumerate() {
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
        let invColBox:[[UInt8]] = [[14,11,13,9],[9,14,11,13],[13,9,14,11],[11,13,9,14]]
        
        var colOrderState = state.map({ val -> [UInt8] in return val.map { _ in return 0 } }) // zeroing
        
        for i in 0..<state.count {
            for j in 0..<state[0].count {
                colOrderState[j][i] = state[i][j]
            }
        }
        
        var newState = state.map({ val -> [UInt8] in return val.map { _ in return 0 } })
        
        for (i, row) in colOrderState.enumerate() {
            newState[i] = matrixMultiplyPolys(invColBox, row)
        }
        
        for i in 0..<state.count {
            for j in 0..<state[0].count {
                state[i][j] = newState[j][i]
            }
        }
        
        return state
    }
    
    // MARK: S-Box
    
    private func calculateSBox() -> (sBox:[UInt8], invSBox:[UInt8]) {
        var sbox = [UInt8](count: 256, repeatedValue: 0)
        var invsbox = sbox
        sbox[0] = 0x63
        
        var p:UInt8 = 1, q:UInt8 = 1
        
        repeat {
            p = p ^ (UInt8(truncatingBitPattern: Int(p) << 1) ^ ((p & 0x80) == 0x80 ? 0x1B : 0))
            q ^= q << 1
            q ^= q << 2
            q ^= q << 4
            q ^= (q & 0x80) == 0x80 ? 0x09 : 0
            
            let s = 0x63 ^ q ^ rotateLeft(q, 1) ^ rotateLeft(q, 2) ^ rotateLeft(q, 3) ^ rotateLeft(q, 4)
            
            sbox[Int(p)] = s
            invsbox[Int(s)] = p
        } while (p != 1)
        
        return (sBox: sbox, invSBox: invsbox)
    }
}