// Playground - noun: a place where people can play

import UIKit

extension Int {
    
    /** Array of bytes (little-endian) */
    internal func toBytes() -> Array<Byte> {
        let totalBytes = sizeof(Int)
        var bytes:[Byte] = [Byte](count: totalBytes, repeatedValue: 0)
        
        // first convert to data
        let data = NSData(bytes: [self] as [Int], length: totalBytes)
        
        // then convert back to bytes, byte by byte
        for i in 0..<data.length {
            var b:Byte = 0
            data.getBytes(&b, range: NSRange(location: i,length: 1))
            bytes[totalBytes - 1 - i] = b
        }
        return bytes
    }
    
    /** Int with array bytes (little-endian) */
    static func withBytes(bytes: Array<Byte>) -> Int {
        var i:Int = 0
        let totalBytes = bytes.count > sizeof(Int) ? sizeof(Int) : bytes.count;
        
        let data = NSData(bytes: bytes, length: totalBytes)
        data.getBytes(&i, length: totalBytes)
        
        return i.byteSwapped
    }
}

let iii:Int = 1024 //0x5A
let bytesArray = iii.toBytes()
let iiiRecover = Int.withBytes(bytesArray)

//var str = "Hello, playground"
//
//let string: NSString = "ABCDE"
//let message: NSData = string.dataUsingEncoding(NSUTF8StringEncoding)
//
//var tmpMessage: NSMutableData = NSMutableData(data: message)
//// append one bit to message
//let oneBit: [UInt8] = [0x5A] //0x80
//tmpMessage.appendBytes(oneBit, length: 1)
//
//let b:Byte = 3
//b.bits()
//
//let lengthInBits:Int = 257
//
//
//// little endian 7 6 5 4 3 2 1 0
//// big endin     0 1 2 3 4 5 6 7
////var step = 0;
////for i in stride(from: 0, through: 56, by: 8) {
////    let byte = (Byte)(lengthInBits >> i)
////    byte.bitsLE()
////    step = step + 1
////}
//
//
//let output: NSString = NSString(data: tmpMessage, encoding: NSUTF8StringEncoding)
