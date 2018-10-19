//
//  CryptoSwift
//
//  Copyright (C) 2014-2017 Marcin Krzyżanowski <marcin@krzyzanowskim.com>
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

internal protocol DigestType {
    func calculate(for bytes: Array<UInt8>) -> Array<UInt8>
}

public protocol SimpleDigestType {
    static var littleEndian: Bool { get }
    static var chunkSize: Int { get }
    static var digestSize: Int { get }
    
    var processedBytes: UInt64 { get }
    var hashValue: [UInt8] { get }
    
    init()
    
    mutating func reset()
    mutating func update(from pointer: UnsafePointer<UInt8>)
}

extension SimpleDigestType {
    public mutating func finish(from pointer: UnsafeBufferPointer<UInt8>) -> [UInt8] {
        // Hash size in _bits_
        let hashSize = (UInt64(pointer.count) &+ processedBytes) &* 8
        
        var needed = (pointer.count + 9)
        let remainder = needed % Self.chunkSize
        
        if remainder != 0 {
            needed = needed - remainder + Self.chunkSize
        }
        
        var data = [UInt8](repeating: 0, count: needed)
        data.withUnsafeMutableBufferPointer { buffer in
            buffer.baseAddress!.assign(from: pointer.baseAddress!, count: pointer.count)
            
            buffer[pointer.count] = 0x80
            
            buffer.baseAddress!.advanced(by: needed &- 8).withMemoryRebound(to: UInt64.self, capacity: 1) { pointer in
                if Self.littleEndian {
                    pointer.pointee = hashSize.littleEndian
                } else {
                    pointer.pointee = hashSize.bigEndian
                }
            }
            
            var offset = 0
            
            while offset < needed {
                self.update(from: buffer.baseAddress!.advanced(by: offset))
                
                offset = offset &+ Self.chunkSize
            }
        }
        
        return self.hashValue
    }
    
    public mutating func hash(bytes data: [UInt8]) -> [UInt8] {
        defer {
            self.reset()
        }
        
        return data.withUnsafeBufferPointer { buffer in
            self.finish(from: buffer)
        }
    }
    
    public mutating func hash(_ data: UnsafePointer<UInt8>, count: Int) -> [UInt8] {
        defer {
            self.reset()
        }
        
        let buffer = UnsafeBufferPointer(start: data, count: count)
        
        return finish(from: buffer)
    }
}
