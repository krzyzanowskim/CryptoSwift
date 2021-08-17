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

struct GiantUInt: Equatable {
  
  let bytes: Array<UInt8>
  
  init(_ raw: Array<UInt8>) {
    self.bytes = raw
  }
    
  // Equatable
  
  static func == (lhs: GiantUInt, rhs: GiantUInt) -> Bool {
    lhs.bytes == rhs.bytes
  }
  
  // Operations
  
  static func + (rhs: GiantUInt, lhs: GiantUInt) -> GiantUInt {
    var newBytes = [UInt8]()
    
    var r: UInt8 = 0
    
    for i in 0 ..< max(rhs.bytes.count, lhs.bytes.count) {
      let res1 = (rhs.bytes[safe: i] ?? 0).addingReportingOverflow(lhs.bytes[safe: i] ?? 0)
      let res2 = res1.partialValue.addingReportingOverflow(r)
      newBytes.append(res2.partialValue)
      r = (res1.overflow ? 1 : 0) + (res2.overflow ? 1 : 0)
    }
    
    if r != 0 {
      newBytes.append(r)
    }
    
    return GiantUInt(newBytes)
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
  
}
