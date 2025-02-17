//
//  CryptoSwift
//
//  Copyright (C) 2014-2025 Marcin Krzyżanowski <marcin@krzyzanowskim.com>
//  This software is provided 'as-is', without any express or implied warranty.
//
//  In no event will the authors be held liable for any damages arising from the use of this software.
//
//  Permission is granted to anyone to use this software for any purpose,including commercial applications, and to alter it and redistribute it freely, subject to the following restrictions:
//
//  - The origin of this software must not be misrepresented; you must not claim that you wrote the original software. If you use this software in a product, an acknowledgment in the product documentation is required.
//  - Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.
//  - This notice may not be removed or altered from any source or binary distribution.
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

 This fuctonality is now implemented as part of Swift 3, SE-0104 https://github.com/apple/swift-evolution/blob/master/proposals/0104-improved-integers.md
 */
