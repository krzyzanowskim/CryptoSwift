/*:
 To whom may be concerned: I offer professional support to all my open source projects.
 
 Contact: [marcin@krzyzanowskim.com](http://krzyzanowskim.com)
*/
import CryptoSwift

//: # AES
//: One-time shot
do {
    let aes = try AES(key: "passwordpassword", iv: "drowssapdrowssap")
    let ciphertext = try aes.encrypt("Nullam quis risus eget urna mollis ornare vel eu leo.".utf8.map({$0}))
    print(ciphertext.toHexString())
} catch {
    print(error)
}

//: Incremental encryption
do {
    let aes = try AES(key: "passwordpassword", iv: "drowssapdrowssap")
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
