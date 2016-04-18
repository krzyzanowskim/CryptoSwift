//
//  LinuxFoundation.swift
//  CryptoSwift
//
//  Created by Alsey Coleman Miller on 4/18/16.
//  Copyright © 2016 Marcin Krzyzanowski. All rights reserved.
//

import Foundation

#if !os(Linux)
    
extension String {
    
    // Workaround:
    // https://github.com/krzyzanowskim/CryptoSwift/issues/177
    @inline(__always)
    func bridge() -> NSString {
        return self as NSString
    }
}

/// Fixes discrepancies with Swift 3.0 Linux
#else
    
    public extension NSString {
        
        @inline(__always)
        func data(using encoding: UInt, allowLossyConversion lossy: Bool) -> NSData? {
            
            return dataUsingEncoding(encoding, allowLossyConversion: lossy)
        }
    }
    
    public extension String {
        
        @inline(__always)
        func data(using encoding: UInt, allowLossyConversion lossy: Bool) -> NSData? {
            
            return self.bridge().dataUsingEncoding(encoding, allowLossyConversion: lossy)
        }
    }
    
    public extension NSDataBase64EncodingOptions {
        
        static var encoding64CharacterLineLength: NSDataBase64EncodingOptions { return NSDataBase64EncodingOptions(rawValue: UInt(1 << 0)) }
        static var encoding76CharacterLineLength: NSDataBase64EncodingOptions { return NSDataBase64EncodingOptions(rawValue: UInt(1 << 1)) }
        static var encodingEndLineWithCarriageReturn: NSDataBase64EncodingOptions { return NSDataBase64EncodingOptions(rawValue: UInt(1 << 4)) }
        static var encodingEndLineWithLineFeed: NSDataBase64EncodingOptions { return NSDataBase64EncodingOptions(rawValue: UInt(1 << 5)) }
    }
    
    public extension NSData {
        
        convenience init?(base64Encoded: String, options: NSDataBase64DecodingOptions) {
            
            self.init(base64EncodedString: base64Encoded, options: options)
        }
        
        private static var base64ByteMappings: [Range<UInt8>] { return [
                                                                           
            65 ..< 91,      // A-Z
            97 ..< 123,     // a-z
            48 ..< 58,      // 0-9
            43 ..< 44,      // +
            47 ..< 48,      // /
            
            ] }
        
        private static func base64EncodeByte(_ byte: UInt8) -> UInt8 {
            assert(byte < 64)
            var decodedStart: UInt8 = 0
            for range in base64ByteMappings {
                let decodedRange = decodedStart ..< decodedStart + (range.endIndex - range.startIndex)
                if decodedRange.contains(byte) {
                    return range.startIndex + (byte - decodedStart)
                }
                decodedStart += range.endIndex - range.startIndex
            }
            return 0
        }
        
        private static func base64EncodeBytes(_ bytes: [UInt8], options: NSDataBase64EncodingOptions = []) -> [UInt8] {
            
            let base64Padding: UInt8 = 61
            
            var result = [UInt8]()
            result.reserveCapacity((bytes.count/3)*4)
            
            let lineOptions : (lineLength : Int, separator : [UInt8])? = {
                let lineLength: Int
                
                if options.contains(.encoding64CharacterLineLength) { lineLength = 64 }
                else if options.contains(.encoding76CharacterLineLength) { lineLength = 76 }
                else {
                    return nil
                }
                
                var separator = [UInt8]()
                if options.contains(.encodingEndLineWithCarriageReturn) { separator.append(13) }
                if options.contains(.encodingEndLineWithLineFeed) { separator.append(10) }
                
                //if the kind of line ending to insert is not specified, the default line ending is Carriage Return + Line Feed.
                if separator.count == 0 {separator = [13,10]}
                
                return (lineLength,separator)
            }()
            
            var currentLineCount = 0
            let appendByteToResult : (UInt8) -> () = {
                result.append($0)
                currentLineCount += 1
                if let options = lineOptions where currentLineCount == options.lineLength {
                    result.append(contentsOf: options.separator)
                    currentLineCount = 0
                }
            }
            
            var currentByte : UInt8 = 0
            
            for (index,value) in bytes.enumerated() {
                switch index%3 {
                case 0:
                    currentByte = (value >> 2)
                    appendByteToResult(NSData.base64EncodeByte(currentByte))
                    currentByte = ((value << 6) >> 2)
                case 1:
                    currentByte |= (value >> 4)
                    appendByteToResult(NSData.base64EncodeByte(currentByte))
                    currentByte = ((value << 4) >> 2)
                case 2:
                    currentByte |= (value >> 6)
                    appendByteToResult(NSData.base64EncodeByte(currentByte))
                    currentByte = ((value << 2) >> 2)
                    appendByteToResult(NSData.base64EncodeByte(currentByte))
                default:
                    fatalError()
                }
            }
            //add padding
            switch bytes.count%3 {
            case 0: break //no padding needed
            case 1:
                appendByteToResult(NSData.base64EncodeByte(currentByte))
                appendByteToResult(base64Padding)
                appendByteToResult(base64Padding)
            case 2:
                appendByteToResult(NSData.base64EncodeByte(currentByte))
                appendByteToResult(base64Padding)
            default:
                fatalError()
            }
            return result
        }
        
        // Create a Base-64 encoded NSString from the receiver's contents using the given options.
        func base64EncodedString(_ options: NSDataBase64EncodingOptions = []) -> String {
            
            var decodedBytes = [UInt8](repeating: 0, count: self.length)
            getBytes(&decodedBytes, length: decodedBytes.count)
            let encodedBytes = NSData.base64EncodeBytes(decodedBytes, options: options)
            let characters = encodedBytes.map { Character(UnicodeScalar($0)) }
            return String(characters)
        }
    }
    
    public extension NSMutableData {
        
        func append(_ bytes: UnsafePointer<Void>, length: Int) {
            
            appendBytes(bytes, length: length)
        }
    }
    
    public extension NSDate {
        
        func timeIntervalSince(_ date: NSDate) -> NSTimeInterval {
            
            return timeIntervalSinceDate(date)
        }
    }
    
#endif

