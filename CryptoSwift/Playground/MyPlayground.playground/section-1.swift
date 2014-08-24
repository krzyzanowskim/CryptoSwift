// Playground - noun: a place where people can play

import UIKit

// test inside class
class Test {
    func test(a:Int, b:Int) -> Int {
        return a + b
    }
}

// test with no class
func test(a:Int, b:Int) -> Int
{
    return a + b
}

Test().test(3, b: 3) // parameter name "b" WITH specified name is required
// BUT
test(3,4) // no parameter name "b"