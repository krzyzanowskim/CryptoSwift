//
//  Operators.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 02/09/14.
//  Copyright (c) 2014 Marcin Krzyzanowski. All rights reserved.
//
/*
Bit shifting with overflow protection using overflow operator "&".
Approach is consistent with standard overflow operators &+, &-, &*, &/
and introduce new overflow operators for shifting: &<<, &>>

Note: Works with unsigned integers values only

Usage

var i = 1       // init
var j = i &<< 2 //shift left
j &<<= 2        //shift left and assign


@see: https://medium.com/@krzyzanowskim/swiftly-shift-bits-and-protect-yourself-be33016ce071
*/

infix operator &<<= {
associativity none
precedence 160
}

infix operator &<< {
associativity none
precedence 160
}

infix operator &>>= {
associativity none
precedence 160
}

infix operator &>> {
associativity none
precedence 160
}