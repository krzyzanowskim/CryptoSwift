//
//  Multiplatform.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 03/12/15.
//  Copyright © 2015 Marcin Krzyzanowski. All rights reserved.
//

#if os(Linux) || os(Android) || os(FreeBSD)
    import Glibc
    import SwiftShims
#else
    import Darwin
#endif

@available(*, deprecated: 0.6.1, message: "Please don't use it. Use random generator suitable for the platform.")
func cs_arc4random_uniform(_ upperBound: UInt32) -> UInt32 {
    #if os(Linux) || os(Android) || os(FreeBSD)
        return _swift_stdlib_cxx11_mt19937_uniform(upperBound)
    #else
        return arc4random_uniform(upperBound)
    #endif
}
