//
//  SHA2.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 24/08/14.
//  Copyright (c) 2014 Marcin Krzyzanowski. All rights reserved.
//

final class SHA2 : HashProtocol {
    var size:Int { return variant.rawValue }
    let variant:SHA2.Variant
    
    let message: [UInt8]
    
    init(_ message:[UInt8], variant: SHA2.Variant) {
        self.variant = variant
        self.message = message
    }
    
    enum Variant: RawRepresentable {
        case sha224, sha256, sha384, sha512
        
        typealias RawValue = Int
        var rawValue: RawValue {
            switch (self) {
            case .sha224:
                return 224
            case .sha256:
                return 256
            case .sha384:
                return 384
            case .sha512:
                return 512
            }
        }
        
        init?(rawValue: RawValue) {
            switch (rawValue) {
            case 224:
                self = .sha224
                break;
            case 256:
                self = .sha256
                break;
            case 384:
                self = .sha384
                break;
            case 512:
                self = .sha512
                break;
            default:
                return nil
            }
        }
        
        var size:Int { return self.rawValue }
        
        private var h:[UInt64] {
            switch (self) {
            case .sha224:
                return [0xc1059ed8, 0x367cd507, 0x3070dd17, 0xf70e5939, 0xffc00b31, 0x68581511, 0x64f98fa7, 0xbefa4fa4]
            case .sha256:
                return [0x6a09e667, 0xbb67ae85, 0x3c6ef372, 0xa54ff53a, 0x510e527f, 0x9b05688c, 0x1f83d9ab, 0x5be0cd19]
            case .sha384:
                return [0xcbbb9d5dc1059ed8, 0x629a292a367cd507, 0x9159015a3070dd17, 0x152fecd8f70e5939, 0x67332667ffc00b31, 0x8eb44a8768581511, 0xdb0c2e0d64f98fa7, 0x47b5481dbefa4fa4]
            case .sha512:
                return [0x6a09e667f3bcc908, 0xbb67ae8584caa73b, 0x3c6ef372fe94f82b, 0xa54ff53a5f1d36f1, 0x510e527fade682d1, 0x9b05688c2b3e6c1f, 0x1f83d9abfb41bd6b, 0x5be0cd19137e2179]
            }
        }
        
        private var k:[UInt64] {
            switch (self) {
            case .sha224, .sha256:
                return [0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5, 0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5,
                        0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3, 0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174,
                        0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc, 0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da,
                        0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7, 0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967,
                        0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13, 0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85,
                        0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3, 0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070,
                        0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5, 0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3,
                        0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208, 0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2]
            case .sha384, .sha512:
                return [0x428a2f98d728ae22, 0x7137449123ef65cd, 0xb5c0fbcfec4d3b2f, 0xe9b5dba58189dbbc, 0x3956c25bf348b538,
                        0x59f111f1b605d019, 0x923f82a4af194f9b, 0xab1c5ed5da6d8118, 0xd807aa98a3030242, 0x12835b0145706fbe,
                        0x243185be4ee4b28c, 0x550c7dc3d5ffb4e2, 0x72be5d74f27b896f, 0x80deb1fe3b1696b1, 0x9bdc06a725c71235,
                        0xc19bf174cf692694, 0xe49b69c19ef14ad2, 0xefbe4786384f25e3, 0x0fc19dc68b8cd5b5, 0x240ca1cc77ac9c65,
                        0x2de92c6f592b0275, 0x4a7484aa6ea6e483, 0x5cb0a9dcbd41fbd4, 0x76f988da831153b5, 0x983e5152ee66dfab,
                        0xa831c66d2db43210, 0xb00327c898fb213f, 0xbf597fc7beef0ee4, 0xc6e00bf33da88fc2, 0xd5a79147930aa725,
                        0x06ca6351e003826f, 0x142929670a0e6e70, 0x27b70a8546d22ffc, 0x2e1b21385c26c926, 0x4d2c6dfc5ac42aed,
                        0x53380d139d95b3df, 0x650a73548baf63de, 0x766a0abb3c77b2a8, 0x81c2c92e47edaee6, 0x92722c851482353b,
                        0xa2bfe8a14cf10364, 0xa81a664bbc423001, 0xc24b8b70d0f89791, 0xc76c51a30654be30, 0xd192e819d6ef5218,
                        0xd69906245565a910, 0xf40e35855771202a, 0x106aa07032bbd1b8, 0x19a4c116b8d2d0c8, 0x1e376c085141ab53,
                        0x2748774cdf8eeb99, 0x34b0bcb5e19b48a8, 0x391c0cb3c5c95a63, 0x4ed8aa4ae3418acb, 0x5b9cca4f7763e373,
                        0x682e6ff3d6b2b8a3, 0x748f82ee5defb2fc, 0x78a5636f43172f60, 0x84c87814a1f0ab72, 0x8cc702081a6439ec,
                        0x90befffa23631e28, 0xa4506cebde82bde9, 0xbef9a3f7b2c67915, 0xc67178f2e372532b, 0xca273eceea26619c,
                        0xd186b8c721c0c207, 0xeada7dd6cde0eb1e, 0xf57d4f7fee6ed178, 0x06f067aa72176fba, 0x0a637dc5a2c898a6,
                        0x113f9804bef90dae, 0x1b710b35131c471b, 0x28db77f523047d84, 0x32caab7b40c72493, 0x3c9ebe0a15c9bebc,
                        0x431d67c49c100d4c, 0x4cc5d4becb3e42b6, 0x597f299cfc657e2a, 0x5fcb6fab3ad6faec, 0x6c44198c4a475817]
            }
        }
        
