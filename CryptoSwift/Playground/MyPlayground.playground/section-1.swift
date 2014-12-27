// Playground - noun: a place where people can play

import Foundation

class Foo {
    class func A() -> Int {
        return 1
    }

    // YES
    //func A() -> Int {
    //    return 2
    //}
    
    // NO
    let A:Int = Foo.A()
}

//Foo.A()
//Foo().A
