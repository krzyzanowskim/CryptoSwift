//
//  CryptoSwift
//
//  Copyright (C) 2014-2017 Marcin Krzyżanowski <marcin@krzyzanowskim.com>
//  This software is provided 'as-is', without any express or implied warranty.
//
//  In no event will the authors be held liable for any damages arising from the use of this software.
//
//  Permission is granted to anyone to use this software for any purpose,including commercial applications, and to alter it and redistribute it freely, subject to the following restrictions:
//
//  - The origin of this software must not be misrepresented; you must not claim that you wrote the original software. If you use this software in a product, an acknowledgment in the product documentation is required.
//  - Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.
//  - This notice may not be removed or altered from any source or binary distribution.
//
//  https://www.ietf.org/rfc/rfc7914.txt
//

#if canImport(Darwin)
import Darwin
#else
import Glibc
#endif

public extension PKCS5 {
    /// A key derivation function.
    ///
    /// Scrypt - Password-Based Key Derivation Function. Key stretching technique.
    //    Passphrase:                Bytes    string of characters to be hashed
    //    Salt:                      Bytes    random salt
    //    CostFactor (N):            Integer  CPU/memory cost parameter
    //    BlockSizeFactor (r):       Integer  blocksize parameter (8 is commonly used)
    //    ParallelizationFactor (p): Integer  Parallelization parameter. (1..232-1 * hLen/MFlen)
    //    DesiredKeyLen:
    
    public struct Scrypt {
        public enum Error: Swift.Error {
            case invalidInput
            case derivedKeyTooLong
        }
        
        private let salt: Array<UInt8> // S
        private let password: Array<UInt8>
        fileprivate let blocksize: Int // 128 * r
        private let dkLen: Int
        private let N: Int
        private let r: Int
        private let p: Int

        public init(password: Array<UInt8>, salt: Array<UInt8>, dkLen: Int, N: Int, r: Int, p: Int) throws {
            precondition(dkLen > 0)
            precondition(N > 0)
            precondition(N & (N-1) == 0) // N is power of 2
            precondition(r > 0)
            precondition(p > 0)
            
            self.blocksize = 128 * r
            self.N = N
            self.r = r
            self.p = p
            self.password = password
            self.salt = salt
            self.dkLen = dkLen
        }
        
        public func calculate() throws -> Array<UInt8> {
            var kdf = try CryptoSwift.PKCS5.PBKDF2(password: password, salt: salt, iterations: 1, keyLength: blocksize*p, variant: .sha256)
            var B = try kdf.calculate()
            var v = Array<UInt32>(repeating: 0, count: 32*N*r) // 128*r*N bytes
            var xy = Array<UInt32>(repeating: 0, count: 64*r) // 128*2*r bytes
            // no parallelization here for now
            for i in 0 ..< p {
                PKCS5.Scrypt.smix(b: &B[(i*128*r)...], N: N, r: r, v: &v, xy: &xy)
            }
            kdf = try CryptoSwift.PKCS5.PBKDF2(password: self.password, salt: B, iterations: 1, keyLength: dkLen, variant: .sha256)
            let ret = try kdf.calculate()
            return Array(ret)
        }
    }
}

extension PKCS5.Scrypt {
    static func blockCopy(destination: inout Array<UInt32>, source: Array<UInt32>, n: Int) {
        for i in 0 ..< n {
            destination[i] = source[i]
        }
    }
    
    static func blockCopy(destination: inout Array<UInt32>, source: ArraySlice<UInt32>, n: Int) {
        let startIndexSource = source.startIndex
        for i in 0 ..< n {
            destination[i] = source[startIndexSource + i]
        }
    }
    
    static func blockCopy(destination: inout ArraySlice<UInt32>, source: Array<UInt32>, n: Int) {
        let startIndex = destination.startIndex
        for i in 0 ..< n {
            destination[startIndex + i] = source[i]
        }
    }
    
    static func blockCopy(destination: inout ArraySlice<UInt32>, source: ArraySlice<UInt32>, n: Int) {
        let startIndex = destination.startIndex
        let startIndexSource = source.startIndex
        for i in 0 ..< n {
            destination[startIndex + i] = source[startIndexSource + i]
        }
    }
    
    static func blockXOR(destination: inout ArraySlice<UInt32>, source: Array<UInt32>, n: Int) {
        let startIndex = destination.startIndex
        for i in 0 ..< n {
            destination[startIndex + i] ^= source[i]
        }
    }
    