        private func resultingArray<T>(hh:[T]) -> ArraySlice<T> {
            switch (self) {
            case .sha224:
                return hh[0..<7]
            case .sha384:
                return hh[0..<6]
            default:
                break;
            }
            return ArraySlice(hh)
        }
    }
    
    //FIXME: I can't do Generic func out of calculate32 and calculate64 (UInt32 vs UInt64), but if you can - please do pull request.
    func calculate32() -> [UInt8] {
        var tmpMessage = self.prepare(64)
        
        // hash values
        var hh = [UInt32]()
        variant.h.forEach {(h) -> () in
            hh.append(UInt32(h))
        }
		
        // append message length, in a 64-bit big-endian integer. So now the message length is a multiple of 512 bits.
        tmpMessage += (message.count * 8).bytes(64 / 8)
        
        // Process the message in successive 512-bit chunks:
        let chunkSizeBytes = 512 / 8 // 64
        for chunk in BytesSequence(chunkSize: chunkSizeBytes, data: tmpMessage) {
            // break chunk into sixteen 32-bit words M[j], 0 ≤ j ≤ 15, big-endian
            // Extend the sixteen 32-bit words into sixty-four 32-bit words:
            var M:[UInt32] = [UInt32](count: variant.k.count, repeatedValue: 0)
            for x in 0..<M.count {
                switch (x) {
                case 0...15:
                    let start = chunk.startIndex + (x * sizeofValue(M[x]))
                    let end = start + sizeofValue(M[x])
                    let le = toUInt32Array(chunk[start..<end])[0]
                    M[x] = le.bigEndian
                    break
                default:
                    let s0 = rotateRight(M[x-15], n: 7) ^ rotateRight(M[x-15], n: 18) ^ (M[x-15] >> 3) //FIXME: n
                    let s1 = rotateRight(M[x-2], n: 17) ^ rotateRight(M[x-2], n: 19) ^ (M[x-2] >> 10)
                    M[x] = M[x-16] &+ s0 &+ M[x-7] &+ s1
                    break
                }
            }
            
            var A = hh[0]
            var B = hh[1]
            var C = hh[2]
            var D = hh[3]
            var E = hh[4]
            var F = hh[5]
            var G = hh[6]
            var H = hh[7]
            
            // Main loop
            for j in 0..<variant.k.count {
                let s0 = rotateRight(A,n: 2) ^ rotateRight(A,n: 13) ^ rotateRight(A,n: 22)
                let maj = (A & B) ^ (A & C) ^ (B & C)
                let t2 = s0 &+ maj
                let s1 = rotateRight(E,n: 6) ^ rotateRight(E,n: 11) ^ rotateRight(E,n: 25)
                let ch = (E & F) ^ ((~E) & G)
                let t1 = H &+ s1 &+ ch &+ UInt32(variant.k[j]) &+ M[j]
                
                H = G
                G = F
                F = E
                E = D &+ t1
                D = C
                C = B
                B = A
                A = t1 &+ t2
            }
            
            hh[0] = (hh[0] &+ A)
            hh[1] = (hh[1] &+ B)
            hh[2] = (hh[2] &+ C)
            hh[3] = (hh[3] &+ D)
            hh[4] = (hh[4] &+ E)
            hh[5] = (hh[5] &+ F)
            hh[6] = (hh[6] &+ G)
            hh[7] = (hh[7] &+ H)
        }
        
        // Produce the final hash value (big-endian) as a 160 bit number:
        var result = [UInt8]()
        result.reserveCapacity(hh.count / 4)
        variant.resultingArray(hh).forEach {
            let item = $0.bigEndian
            result += [UInt8(item & 0xff), UInt8((item >> 8) & 0xff), UInt8((item >> 16) & 0xff), UInt8((item >> 24) & 0xff)]
        }
        return result
    }
    
