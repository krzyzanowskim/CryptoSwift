//
//  PBKDF2.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 05/04/16.
//  Copyright © 2016 Marcin Krzyzanowski. All rights reserved.
//

#if os(Linux)
    import Glibc
#endif

public extension PKCS5 {
    // PBKDF2 - Password-Based Key Derivation Function 2. Key stretching technique.
    //          DK = PBKDF2(PRF, Password, Salt, c, dkLen)
    public struct PBKDF2 {

        public enum Error: ErrorProtocol {
            case InvalidInput
        }

        private let salt: [UInt8]
        private let iterations: Int // c
        private let numBlocks: UInt  // l
        private let prf: HMAC

        public init(password: [UInt8], salt: [UInt8], iterations: Int = 4096 /* c */, keyLength: Int? = nil /* dkLen */ , hashVariant: HMAC.Variant = .sha256) throws {
            guard let prf = HMAC(key: password, variant: hashVariant) where (iterations > 0) && (password.count > 0) && (salt.count > 0) else {
                throw Error.InvalidInput
            }

            let keyLengthFinal: Int
            if let kl = keyLength {
                keyLengthFinal = kl
            } else {
                keyLengthFinal = hashVariant.size
            }

            let hLen = Double(prf.variant.size)
            if keyLength > Int(((pow(2,32) as Double) - 1) * hLen) {
                throw Error.InvalidInput
            }

            self.salt = salt
            self.iterations = iterations
            self.prf = prf


            self.numBlocks = UInt(ceil(Double(keyLengthFinal) / hLen))  // l = ceil(keyLength / hLen)
        }

        public func calculate() -> [UInt8] {
            var ret = [UInt8]()
            for i in 1...self.numBlocks {
                // for each block T_i = U_1 ^ U_2 ^ ... ^ U_iter
                if let value = calculateBlock(salt: self.salt, blockNum: i) {
                    ret.append(contentsOf: value)
                }
            }
            return ret
        }
    }
}

private extension PKCS5.PBKDF2 {
    private func INT(_ i: UInt) -> [UInt8] {
        var inti = [UInt8](repeating: 0, count: 4)
        inti[0] = UInt8((i >> 24) & 0xFF)
        inti[1] = UInt8((i >> 16) & 0xFF)
        inti[2] = UInt8((i >> 8) & 0xFF)
        inti[3] = UInt8(i & 0xFF)
        return inti
    }

    // F (P, S, c, i) = U_1 \xor U_2 \xor ... \xor U_c
    // U_1 = PRF (P, S || INT (i))
    private func calculateBlock(salt: [UInt8], blockNum: UInt) -> [UInt8]? {
        guard let u1 = prf.authenticate(salt + INT(blockNum)) else {
            return nil
        }

        var u = u1
        var ret = u
        if self.iterations > 1 {
            // U_2 = PRF (P, U_1) ,
            // U_c = PRF (P, U_{c-1}) .
            for _ in 2...self.iterations {
                u = prf.authenticate(u)!
                for x in 0..<ret.count {
                    ret[x] = ret[x] ^ u[x]
                }
            }
        }
        return ret
    }
}
