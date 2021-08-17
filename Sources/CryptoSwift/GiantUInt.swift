//
//  CryptoSwift
//
//  Copyright (C) 2014-2021 Marcin Krzyżanowski <marcin@krzyzanowskim.com>
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

precedencegroup PowerPrecedence { higherThan: MultiplicationPrecedence }
infix operator ^^ : PowerPrecedence

struct GiantUInt: Equatable, Comparable, ExpressibleByIntegerLiteral {
  
  // Properties
  
  let bytes: Array<UInt8>
  
  // Initialization
  
  init(_ raw: Array<UInt8>) {
    var bytes = raw
    
    while bytes.last == 0 {
      bytes.removeLast()
    }
    
    self.bytes = bytes
  }
  
  // ExpressibleByIntegerLiteral
  
  typealias IntegerLiteralType = UInt8
  
  init(integerLiteral value: UInt8) {
    self = GiantUInt([value])
  }
    
  // Equatable
  
  static func == (lhs: GiantUInt, rhs: GiantUInt) -> Bool {
    lhs.bytes == rhs.bytes
  }
  
  // Comparable
  
  static func < (rhs: GiantUInt, lhs: GiantUInt) -> Bool {
    for i in (0 ..< max(rhs.bytes.count, lhs.bytes.count)).reversed() {
      let r = rhs.bytes[safe: i] ?? 0
      let l = lhs.bytes[safe: i] ?? 0
      if r < l {
        return true
      } else if r > l {
        return false
      }
    }
    
    return false
  }
  
  // Operations
  
  static func + (rhs: GiantUInt, lhs: GiantUInt) -> GiantUInt {
    var bytes = [UInt8]()
    var r: UInt8 = 0
    
    for i in 0 ..< max(rhs.bytes.count, lhs.bytes.count) {
      let res = UInt16(rhs.bytes[safe: i] ?? 0) + UInt16(lhs.bytes[safe: i] ?? 0) + UInt16(r)
      r = UInt8(res >> 8)
      bytes.append(UInt8(res & 0xff))
    }
    
    if r != 0 {
      bytes.append(r)
    }
    
    return GiantUInt(bytes)
  }
  
  static func * (rhs: GiantUInt, lhs: GiantUInt) -> GiantUInt {
    var offset = 0
    var sum = [GiantUInt]()
    
    for rbyte in rhs.bytes {
      var bytes = [UInt8](repeating: 0, count: offset)
      var r: UInt8 = 0
      
      for lbyte in lhs.bytes {
        let res = UInt16(rbyte) * UInt16(lbyte) + UInt16(r)
        r = UInt8(res >> 8)
        bytes.append(UInt8(res & 0xff))
      }
      
      if r != 0 {
        bytes.append(r)
      }
      
      sum.append(GiantUInt(bytes))
      offset += 1
    }
    
    return sum.reduce(GiantUInt([]), +)
  }
  
  static func ^^ (rhs: GiantUInt, lhs: GiantUInt) -> GiantUInt {
    let count = lhs.bytes.count
    var result = GiantUInt([1])
    
    for iByte in 0 ..< count {
      let byte = lhs.bytes[iByte]
      for i in 0 ..< 8 {
        if iByte != count - 1 || byte >> i > 0 {
          result = result * result
          if (byte >> i) & 1 == 1 {
            result = result * rhs
          }
        }
      }
    }
    
    return result
  }
  
}
