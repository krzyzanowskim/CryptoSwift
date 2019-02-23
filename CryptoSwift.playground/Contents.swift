/*:
 To whom may be concerned: I offer professional support to all my open source projects.

 Contact: [marcin@krzyzanowskim.com](http://krzyzanowskim.com)
 */
import CryptoSwift
import Foundation
/*:
 # Data types conversinn
 */
let data = Data([0x01, 0x02, 0x03])
let bytes = data.bytes
let bytesHex = Array<UInt8>(hex: "0x010203")
let hexString = bytesHex.toHexString()

/*:
 # Digest
 */
data.md5()
data.sha1()
data.sha224()
data.sha256()
data.sha384()
data.sha512()

bytes.sha1()
"123".sha1()
Digest.sha1(bytes)

//: Digest calculated incrementally
do {
    var digest = MD5()
    _ = try digest.update(withBytes: [0x31, 0x32])
    _ = try digest.update(withBytes: [0x33])
    let result = try digest.finish()
    result.toBase64()
} catch {}

/*:
 # CRC
 */
bytes.crc16()
bytes.crc32()
bytes.crc32c()

/*:
 # HMAC
 */

do {
    let key: Array<UInt8> = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 23, 25, 26, 27, 28, 29, 30, 31, 32]
    try Poly1305(key: key).authenticate(bytes)
    try HMAC(key: key, variant: .sha256).authenticate(bytes)
} catch {}

/*:
 # PBKDF1, PBKDF2
 */

do {
    let password: Array<UInt8> = Array("s33krit".utf8)
    let salt: Array<UInt8> = Array("nacllcan".utf8)

    try PKCS5.PBKDF1(password: password, salt: salt, variant: .sha1, iterations: 4096).calculate()

    let value = try PKCS5.PBKDF2(password: password, salt: salt, iterations: 4096, variant: .sha256).calculate()
    print(value)
} catch {}

/*:
 # Padding
 */
Padding.pkcs7.add(to: bytes, blockSize: AES.blockSize)

/*:
 # ChaCha20
 */

do {
    let key: Array<UInt8> = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32]
    let iv: Array<UInt8> = [1, 2, 3, 4, 5, 6, 7, 8]
    let message = Array<UInt8>(repeating: 7, count: 10)

    let encrypted = try ChaCha20(key: key, iv: iv).encrypt(message)
    let decrypted = try ChaCha20(key: key, iv: iv).decrypt(encrypted)
    print(decrypted)
} catch {
    print(error)
}

/*:
 # AES
 ### One-time shot.
 Encrypt all data at once.
 */
do {
    let aes = try AES(key: "passwordpassword", iv: "drowssapdrowssap") // aes128
    let ciphertext = try aes.encrypt(Array("Nullam quis risus eget urna mollis ornare vel eu leo.".utf8))
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
    ciphertext += try encryptor.update(withBytes: Array("Nullam quis risus ".utf8))
    ciphertext += try encryptor.update(withBytes: Array("eget urna mollis ".utf8))
    ciphertext += try encryptor.update(withBytes: Array("ornare vel eu leo.".utf8))
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
    func writeTo(stream: OutputStream, bytes: Array<UInt8>) {
        var writtenCount = 0
        while stream.hasSpaceAvailable && writtenCount < bytes.count {
            writtenCount += stream.write(bytes, maxLength: bytes.count)
        }
    }

    let aes = try AES(key: "passwordpassword", iv: "drowssapdrowssap")
    var encryptor = try! aes.makeEncryptor()

    // prepare streams
    let data = Data( (0 ..< 100).map { $0 })
    let inputStream = InputStream(data: data)
    let outputStream = OutputStream(toMemory: ())
    inputStream.open()
    outputStream.open()

    var buffer = Array<UInt8>(repeating: 0, count: 2)

    // encrypt input stream data and write encrypted result to output stream
    while inputStream.hasBytesAvailable {
        let readCount = inputStream.read(&buffer, maxLength: buffer.count)
        if readCount > 0 {
            try encryptor.update(withBytes: buffer[0 ..< readCount]) { bytes in
                writeTo(stream: outputStream, bytes: bytes)
            }
        }
    }

    // finalize encryption
    try encryptor.finish { bytes in
        writeTo(stream: outputStream, bytes: bytes)
    }

    // print result
    if let ciphertext = outputStream.property(forKey: Stream.PropertyKey(rawValue: Stream.PropertyKey.dataWrittenToMemoryStreamKey.rawValue)) as? Data {
        print("Encrypted stream data: \(ciphertext.toHexString())")
    }

} catch {
    print(error)
}
