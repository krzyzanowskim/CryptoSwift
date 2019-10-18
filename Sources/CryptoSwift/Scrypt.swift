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

//
// https://tools.ietf.org/html/rfc7914
//

/// Implementation of the scrypt key derivation function.
public final class Scrypt {
  enum Error: Swift.Error {
    case nIsTooLarge
    case rIsTooLarge
    case nMustBeAPowerOf2GreaterThan1
    case invalidInput
  }

  /// Configuration parameters.
  private let salt: SecureBytes
  private let password: SecureBytes
  private let blocksize: Int // 128 * r
  private let salsaBlock = UnsafeMutableRawPointer.allocate(byteCount: 64, alignment: 64)
  private let dkLen: Int
  private let N: Int
  private let r: Int
  private let p: Int

  /// - parameters:
  ///   - password: password
  ///   - salt: salt
  ///   - dkLen: output length
  ///   - N: determines extra memory used
  ///   - r: determines a block size
  ///   - p: determines parallelicity degree
  public init(password: Array<UInt8>, salt: Array<UInt8>, dkLen: Int, N: Int, r: Int, p: Int) throws {
    precondition(dkLen > 0)
    precondition(N > 0)
    precondition(r > 0)
    precondition(p > 0)

    guard !(N < 2 || (N & (N - 1)) != 0) else { throw Error.nMustBeAPowerOf2GreaterThan1 }

    guard N <= .max / 128 / r else { throw Error.nIsTooLarge }
    guard r <= .max / 128 / p else { throw Error.rIsTooLarge }

    guard !salt.isEmpty else {
      throw Error.invalidInput
    }

    self.blocksize = 128 * r
    self.N = N
    self.r = r
    self.p = p
    self.password = SecureBytes(bytes: password)
    self.salt = SecureBytes(bytes: salt)
    self.dkLen = dkLen
  }

  /// Runs the key derivation function with a specific password.
  public func calculate() throws -> [UInt8] {
    // Allocate memory (as bytes for now) for further use in mixing steps
    let B = UnsafeMutableRawPointer.allocate(byteCount: 128 * self.r * self.p, alignment: 64)
    let XY = UnsafeMutableRawPointer.allocate(byteCount: 256 * self.r + 64, alignment: 64)
    let V = UnsafeMutableRawPointer.allocate(byteCount: 128 * self.r * self.N, alignment: 64)

    // Deallocate memory when done
    defer {
      B.deallocate()
      XY.deallocate()
      V.deallocate()
    }

    /* 1: (B_0 ... B_{p-1}) <-- PBKDF2(P, S, 1, p * MFLen) */
    // Expand the initial key
    let barray = try PKCS5.PBKDF2(password: Array(self.password), salt: Array(self.salt), iterations: 1, keyLength: self.p * 128 * self.r, variant: .sha256).calculate()
    barray.withUnsafeBytes { p in
      B.copyMemory(from: p.baseAddress!, byteCount: barray.count)
    }

    /* 2: for i = 0 to p - 1 do */
    // do the mixing
    for i in 0 ..< self.p {
      /* 3: B_i <-- MF(B_i, N) */
      smix(B + i * 128 * self.r, V.assumingMemoryBound(to: UInt32.self), XY.assumingMemoryBound(to: UInt32.self))
    }

    /* 5: DK <-- PBKDF2(P, B, 1, dkLen) */
    let pointer = B.assumingMemoryBound(to: UInt8.self)
    let bufferPointer = UnsafeBufferPointer(start: pointer, count: p * 128 * self.r)
    let block = [UInt8](bufferPointer)
    return try PKCS5.PBKDF2(password: Array(self.password), salt: block, iterations: 1, keyLength: self.dkLen, variant: .sha256).calculate()
  }
}

