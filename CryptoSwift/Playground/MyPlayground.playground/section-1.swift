// Playground - noun: a place where people can play

import Foundation

func withBytes<T: UnsignedIntegerType>(bytes: [Byte]) -> T {
    var totalBytes = Swift.min(bytes.count, sizeof(T))
    // get slice of Int
    var start = Swift.max(bytes.count - sizeof(T),0)
    var intarr = [Byte](bytes[start..<(start + totalBytes)])
    
    // pad size if necessary
    while (intarr.count < sizeof(T)) {
        intarr.insert(0 as Byte, atIndex: 0)
    }
    intarr = intarr.reverse()
    
    var i:T = 0
    var data = NSData(bytes: intarr, length: intarr.count)
    data.getBytes(&i, length: sizeofValue(i));
    return i
}

let a:UInt32 = withBytes([0x01,0x01,0x01])

