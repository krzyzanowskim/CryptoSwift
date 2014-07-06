//
//  RSA.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 06/07/14.
//  Copyright (c) 2014 Marcin Krzyzanowski. All rights reserved.
//

import Foundation

struct RSA {
    var n: Bignum;
    var e: Bignum;
    var d: Bignum;
    var p: Bignum;
    var q: Bignum;
    
//    func privateEncrypt(data: NSData) {
//        var rsa:UnsafePointer<RSA> = RSA_new();
//    }
}