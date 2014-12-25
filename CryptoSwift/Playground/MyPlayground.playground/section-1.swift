// Playground - noun: a place where people can play

import Foundation

public func mult(a:UInt8, b:UInt8) -> UInt8 {
    var a = a, b = b
    var p:UInt8 = 0, hbs:UInt8 = 0
    
    for i in 0..<8 {
        if (b & 1 == 1) {
            p ^= a
        }
        hbs = a & 0x80
        a <<= 1
        if (hbs != 0) {
            a ^= 0x1B
        }
        println("\(i) p=\(p) a=\(a)")
        b >>= 1
    }
    return p
}

mult(0x0e, 0x5f)