//
//  SHA3.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 25/08/14.
//  Copyright (c) 2014 Marcin Krzyzanowski. All rights reserved.
//

import Foundation

class SHA3 : CryptoHashBase {
    enum variant {
        case sha224, sha256, sha384, sha512
    }
}