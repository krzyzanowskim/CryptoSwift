/*:
 To whom may be concerned: I offer professional support to all my open source projects.
 
 Contact: [marcin@krzyzanowskim.com](http://krzyzanowskim.com)
*/
import CryptoSwift
import Foundation
import XCPlayground

/*: 
 # AES
 ### One-time shot.
 Encrypt all data at once.
 */
do {
    let aes = try AES(key: "passwordpassword", iv: "drowssapdrowssap")
    let ciphertext = try aes.encrypt("Nullam quis risus eget urna mollis ornare vel eu leo.".utf8.map({$0}))
    print(ciphertext.toHexString())
} catch {
    print(error)
}

/*:
 ### Incremental encryption

 Instantiate Encryptor for AES encryption (or decryptor for decryption) and process input data partially.
 */
do {
    var encryptor = try AES(key: "passwordpassword", iv: "drowssapdrowssap").makeEncryptor()

    var ciphertext = Array<UInt8>()
    // aggregate partial results
    ciphertext += try encryptor.update(withBytes: "Nullam quis risus ".utf8.map({$0}))
    ciphertext += try encryptor.update(withBytes: "eget urna mollis ".utf8.map({$0}))
    ciphertext += try encryptor.update(withBytes: "ornare vel eu leo.".utf8.map({$0}))
    // finish at the end
    ciphertext += try encryptor.finish()

    print(ciphertext.toHexString())
} catch {
    print(error)
}

/*:
 ### Encrypt stream
 */
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
    let data = Data(bytes: (0..<100).map { $0 })
    let inputStream = InputStream(data: data)
    let outputStream = NSOutputStream(toMemory: ())
    inputStream.open()
    outputStream.open()

    var buffer = Array<UInt8>(repeating: 0, count: 2)

    // encrypt input stream data and write encrypted result to output stream
    while (inputStream.hasBytesAvailable) {
        let readCount = inputStream.read(&buffer, maxLength: buffer.count)
        if (readCount > 0) {
            try encryptor.update(withBytes: Array(buffer[0..<readCount])) { (bytes) in
                writeToStream(stream: outputStream, bytes: bytes)
            }
        }
    }

    // finalize encryption
    try encryptor.finish { (bytes) in
        writeToStream(stream: outputStream, bytes: bytes)
    }

    // print result
    if let ciphertext = outputStream.property(forKey: Stream.PropertyKey.dataWrittenToMemoryStreamKey.rawValue) as? Data {
        print("Encrypted stream data: \(ciphertext.toHexString())")
    }

} catch {
    print(error)
}
