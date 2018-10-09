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

public class CBCMAC: Authenticator {
    public enum Error: Swift.Error {
        case wrongKeyLength
    }

    private let key: SecureBytes

    private static let BlockSize: Int = 16
    private static let Zero: Array<UInt8> = [0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]
    private static let Rb: Array<UInt8> = [0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x87]

    public init(key: Array<UInt8>) throws {
        if key.count != 16 {
            throw Error.wrongKeyLength
        }
        self.key = SecureBytes(bytes: key)
    }

    // MARK: Authenticator

    public func authenticate(_ bytes: Array<UInt8>) throws -> Array<UInt8> {
        let aes = try AES(key: Array(key), blockMode: CBC(iv: CBCMAC.Zero), padding: .noPadding)

        let l = try aes.encrypt(CBCMAC.Zero)
        var subKey1 = leftShiftOneBit(l)
        if (l[0] & 0x80) != 0 {
            subKey1 = xor(CBCMAC.Rb, subKey1)
        }
        var subKey2 = leftShiftOneBit(subKey1)
        if (subKey1[0] & 0x80) != 0 {
            subKey2 = xor(CBCMAC.Rb, subKey2)
        }

        let lastBlockComplete: Bool
        let blockCount = (bytes.count + CBCMAC.BlockSize - 1) / CBCMAC.BlockSize
        if blockCount == 0 {
            lastBlockComplete = false
        } else {
            lastBlockComplete = bytes.count % CBCMAC.BlockSize == 0
        }
        var paddedBytes = bytes
        if !lastBlockComplete {
            bitPadding(to: &paddedBytes, blockSize: CBCMAC.BlockSize)
        }

        var blocks = Array(paddedBytes.batched(by: CBCMAC.BlockSize))
        var lastBlock = blocks.popLast()!
        if lastBlockComplete {
            lastBlock = xor(lastBlock, subKey1)
        } else {
            lastBlock = xor(lastBlock, subKey2)
        }

        var x = Array<UInt8>(repeating: 0x00, count: CBCMAC.BlockSize)
        var y = Array<UInt8>(repeating: 0x00, count: CBCMAC.BlockSize)
        for block in blocks {
            y = xor(block, x)
            x = try aes.encrypt(y)
        }
        // the difference between CMAC and CBC-MAC is that CMAC xors the final block with a secret value
        y = process(lastBlock: lastBlock, with: x)
        return try aes.encrypt(y)
    }

    func process(lastBlock: ArraySlice<UInt8>, with x: [UInt8]) -> [UInt8] {
        return Array(lastBlock)
    }

    // MARK: Helper methods

    /**
     Performs left shift by one bit to the bit string aquired after concatenating al bytes in the byte array
     - parameters:
     - bytes: byte array
     - returns: bit shifted bit string split again in array of bytes
     */
    private func leftShiftOneBit(_ bytes: Array<UInt8>) -> Array<UInt8> {
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
}
