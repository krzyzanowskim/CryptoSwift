// Playground - noun: a place where people can play

import Foundation

struct CTX {
    var q = 1
}

// WONT update q value of passed struct instance, but copy of it
func foo1(var x:CTX) {
    x.q = 3
}

// WILL update passed struct instance
func foo2(inout x:CTX) {
    x.q = 2
}

var x = CTX()

foo1(x)
println(x.q)

foo2(&x)
println(x.q)



struct FixedLengthRange {
    var firstValue: Int
    let length: Int
}
var rangeOfThreeItems = FixedLengthRange(firstValue: 0, length: 3)
// the range represents integer values 0, 1, and 2
rangeOfThreeItems.firstValue = 6
// the range now represents integer values 6, 7, and 8