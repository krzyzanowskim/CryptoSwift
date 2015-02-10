// Playground - noun: a place where people can play

import Foundation

reverse(1..<4)

var arr:[UInt8] = [0x06];
let repeat = Repeat(count: 5, repeatedValue: 0)
for a in repeat {
    arr = arr + [Byte(a)]
}

arr + [UInt8](count: 5, repeatedValue: 0)


arr[0..<3]


var key:[UInt8] = [1,2,3,4,5,6,7,8,9,0]
var opad = [UInt8](count: 64, repeatedValue: 0x5c)

opad.map({ (val:Byte) -> (Byte) in
    return val ^ 56