private extension Scrypt {
  /// Computes `B = SMix_r(B, N)`.
  ///
  /// The input `block` must be `128*r` bytes in length; the temporary storage `v` must be `128*r*n` bytes in length;
  /// the temporary storage `xy` must be `256*r + 64` bytes in length. The arrays `block`, `v`, and `xy` must be
  /// aligned to a multiple of 64 bytes.
  @inline(__always) func smix(_ block: UnsafeMutableRawPointer, _ v: UnsafeMutablePointer<UInt32>, _ xy: UnsafeMutablePointer<UInt32>) {
    let X = xy
    let Y = xy + 32 * self.r
    let Z = xy + 64 * self.r

    /* 1: X <-- B */
    let typedBlock = block.assumingMemoryBound(to: UInt32.self)
    X.assign(from: typedBlock, count: 32 * self.r)

    /* 2: for i = 0 to N - 1 do */
    for i in stride(from: 0, to: self.N, by: 2) {
      /* 3: V_i <-- X */
      UnsafeMutableRawPointer(v + i * (32 * self.r)).copyMemory(from: X, byteCount: 128 * self.r)

      /* 4: X <-- H(X) */
      self.blockMixSalsa8(X, Y, Z)

      /* 3: V_i <-- X */
      UnsafeMutableRawPointer(v + (i + 1) * (32 * self.r)).copyMemory(from: Y, byteCount: 128 * self.r)

      /* 4: X <-- H(X) */
      self.blockMixSalsa8(Y, X, Z)
    }

    /* 6: for i = 0 to N - 1 do */
    for _ in stride(from: 0, to: self.N, by: 2) {
      /*
       7: j <-- Integerify (X) mod N
       where Integerify (B[0] ... B[2 * r - 1]) is defined
       as the result of interpreting B[2 * r - 1] as a little-endian integer.
       */
      var j = Int(integerify(X) & UInt64(self.N - 1))

      /* 8: X <-- H(X \xor V_j) */
      self.blockXor(X, v + j * 32 * self.r, 128 * self.r)
      self.blockMixSalsa8(X, Y, Z)

      /* 7: j <-- Integerify(X) mod N */
      j = Int(self.integerify(Y) & UInt64(self.N - 1))

      /* 8: X <-- H(X \xor V_j) */
      self.blockXor(Y, v + j * 32 * self.r, 128 * self.r)
      self.blockMixSalsa8(Y, X, Z)
    }

    /* 10: B' <-- X */
    for k in 0 ..< 32 * self.r {
      UnsafeMutableRawPointer(block + 4 * k).storeBytes(of: X[k], as: UInt32.self)
    }
  }

  /// Returns the result of parsing `B_{2r-1}` as a little-endian integer.
  @inline(__always) func integerify(_ block: UnsafeRawPointer) -> UInt64 {
    let bi = block + (2 * self.r - 1) * 64
    return bi.load(as: UInt64.self).littleEndian
  }

  /// Compute `bout = BlockMix_{salsa20/8, r}(bin)`.
  ///
  /// The input `bin` must be `128*r` bytes in length; the output `bout` must also be the same size. The temporary
  /// space `x` must be 64 bytes.
  @inline(__always) func blockMixSalsa8(_ bin: UnsafePointer<UInt32>, _ bout: UnsafeMutablePointer<UInt32>, _ x: UnsafeMutablePointer<UInt32>) {
    /* 1: X <-- B_{2r - 1} */
    UnsafeMutableRawPointer(x).copyMemory(from: bin + (2 * self.r - 1) * 16, byteCount: 64)

    /* 2: for i = 0 to 2r - 1 do */
    for i in stride(from: 0, to: 2 * self.r, by: 2) {
      /* 3: X <-- H(X \xor B_i) */
      self.blockXor(x, bin + i * 16, 64)
      self.salsa20_8_typed(x)

      /* 4: Y_i <-- X */
      /* 6: B' <-- (Y_0, Y_2 ... Y_{2r-2}, Y_1, Y_3 ... Y_{2r-1}) */
      UnsafeMutableRawPointer(bout + i * 8).copyMemory(from: x, byteCount: 64)

      /* 3: X <-- H(X \xor B_i) */
      self.blockXor(x, bin + i * 16 + 16, 64)
      self.salsa20_8_typed(x)

      /* 4: Y_i <-- X */
      /* 6: B' <-- (Y_0, Y_2 ... Y_{2r-2}, Y_1, Y_3 ... Y_{2r-1}) */
      UnsafeMutableRawPointer(bout + i * 8 + self.r * 16).copyMemory(from: x, byteCount: 64)
    }
  }

