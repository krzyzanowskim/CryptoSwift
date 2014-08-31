//
//  Poly1305.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 30/08/14.
//  Copyright (c) 2014 Marcin Krzyzanowski. All rights reserved.
//
//  http://tools.ietf.org/html/draft-agl-tls-chacha20poly1305-04#section-4

import Foundation

class Poly1305 {

    var r:[Byte] = []
    var h:[Byte] = []
    
    func setupForKey(key:NSData) {
        let keyBytes = key.arrayOfBytes()
        
    }
}