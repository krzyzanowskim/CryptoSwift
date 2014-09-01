//
//  Poly1305.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 30/08/14.
//  Copyright (c) 2014 Marcin Krzyzanowski. All rights reserved.
//
//  http://tools.ietf.org/html/draft-agl-tls-chacha20poly1305-04#section-4
//
//  Poly1305 takes a 32-byte, one-time key and a message and produces a 16-byte tag that authenticates the
//  message such that an attacker has a negligible chance of producing a valid tag for an inauthentic message.

import Foundation

class Poly1305 {

    var r:[Byte] = [Byte](count: 17, repeatedValue: 0)
    var h:[Byte] = [Byte](count: 17, repeatedValue: 0)
    var pad:[Byte] = [Byte](count: 17, repeatedValue: 0)
    var final:Byte = 0
    
    init (key: [Byte]) {
        if (key.count != 32) {
            return;
        }
        
        for i in 0...15 {
            h[i] = 0
            r[i] = key[i] & 0x0f
            pad[i] = key[i + 16]
        }
        
        h[16] = 0
        r[16] = 0
        pad[16] = 0
        
        final = 0
    }
    
    deinit {
        for i in 0...(r.count) {
            r[i] = 0
            h[i] = 0
            pad[i] = 0
            final = 0
        }
    }
    
    
}