  @inline(__always) func salsa20_8_typed(_ block: UnsafeMutablePointer<UInt32>) {
    self.salsaBlock.copyMemory(from: UnsafeRawPointer(block), byteCount: 64)
    let salsaBlockTyped = self.salsaBlock.assumingMemoryBound(to: UInt32.self)

    for _ in stride(from: 0, to: 8, by: 2) {
      salsaBlockTyped[4] ^= rotateLeft(salsaBlockTyped[0] &+ salsaBlockTyped[12], by: 7)
      salsaBlockTyped[8] ^= rotateLeft(salsaBlockTyped[4] &+ salsaBlockTyped[0], by: 9)
      salsaBlockTyped[12] ^= rotateLeft(salsaBlockTyped[8] &+ salsaBlockTyped[4], by: 13)
      salsaBlockTyped[0] ^= rotateLeft(salsaBlockTyped[12] &+ salsaBlockTyped[8], by: 18)

      salsaBlockTyped[9] ^= rotateLeft(salsaBlockTyped[5] &+ salsaBlockTyped[1], by: 7)
      salsaBlockTyped[13] ^= rotateLeft(salsaBlockTyped[9] &+ salsaBlockTyped[5], by: 9)
      salsaBlockTyped[1] ^= rotateLeft(salsaBlockTyped[13] &+ salsaBlockTyped[9], by: 13)
      salsaBlockTyped[5] ^= rotateLeft(salsaBlockTyped[1] &+ salsaBlockTyped[13], by: 18)

      salsaBlockTyped[14] ^= rotateLeft(salsaBlockTyped[10] &+ salsaBlockTyped[6], by: 7)
      salsaBlockTyped[2] ^= rotateLeft(salsaBlockTyped[14] &+ salsaBlockTyped[10], by: 9)
      salsaBlockTyped[6] ^= rotateLeft(salsaBlockTyped[2] &+ salsaBlockTyped[14], by: 13)
      salsaBlockTyped[10] ^= rotateLeft(salsaBlockTyped[6] &+ salsaBlockTyped[2], by: 18)

      salsaBlockTyped[3] ^= rotateLeft(salsaBlockTyped[15] &+ salsaBlockTyped[11], by: 7)
      salsaBlockTyped[7] ^= rotateLeft(salsaBlockTyped[3] &+ salsaBlockTyped[15], by: 9)
      salsaBlockTyped[11] ^= rotateLeft(salsaBlockTyped[7] &+ salsaBlockTyped[3], by: 13)
      salsaBlockTyped[15] ^= rotateLeft(salsaBlockTyped[11] &+ salsaBlockTyped[7], by: 18)

      salsaBlockTyped[1] ^= rotateLeft(salsaBlockTyped[0] &+ salsaBlockTyped[3], by: 7)
      salsaBlockTyped[2] ^= rotateLeft(salsaBlockTyped[1] &+ salsaBlockTyped[0], by: 9)
      salsaBlockTyped[3] ^= rotateLeft(salsaBlockTyped[2] &+ salsaBlockTyped[1], by: 13)
      salsaBlockTyped[0] ^= rotateLeft(salsaBlockTyped[3] &+ salsaBlockTyped[2], by: 18)

      salsaBlockTyped[6] ^= rotateLeft(salsaBlockTyped[5] &+ salsaBlockTyped[4], by: 7)
      salsaBlockTyped[7] ^= rotateLeft(salsaBlockTyped[6] &+ salsaBlockTyped[5], by: 9)
      salsaBlockTyped[4] ^= rotateLeft(salsaBlockTyped[7] &+ salsaBlockTyped[6], by: 13)
      salsaBlockTyped[5] ^= rotateLeft(salsaBlockTyped[4] &+ salsaBlockTyped[7], by: 18)

      salsaBlockTyped[11] ^= rotateLeft(salsaBlockTyped[10] &+ salsaBlockTyped[9], by: 7)
      salsaBlockTyped[8] ^= rotateLeft(salsaBlockTyped[11] &+ salsaBlockTyped[10], by: 9)
      salsaBlockTyped[9] ^= rotateLeft(salsaBlockTyped[8] &+ salsaBlockTyped[11], by: 13)
      salsaBlockTyped[10] ^= rotateLeft(salsaBlockTyped[9] &+ salsaBlockTyped[8], by: 18)

      salsaBlockTyped[12] ^= rotateLeft(salsaBlockTyped[15] &+ salsaBlockTyped[14], by: 7)
      salsaBlockTyped[13] ^= rotateLeft(salsaBlockTyped[12] &+ salsaBlockTyped[15], by: 9)
      salsaBlockTyped[14] ^= rotateLeft(salsaBlockTyped[13] &+ salsaBlockTyped[12], by: 13)
      salsaBlockTyped[15] ^= rotateLeft(salsaBlockTyped[14] &+ salsaBlockTyped[13], by: 18)
    }
    for i in 0 ..< 16 {
      block[i] = block[i] &+ salsaBlockTyped[i]
    }
  }

  @inline(__always) func blockXor(_ dest: UnsafeMutableRawPointer, _ src: UnsafeRawPointer, _ len: Int) {
    let D = dest.assumingMemoryBound(to: UInt64.self)
    let S = src.assumingMemoryBound(to: UInt64.self)
    let L = len / MemoryLayout<UInt64>.size

    for i in 0 ..< L {
      D[i] ^= S[i]
    }
  }
}
