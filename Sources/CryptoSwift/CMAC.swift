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

public final class CMAC: Authenticator {
    
    public enum Error: Swift.Error {
        case wrongKeyLength
    }

    let key: Array<UInt8>

    private static let BlockSize: Int = 16
    private static let Zero: Array<UInt8> = [0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]
    private static let Rb: Array<UInt8> = [0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x87]

    public init(key: Array<UInt8>) throws {
        self.key = key
        if key.count != 16 {
            throw Error.wrongKeyLength
        }
    }

    // MARK: Authenticator

    public func authenticate(_ bytes: Array<UInt8>) throws -> Array<UInt8> {
        let aes = try AES(key: key, blockMode: .CBC(iv: CMAC.Zero), padding: .noPadding)
        
        let l = try aes.encrypt(CMAC.Zero)
        var subKey1 = bitShiftLeft(l)
        if (l[0] & 0x80) != 0 {
            subKey1 = xor(CMAC.Rb, subKey1)
        }
        var subKey2 = bitShiftLeft(subKey1)
        if (subKey1[0] & 0x80) != 0 {
            subKey2 = xor(CMAC.Rb, subKey2)
        }

        var blockCount: Int
        let lastBlockComplete: Bool
        blockCount = (bytes.count + CMAC.BlockSize - 1) / CMAC.BlockSize
        if blockCount == 0 {
            blockCount = 1
            lastBlockComplete = false
        } else {
            lastBlockComplete = bytes.count % CMAC.BlockSize == 0
        }

        let lastBlockIndex = blockCount - 1
        var lastBlock = Array<UInt8>(repeating: 0x00, count: CMAC.BlockSize)
        if lastBlockComplete {
            let block = getBlock(bytes, at: lastBlockIndex)
            lastBlock = xor(block, subKey1)
        } else {
            let block = getPaddedBlock(bytes, at: lastBlockIndex)
            lastBlock = xor(block, subKey2)
        }

        var x = Array<UInt8>(repeating: 0x00, count: CMAC.BlockSize)
        var y = Array<UInt8>(repeating: 0x00, count: CMAC.BlockSize)

        for idx in 0..<lastBlockIndex {
            let block = getBlock(bytes, at: idx)
            y = xor(block, x)
            x = try aes.encrypt(y)
        }
        y = xor(lastBlock, x)
        return try aes.encrypt(y)
    }

    // MARK: Helper methods

    private func bitShiftLeft(_ bytes: Array<UInt8>) -> Array<UInt8> {
        var shifted = Array<UInt8>(repeating: 0x00, count: bytes.count)
        let last = bytes.count - 1
        for index in 0..<last {
            shifted[index] = bytes[index] << 1
            if (bytes[index + 1] & 0x80) != 0 {
                shifted[index] += 0x01
            }
        }
        shifted[last] = bytes[last] << 1
        return shifted
    }

    private func getBlock(_ bytes: Array<UInt8>, at index: Int) -> Array<UInt8> {
        let start = index * CMAC.BlockSize
        let end = start + CMAC.BlockSize
        let block = Array(bytes[start..<end])
        return block
    }

    private func getPaddedBlock(_ bytes: Array<UInt8>, at index: Int) -> Array<UInt8> {
        var block = Array<UInt8>(repeating: 0x00, count: CMAC.BlockSize)
        let start = index * CMAC.BlockSize
        let end = bytes.count
        for idx in start..<end {
            block[idx - start] = bytes[idx]
        }
        block[end - start] = 0x80
        return block
    }
}