    func calculate64() -> [UInt8] {
        var tmpMessage = self.prepare(128)
        
        // hash values
        var hh = [UInt64]()
        variant.h.forEach {(h) -> () in
            hh.append(h)
        }
		
  
        // append message length, in a 64-bit big-endian integer. So now the message length is a multiple of 512 bits.
        tmpMessage += (message.count * 8).bytes(64 / 8)
        
        // Process the message in successive 1024-bit chunks:
        let chunkSizeBytes = 1024 / 8 // 128
        for chunk in BytesSequence(chunkSize: chunkSizeBytes, data: tmpMessage) {
            // break chunk into sixteen 64-bit words M[j], 0 ≤ j ≤ 15, big-endian
            // Extend the sixteen 64-bit words into eighty 64-bit words:
            var M = [UInt64](count: variant.k.count, repeatedValue: 0)
            for x in 0..<M.count {
                switch (x) {
                case 0...15:
                    let start = chunk.startIndex + (x * sizeofValue(M[x]))
                    let end = start + sizeofValue(M[x])
                    let le = toUInt64Array(chunk[start..<end])[0]
                    M[x] = le.bigEndian
                    break
                default:
                    let s0 = rotateRight(M[x-15], n: 1) ^ rotateRight(M[x-15], n: 8) ^ (M[x-15] >> 7)
                    let s1 = rotateRight(M[x-2], n: 19) ^ rotateRight(M[x-2], n: 61) ^ (M[x-2] >> 6)
                    M[x] = M[x-16] &+ s0 &+ M[x-7] &+ s1
                    break
                }
            }
            
            var A = hh[0]
            var B = hh[1]
            var C = hh[2]
            var D = hh[3]
            var E = hh[4]
            var F = hh[5]
            var G = hh[6]
            var H = hh[7]
            
            // Main loop
            for j in 0..<variant.k.count {
                let s0 = rotateRight(A,n: 28) ^ rotateRight(A,n: 34) ^ rotateRight(A,n: 39) //FIXME: n:
                let maj = (A & B) ^ (A & C) ^ (B & C)
                let t2 = s0 &+ maj
                let s1 = rotateRight(E,n: 14) ^ rotateRight(E,n: 18) ^ rotateRight(E,n: 41)
                let ch = (E & F) ^ ((~E) & G)
                let t1 = H &+ s1 &+ ch &+ variant.k[j] &+ UInt64(M[j])
                
                H = G
                G = F
                F = E
                E = D &+ t1
                D = C
                C = B
                B = A
                A = t1 &+ t2
            }
            
            hh[0] = (hh[0] &+ A)
            hh[1] = (hh[1] &+ B)
            hh[2] = (hh[2] &+ C)
            hh[3] = (hh[3] &+ D)
            hh[4] = (hh[4] &+ E)
            hh[5] = (hh[5] &+ F)
            hh[6] = (hh[6] &+ G)
            hh[7] = (hh[7] &+ H)
        }
        
        // Produce the final hash value (big-endian)
        var result = [UInt8]()
        result.reserveCapacity(hh.count / 4)
        variant.resultingArray(hh).forEach {
            let item = $0.bigEndian
            var partialResult = [UInt8]()
            partialResult.reserveCapacity(8)
            for i in 0..<8 {
                let shift = UInt64(8 * i)
                partialResult.append(UInt8((item >> shift) & 0xff))
            }
            result += partialResult
        }
        return result
    }
}