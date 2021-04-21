//  CryptoSwift
//
//  Copyright (C) 2014-2018 Marcin Krzyżanowski <marcin@krzyzanowskim.com>
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

@usableFromInline
final class StreamDecryptor: Cryptor, Updatable {

  @usableFromInline
  internal let blockSize: Int

  @usableFromInline
  internal var worker: CipherModeWorker

  @usableFromInline
  internal let padding: Padding

  @usableFromInline
  internal var accumulated = Array<UInt8>()

  @usableFromInline
  internal var lastBlockRemainder = 0

  @usableFromInline
  init(blockSize: Int, padding: Padding, _ worker: CipherModeWorker) throws {
    self.blockSize = blockSize
    self.padding = padding
    self.worker = worker
  }

  // MARK: Updatable

  @inlinable
  public func update(withBytes bytes: ArraySlice<UInt8>, isLast: Bool) throws -> Array<UInt8> {
    self.accumulated += bytes

    let toProcess = self.accumulated.prefix(max(self.accumulated.count - self.worker.additionalBufferSize, 0))

    if var finalizingWorker = worker as? FinalizingDecryptModeWorker, isLast == true {
      // will truncate suffix if needed
      try finalizingWorker.willDecryptLast(bytes: self.accumulated.slice)
    }

    var processedBytesCount = 0
    var plaintext = Array<UInt8>(reserveCapacity: bytes.count + self.worker.additionalBufferSize)
    for chunk in toProcess.batched(by: self.blockSize) {
      plaintext += self.worker.decrypt(block: chunk)
      processedBytesCount += chunk.count
    }

    if var finalizingWorker = worker as? FinalizingDecryptModeWorker, isLast == true {
      plaintext = Array(try finalizingWorker.didDecryptLast(bytes: plaintext.slice))
    }

    // omit unecessary calculation if not needed
    if self.padding != .noPadding {
      self.lastBlockRemainder = plaintext.count.quotientAndRemainder(dividingBy: self.blockSize).remainder
    }

    if isLast {
      // CTR doesn't need padding. Really. Add padding to the last block if really want. but... don't.
      plaintext = self.padding.remove(from: plaintext, blockSize: self.blockSize - self.lastBlockRemainder)
    }

    self.accumulated.removeFirst(processedBytesCount) // super-slow

    if var finalizingWorker = worker as? FinalizingDecryptModeWorker, isLast == true {
      plaintext = Array(try finalizingWorker.finalize(decrypt: plaintext.slice))
    }

    return plaintext
  }

  @inlinable
  public func seek(to position: Int) throws {
    guard var worker = self.worker as? SeekableModeWorker else {
      fatalError("Not supported")
    }

    try worker.seek(to: position)
    self.worker = worker
  }
}
