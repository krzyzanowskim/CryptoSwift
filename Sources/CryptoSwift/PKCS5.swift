//
//  PKCS.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 12/03/15.
//  Copyright (c) 2015 Marcin Krzyzanowski. All rights reserved.
//
//  PKCS is a group of public-key cryptography standards devised 
//  and published by RSA Security Inc, starting in the early 1990s.
//
//  PKCS#5 http://tools.ietf.org/html/rfc2898

//public struct PKCS5 {
//}
//
//extension PKCS5 {
//    //
//    // PBKDF2 - Password-Based Key Derivation Function 2. Key stretching technique.
//    //          DK = PBKDF2(PRF, Password, Salt, c, dkLen)
//    //
//    struct PBKDF2 {
//        typealias Bytes = [UInt8]
//        private func calc(# hash:Hash,  password:Bytes, salt:Bytes, c:Int, dkLen:Int) -> [UInt8]? {
//            if (dkLen > Int(pow(2,32) as Float - 1)) {
//                println("ERROR: derived key too long");
//                return nil
//            }
//
//            if let prf = HMAC(password, variant: .sha256) { //FIXME: hardcoded SHA256
//                let hLen = prf.variant.size
//                let numBlocks = Int(ceilf(Float(dkLen) / Float(hLen)))  // l
//                let lastBlockOctets = dkLen - (1 - numBlocks) * hLen    // r
//                // blocks
//                for block in 1...numBlocks {
//                    // for each block T_i = U_1 ^ U_2 ^ ... ^ U_iter
//                    // U_1 = PRF(password, salt || uint(i))
//                    var uinti = [UInt8](count: 4, repeatedValue: 0)
//                    uinti[0] = UInt8(block >> 24)
//                    uinti[1] = UInt8(block >> 16)
//                    uinti[2] = UInt8(block >> 8)
//                    uinti[3] = UInt8(block)
//                    if let dk = prf.authenticate(message: salt + uinti) {
//                        let T = dk[dk.count - hLen]
//                    }
//                }
//            }
//            return nil
//        }
//    }
//}