    static func blockXOR(destination: inout ArraySlice<UInt32>, source: ArraySlice<UInt32>, n: Int) {
        let startIndex = destination.startIndex
        let startIndexSource = source.startIndex
        for i in 0 ..< n {
            destination[startIndex + i] ^= source[startIndexSource + i]
        }
    }
    
    static func blockMix(tmp: inout Array<UInt32>, source: ArraySlice<UInt32>, destination: inout ArraySlice<UInt32>, r: Int) {
        let sourceStart = source.startIndex
        let destinationStart = destination.startIndex
        blockCopy(destination: &tmp, source: source[(sourceStart + (2*r-1)*16)...], n: 16)
        for i in stride(from: 0, to: 2*r, by: 2) {
            salsaXOR(tmp: &tmp, source: source[(sourceStart + i*16)...], destination: &destination[(destinationStart + i*8)...])
            salsaXOR(tmp: &tmp, source: source[(sourceStart + i*16 + 16)...], destination: &destination[(destinationStart + i*8 + r*16)...])
        }
    }
    
    static func salsaXOR(tmp: inout Array<UInt32>, source: Array<UInt32>, destination: inout Array<UInt32>) {
        for i in 0 ..< 16 {
            tmp[i] = tmp[i] ^ source[i]
        }
        Salsa.salsa20(&tmp, rounds: 8)
        for i in 0 ..< 16 {
            destination[i] = tmp[i]
        }
    }
    
    static func salsaXOR(tmp: inout Array<UInt32>, source: ArraySlice<UInt32>, destination: inout ArraySlice<UInt32>) {
        let sourceStart = source.startIndex
        let destinationStart = destination.startIndex
        for i in 0 ..< 16 {
            tmp[i] = tmp[i] ^ source[sourceStart + i]
        }
        Salsa.salsa20(&tmp, rounds: 8)
        for i in 0 ..< 16 {
            destination[destinationStart + i] = tmp[i]
        }
    }
    
    static func integerify(b : ArraySlice<UInt32>, r: Int) -> UInt64 {
        let j = (2*r - 1) * 16
        return UInt64(b[j]) | (UInt64(b[j+1]) << 32) // LE
    }
    
    static func smix(b: inout ArraySlice<UInt8>, N: Int, r: Int, v: inout Array<UInt32>, xy: inout Array<UInt32>) {
        var tmp = Array<UInt32>(repeating: 0, count: 16)
        var x = ArraySlice<UInt32>(xy)
        var y = xy[0 ..< 32*r]
        
        var j = b.startIndex
        for i in 0 ..< 32*r {
            x[i] = uint32(b[j]) | uint32(b[j+1])<<8 | uint32(b[j+2])<<16 | uint32(b[j+3])<<24 // decode as LE Uint32
            j += 4
        }
        for i in stride(from: 0, to: N, by: 2) {
            PKCS5.Scrypt.blockCopy(destination: &v[(i*(32*r))...], source: x, n: 32*r)
            PKCS5.Scrypt.blockMix(tmp: &tmp, source: x, destination: &y, r: r)
            
            PKCS5.Scrypt.blockCopy(destination: &v[((i+1)*(32*r))...], source: y, n: 32*r)
            PKCS5.Scrypt.blockMix(tmp: &tmp, source: y, destination: &x, r: r)
        }
        for _ in stride(from: 0, to: N, by: 2) {
            j = Int( PKCS5.Scrypt.integerify(b: x, r: r) & UInt64(N-1) )
            PKCS5.Scrypt.blockXOR(destination: &x, source: v[(j*(32*r))...], n: 32*r)
            PKCS5.Scrypt.blockMix(tmp: &tmp, source: x, destination: &y, r: r)
            
            j = Int( PKCS5.Scrypt.integerify(b: y, r: r) & UInt64(N-1) )
            PKCS5.Scrypt.blockXOR(destination: &y, source: v[(j*(32*r))...], n: 32*r)
            PKCS5.Scrypt.blockMix(tmp: &tmp, source: y, destination: &x, r: r)
        }
        j = b.startIndex
        for v in x[0 ..< 32*r] {
            b[j+0] = UInt8(v >> 0 & 0xff)
            b[j+1] = UInt8(v >> 8 & 0xff)
            b[j+2] = UInt8(v >> 16 & 0xff)
            b[j+3] = UInt8(v >> 24 & 0xff)
            j += 4
        }
    }
    
    static func integerify(_ X: Array<UInt8>) -> UInt64 {
        precondition(X.count >= 8)
        let count = X.count
        var result = UInt64(0)
        var shift = 56
        for i in (count-8 ..< count).reversed() {
            result |= UInt64(X[i]) << shift
            shift -= 8
        }
        return result
    }
}
