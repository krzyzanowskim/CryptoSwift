//
//  RSA.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 06/07/14.
//  Copyright (c) 2014 Marcin Krzyzanowski. All rights reserved.
//

import Foundation

class SwiftRSA {
    var n: Bignum;
    var e: Bignum;
    var d: Bignum;
    var p: Bignum;
    var q: Bignum;
    
    init(n: Bignum? = nil, e: Bignum? = nil, d: Bignum? = nil, p: Bignum? = nil, q: Bignum? = nil) {
        self.n = n!;
        self.e = e!;
        self.d = d!;
        self.p = p!;
        self.q = q!;
    }
    
    func privateEncrypt(data: NSData) {
//        var rsa:UnsafePointer<RSA> = RSA_new();
    }
}