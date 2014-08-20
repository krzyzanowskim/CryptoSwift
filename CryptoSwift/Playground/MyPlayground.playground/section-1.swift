// Playground - noun: a place where people can play

import UIKit

var i:UInt32 = 402653184
i.bigEndian
i.littleEndian


var M:[UInt32] = [UInt32](count: 80, repeatedValue: 0)
for x in 0..<M.count {
    M[x] = 1
}

M