// Playground - noun: a place where people can play

import Foundation
import CryptoSwift

let plaintext = "Lorem ipsum"
let MD5 = plaintext.md5()


protocol Padding {
    func foo() -> String
}

struct PKCS7: Padding {
    func foo() -> String {
        return "dupa"
    }
}

func createTest<T:Padding>(p: T) -> T{
    return p
}

func test<T:Padding>(p: T) -> String {
    return p.foo()
}

func testtest() {
    let t = createTest(PKCS7())
    println(t.foo())
}

testtest()