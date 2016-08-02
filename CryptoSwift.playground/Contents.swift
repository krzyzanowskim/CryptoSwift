/*:
 To whom may be concerned: I offer professional support to all my open source projects.
 
 Contact: [marcin@krzyzanowskim.com](http://krzyzanowskim.com)
*/
import CryptoSwift
import Foundation
import XCPlayground

//: # AES
//: One-time shot
do {
    let aes = try AES(key: "passwordpassword", iv: "drowssapdrowssap") // aes128
    let ciphertext = try aes.encrypt("Nullam quis risus eget urna mollis ornare vel eu leo.".utf8.map({$0}))
    print(ciphertext.toHexString())
} catch {
    print(error)
}

//: Incremental encryption
do {
    let aes = try AES(key: "passwordpassword", iv: "drowssapdrowssap") // aes128
    var encryptor = aes.makeEncryptor()

    var ciphertext = Array<UInt8>()
    ciphertext += try encryptor.update(withBytes: "Nullam quis risus ".utf8.map({$0}))
    ciphertext += try encryptor.update(withBytes: "eget urna mollis ".utf8.map({$0}))
    ciphertext += try encryptor.update(withBytes: "ornare vel eu leo.".utf8.map({$0}))
    ciphertext += try encryptor.finish()

    print(ciphertext.toHexString())
} catch {
    print(error)
}

//: Encrypt stream incrementally
do {
    // write until all is written
    func writeToStream(stream: NSOutputStream, bytes: Array<UInt8>) {
        var writtenCount = 0
        while stream.hasSpaceAvailable && writtenCount < bytes.count {
            let c = stream.write(bytes, maxLength: bytes.count)
            if c <= 0 {
                break;
            }

            writtenCount += stream.write(bytes, maxLength: bytes.count)
        }
    }

    let aes = try AES(key: "passwordpassword", iv: "drowssapdrowssap")
    var encryptor = aes.makeEncryptor()

    // prepare streams
    let data = NSData(bytes: (0..<100).map { $0 })
    let inputStream = NSInputStream(data: data)
    let outputStream = NSOutputStream(toMemory: ())
    inputStream.open()
    outputStream.open()

    var buffer = Array<UInt8>(count: 2, repeatedValue: 0)

    // encrypt input stream data and write encrypted result to output stream
    while (inputStream.hasBytesAvailable) {
        let readCount = inputStream.read(&buffer, maxLength: buffer.count)
        if (readCount > 0) {
            try encryptor.update(withBytes: buffer[0..<readCount]) { (bytes) in
                writeToStream(outputStream, bytes: bytes)
            }
        }
    }

    // finalize encryption
    try encryptor.finish { (bytes) in
        writeToStream(outputStream, bytes: bytes)
    }

    // print result
    if let ciphertext = outputStream.propertyForKey(NSStreamDataWrittenToMemoryStreamKey) as? NSData {
        print("Encrypted stream data: \(ciphertext.toHexString())")
    }

} catch {
    print(error)
}
