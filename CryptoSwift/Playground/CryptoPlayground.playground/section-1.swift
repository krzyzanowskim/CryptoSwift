// Playground - noun: a place where people can play

import Foundation

protocol Proto {
    
}

struct S1: Proto {
    
}

func create<M: Proto>(p:M) -> M {
    return p()
}

let qq = create(S1())