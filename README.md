[![Platform](https://img.shields.io/badge/Platforms-Apple%20platforms%20%7C%20Linux%20%7C%20Android-4E4E4E.svg?colorA=28a745)](#requirements)

[![Swift support](https://img.shields.io/badge/Swift-5.6%2B-lightgrey.svg?colorA=28a745&colorB=4E4E4E)](#requirements)
[![Swift Package Manager compatible](https://img.shields.io/badge/SPM-compatible-brightgreen.svg?style=flat&colorA=28a745&&colorB=4E4E4E)](https://github.com/swiftlang/swift-package-manager)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-brightgreen.svg?style=flat&colorA=28a745&&colorB=4E4E4E)](https://github.com/Carthage/Carthage)
[![CocoaPods Deprecated](https://img.shields.io/cocoapods/v/CryptoSwift.svg?style=flat&label=CocoaPods&colorA=red&&colorB=4E4E4E)](https://cocoapods.org/pods/CryptoSwift)

# CryptoSwift

Pure Swift cryptographic primitives and utilities for [Swift](https://swift.org). ([#PureSwift](https://twitter.com/hashtag/pureswift))

**Note**: The current release line builds with Swift 5.6 and newer toolchains. If you need an older compiler, use the matching legacy branch listed in [Swift version support](#swift-version-support). Older branches are not actively maintained.

---

[Requirements](#requirements) | [Features](#features) | [Recommended Defaults](#recommended-defaults) | [Contribution](#contribution) | [Installation](#installation) | [Swift Version Support](#swift-version-support) | [How-to](#how-to) | [Author](#author) | [License](#license) | [Changelog](#changelog)

### Support & Sponsors

The financial sustainability of the project is possible thanks to the ongoing contributions from our [GitHub Sponsors](https://github.com/sponsors/krzyzanowskim)

### Premium Sponsors

  [Emerge Tools](https://www.emergetools.com/) is a suite of revolutionary products designed to supercharge mobile apps and the teams that build them.

  [<img alt="www.emergetools.com/" width="200" src="https://github-production-user-asset-6210df.s3.amazonaws.com/758033/256565082-a21f5ac1-ef39-4b56-a8d2-575adeb7fe55.png" />](https://www.emergetools.com)

## Requirements

Good mood

- Swift 5.6 or newer
- Apple deployment targets: iOS 11, macOS 10.13, Mac Catalyst 13, tvOS 11, watchOS 4, visionOS 1
- Linux and Android are exercised in CI

## Features

- Pure Swift implementation
- Convenient extensions for `String`, `Data`, and `Array<UInt8>`
- Support for incremental updates and streaming APIs
- Apple platforms, Linux, and Android support

#### Hash (Digest)
  [MD5](https://tools.ietf.org/html/rfc1321)
| [SHA1](https://tools.ietf.org/html/rfc3174)
| [SHA2-224](https://tools.ietf.org/html/rfc6234)
| [SHA2-256](https://tools.ietf.org/html/rfc6234)
| [SHA2-384](https://tools.ietf.org/html/rfc6234)
| [SHA2-512](https://tools.ietf.org/html/rfc6234)
| [SHA3](https://nvlpubs.nist.gov/nistpubs/FIPS/NIST.FIPS.202.pdf)

#### Cyclic Redundancy Check (CRC)
  [CRC32](https://en.wikipedia.org/wiki/Cyclic_redundancy_check)
| [CRC32C](https://en.wikipedia.org/wiki/Cyclic_redundancy_check)
| [CRC16](https://en.wikipedia.org/wiki/Cyclic_redundancy_check)

#### Cipher
  [AES-128, AES-192, AES-256](http://csrc.nist.gov/publications/fips/fips197/fips-197.pdf)
| [ChaCha20](http://cr.yp.to/chacha/chacha-20080128.pdf)
| [XChaCha20](https://datatracker.ietf.org/doc/html/draft-irtf-cfrg-xchacha)
| [Rabbit](https://tools.ietf.org/html/rfc4503)
| [Blowfish](https://www.schneier.com/academic/blowfish/)

#### RSA (public-key encryption algorithm)
  [Encryption, Signature](https://github.com/krzyzanowskim/CryptoSwift#rsa)

#### Message authenticators
  [Poly1305](https://cr.yp.to/mac/poly1305-20050329.pdf)
| [HMAC (MD5, SHA1, SHA256)](https://www.ietf.org/rfc/rfc2104.txt)
| [CMAC](https://tools.ietf.org/html/rfc4493)
| [CBC-MAC](https://en.wikipedia.org/wiki/CBC-MAC)

#### Cipher mode of operation
- Electronic codebook ([ECB](https://en.wikipedia.org/wiki/Block_cipher_mode_of_operation#Electronic_codebook_.28ECB.29))
- Cipher-block chaining ([CBC](https://en.wikipedia.org/wiki/Block_cipher_mode_of_operation#Cipher-block_chaining_.28CBC.29))
- Propagating Cipher Block Chaining ([PCBC](https://en.wikipedia.org/wiki/Block_cipher_mode_of_operation#Propagating_Cipher_Block_Chaining_.28PCBC.29))
- Cipher feedback ([CFB](https://en.wikipedia.org/wiki/Block_cipher_mode_of_operation#Cipher_feedback_.28CFB.29))
- Output Feedback ([OFB](https://en.wikipedia.org/wiki/Block_cipher_mode_of_operation#Output_Feedback_.28OFB.29))
- Counter Mode ([CTR](https://en.wikipedia.org/wiki/Block_cipher_mode_of_operation#Counter_.28CTR.29))
- Galois/Counter Mode ([GCM](https://csrc.nist.gov/publications/detail/sp/800-38d/final))
- Counter with Cipher Block Chaining-Message Authentication Code ([CCM](https://csrc.nist.gov/publications/detail/sp/800-38c/final))
- OCB Authenticated-Encryption Algorithm ([OCB](https://tools.ietf.org/html/rfc7253))

#### Password-Based Key Derivation Function
- [PBKDF1](https://tools.ietf.org/html/rfc2898#section-5.1) (Password-Based Key Derivation Function 1)
- [PBKDF2](https://tools.ietf.org/html/rfc2898#section-5.2) (Password-Based Key Derivation Function 2)
- [HKDF](https://tools.ietf.org/html/rfc5869) (HMAC-based Extract-and-Expand Key Derivation Function)
- [Scrypt](https://tools.ietf.org/html/rfc7914) (The scrypt Password-Based Key Derivation Function)

#### Data padding
- [PKCS#5](https://www.rfc-editor.org/rfc/rfc2898.html)
- [EMSA-PKCS1-v1_5 (Encoding Method for Signature)](https://www.rfc-editor.org/rfc/rfc3447#section-9.2)
- [EME-PKCS1-v1_5 (Encoding Method for Encryption)](https://www.rfc-editor.org/rfc/rfc3447)
- [PKCS#7](https://tools.ietf.org/html/rfc5652#section-6.3)
- [Zero padding](https://en.wikipedia.org/wiki/Padding_(cryptography)#Zero_padding)
- [ISO/IEC 7816-4](https://www.embedx.com/pdfs/ISO_STD_7816/info_isoiec7816-4%7Bed21.0%7Den.pdf)
- [ISO10126](https://en.wikipedia.org/wiki/Padding_(cryptography)#ISO_10126)
- No padding

#### Authenticated Encryption with Associated Data (AEAD)
- [AEAD\_CHACHA20\_POLY1305](https://tools.ietf.org/html/rfc7539#section-2.8)
- [AEAD\_XCHACHA20\_POLY1305](https://datatracker.ietf.org/doc/html/draft-irtf-cfrg-xchacha#section-2)

## Recommended Defaults

- Prefer AEAD constructions such as AES-GCM, AES-CCM, ChaCha20-Poly1305, or XChaCha20-Poly1305 for new protocols.
- Prefer SHA-256, SHA-512, or SHA-3 over MD5 and SHA-1.
- Use a fresh IV or nonce for every encryption operation.
- Use RSA keys of at least 2048 bits for new systems.
- Treat MD5, SHA-1, ECB, CBC-MAC, and PKCS#1 v1.5 compatibility paths as legacy interoperability features.

## Why
[Why?](https://github.com/krzyzanowskim/CryptoSwift/discussions/982) [Because I can](https://github.com/krzyzanowskim/CryptoSwift/discussions/982#discussioncomment-3669415).

## How do I get involved?

You want to help, great! Go ahead and fork our repo, make your changes and send us a pull request.

## Contribution

Check out [CONTRIBUTING.md](CONTRIBUTING.md) for more information on how to help with CryptoSwift.

- If you found a bug, [open a discussion](https://github.com/krzyzanowskim/CryptoSwift/discussions).
- If you have a feature request, [open a discussion](https://github.com/krzyzanowskim/CryptoSwift/discussions).

## Installation

### Swift Package Manager

CryptoSwift is primarily distributed as source through [Swift Package Manager](https://swift.org/package-manager/).

Add the package dependency:

```swift
dependencies: [
  .package(url: "https://github.com/krzyzanowskim/CryptoSwift.git", from: "1.10.0")
]
```

Then add the product to the target that uses it:

```swift
.target(
  name: "MyTarget",
  dependencies: [
    .product(name: "CryptoSwift", package: "CryptoSwift")
  ]
)
```

If you profile crypto-heavy workloads from Xcode, compare Debug and Release builds before drawing conclusions. Debug builds can be dramatically slower than optimized Release builds.

### XCFramework

If you prefer a prebuilt optimized binary for manual Xcode integration, build `CryptoSwift.xcframework` locally:

```sh
./scripts/build-framework.sh
```

The generated `CryptoSwift.xcframework` is an alternative to source-based Swift Package Manager integration. It is not used by the package defined in [Package.swift](Package.swift).

<img width="320" alt="Screen Shot 2020-10-27 at 00 06 32" src="https://user-images.githubusercontent.com/758033/97240586-f0878280-17ee-11eb-9119-e5a960417d04.png">

### Hardened Runtime (macOS) and Xcode

If you embed the prebuilt `CryptoSwift.xcframework` in a hardened macOS app, library validation can prevent the binary from loading when the app is signed with `Sign to Run Locally`.

To avoid that, use one of these options:
- Sign the app with a proper Development certificate.
- Enable `Disable Library Validation` (`com.apple.security.cs.disable-library-validation`) for the app.

### Xcode Project

To vendor CryptoSwift directly in an Xcode project, add it as a submodule from the top-level project directory:

```sh
git submodule add https://github.com/krzyzanowskim/CryptoSwift.git
```

Enable [Whole-Module Optimization](https://swift.org/blog/whole-module-optimizations/) for best performance. Non-optimized builds of crypto-heavy code are significantly slower.

### Legacy Package Managers

#### Carthage

You can use [Carthage](https://github.com/Carthage/Carthage) for existing projects.
Specify in `Cartfile`:

```ruby
github "krzyzanowskim/CryptoSwift"
```

Run `carthage` to build the framework and drag the built `CryptoSwift.framework` into your Xcode project. Follow the [Carthage getting started guide](https://github.com/Carthage/Carthage#getting-started). See [common issues](https://github.com/krzyzanowskim/CryptoSwift/discussions/983#discussioncomment-3669433) if the build fails.

#### CocoaPods

> **Note**: CocoaPods is deprecated for new CryptoSwift integrations. Prefer Swift Package Manager. Keep CocoaPods only when you need it for an existing project.

You can still use [CocoaPods](https://cocoapods.org/pods/CryptoSwift).

```ruby
pod 'CryptoSwift', '~> 1.10.0'
```

CocoaPods builds may need manual optimization settings if performance matters. You can adjust them after installation, or use the [cocoapods-wholemodule](https://github.com/jedlewison/cocoapods-wholemodule) plugin.

### Embedded Framework

Embedded frameworks require a minimum deployment target of iOS 11.0 or macOS 10.13. Drag `CryptoSwift.xcodeproj` into your Xcode project, add the appropriate framework as a dependency, then embed `CryptoSwift.framework` in your app target.

![](https://cloud.githubusercontent.com/assets/758033/10834511/25a26852-7e9a-11e5-8c01-6cc8f1838459.png)

Sometimes the embedded framework option is not available automatically. In that case, add a new build phase for the target.

![](https://cloud.githubusercontent.com/assets/758033/18415615/d5edabb0-77f8-11e6-8c94-f41d9fc2b8cb.png)

#### iOS, macOS, watchOS, tvOS

In the project, you'll find [single scheme](https://mxcl.dev/PromiseKit/news/2016/08/Multiplatform-Single-Scheme-Xcode-Projects/) for all platforms:
- CryptoSwift

### Swift Version Support

- Current release line: Swift 5.6 and newer toolchains

Legacy compiler branches:

- Swift 1.2: branch [swift12](https://github.com/krzyzanowskim/CryptoSwift/tree/swift12) version <= 0.0.13
- Swift 2.1: branch [swift21](https://github.com/krzyzanowskim/CryptoSwift/tree/swift21) version <= 0.2.3
- Swift 2.2, 2.3: branch [swift2](https://github.com/krzyzanowskim/CryptoSwift/tree/swift2) version <= 0.5.2
- Swift 3.1, branch [swift3](https://github.com/krzyzanowskim/CryptoSwift/tree/swift3) version <= 0.6.9
- Swift 3.2, branch [swift32](https://github.com/krzyzanowskim/CryptoSwift/tree/swift32) version = 0.7.0
- Swift 4.0, branch [swift4](https://github.com/krzyzanowskim/CryptoSwift/tree/swift4) version <= 0.12.0
- Swift 4.2, branch [swift42](https://github.com/krzyzanowskim/CryptoSwift/tree/swift42) version <= 0.15.0
- Swift 5.0, branch [swift5](https://github.com/krzyzanowskim/CryptoSwift/tree/swift5) version <= 1.2.0
- Swift 5.1, branch [swift51](https://github.com/krzyzanowskim/CryptoSwift/tree/swift51) version <= 1.3.3
- Swift 5.3, branch [swift53](https://github.com/krzyzanowskim/CryptoSwift/tree/swift53) version <= 1.8.5
- Swift 5.6 and newer, branch [main](https://github.com/krzyzanowskim/CryptoSwift/tree/main)

## How-to

* [Basics (data types, conversion, ...)](#basics)
* [Digest (MD5, SHA...)](#calculate-digest)
* [Message authenticators (HMAC, CMAC...)](#message-authenticators-1)
* [Password-Based Key Derivation Function (PBKDF2, ...)](#password-based-key-derivation-functions)
* [HMAC-based Key Derivation Function (HKDF)](#hmac-based-key-derivation-function)
* [Data Padding](#data-padding)
* [AEAD (ChaCha20-Poly1305)](#aead)
* [AES-GCM](#aes-gcm)
* [AES-CCM](#aes-ccm)
* [AES - Advanced Encryption Standard](#aes)
* [ChaCha20](#chacha20)
* [Rabbit](#rabbit)
* [Blowfish](#blowfish)
* [RSA](#rsa)

For new designs, start with an AEAD construction such as AES-GCM, AES-CCM, or ChaCha20-Poly1305. Use raw block modes only when you need compatibility with an existing protocol.

##### Basics

```swift
import CryptoSwift
```

CryptoSwift uses array of bytes aka `Array<UInt8>` as a base type for all operations. Every data may be converted to a stream of bytes. You will find convenience functions that accept `String` or `Data`, and it will be internally converted to the array of bytes.

##### Data types conversion

For your convenience, **CryptoSwift** provides two functions to easily convert an array of bytes to `Data` or `Data` to an array of bytes:

Data from bytes:

```swift
let data = Data([0x01, 0x02, 0x03])
```

`Data` to `Array<UInt8>`

```swift
let bytes = data.byteArray                // [1,2,3]
```

[Hexadecimal](https://en.wikipedia.org/wiki/Hexadecimal) encoding:

```swift
let bytes = Array<UInt8>(hex: "0x010203")  // [1,2,3]
let hex   = bytes.toHexString()            // "010203"
```

Build bytes out of `String`
```swift
let bytes: Array<UInt8> = "cipherkey".bytes  // Array("cipherkey".utf8)
```

Also... check out helpers that work with **Base64** encoded data:
```swift
"aPf/i9th9iX+vf49eR7PYk2q7S5xmm3jkRLejgzHNJs=".decryptBase64ToString(cipher)
"aPf/i9th9iX+vf49eR7PYk2q7S5xmm3jkRLejgzHNJs=".decryptBase64(cipher)
bytes.toBase64()
```

##### Calculate Digest

Hashing an array of bytes (`Array<UInt8>`)
```swift
let input: Array<UInt8> = [0x01, 0x02, 0x03]

let md5Digest = input.md5()
let md5Digest2 = Digest.md5(input)
```

Hashing `Data`

```swift
let data = Data([0x01, 0x02, 0x03])

let md5Digest = data.md5()
let sha1Digest = data.sha1()
let sha224Digest = data.sha224()
let sha256Digest = data.sha256()
let sha384Digest = data.sha384()
let sha512Digest = data.sha512()
```
```swift
do {
    var digest = MD5()
    _ = try digest.update(withBytes: [0x31, 0x32])
    _ = try digest.update(withBytes: [0x33])
    let result = try digest.finish()
} catch {
    print(error)
}
```

Hashing a String and printing result

```swift
let hash = "123".md5() // "123".bytes.md5()
```

##### Calculate CRC

```swift
let bytes: Array<UInt8> = [0x01, 0x02, 0x03]
let data = Data(bytes)

let bytesCRC16 = bytes.crc16()
let dataCRC16 = data.crc16()

let bytesCRC32 = bytes.crc32()
let dataCRC32 = data.crc32()
```

##### Message authenticators

```swift
// Calculate Message Authentication Code (MAC) for message
let key = Array<UInt8>(repeating: 0x01, count: 32)
let message = Array("authenticated message".utf8)

let poly1305 = try Poly1305(key: key).authenticate(message)
let hmac = try HMAC(key: key, variant: .sha2(.sha256)).authenticate(message)
let cmac = try CMAC(key: key).authenticate(message)
```

##### Password-Based Key Derivation Functions

```swift
let password: Array<UInt8> = Array("s33krit".utf8)
let salt: Array<UInt8> = Array("nacllcan".utf8)

let key = try PKCS5.PBKDF2(password: password, salt: salt, iterations: 4096, keyLength: 32, variant: .sha2(.sha256)).calculate()
```

```swift
let password: Array<UInt8> = Array("s33krit".utf8)
let salt: Array<UInt8> = Array("nacllcan".utf8)
// Scrypt implementation does not implement work parallelization, so `p` parameter will
// increase the work time even in multicore systems
let key = try Scrypt(password: password, salt: salt, dkLen: 64, N: 16384, r: 8, p: 1).calculate()
```

##### HMAC-based Key Derivation Function

```swift
let password: Array<UInt8> = Array("s33krit".utf8)
let salt: Array<UInt8> = Array("nacllcan".utf8)

let key = try HKDF(password: password, salt: salt, variant: .sha2(.sha256)).calculate()
```


##### Data Padding

Some content-encryption algorithms assume the input length is a multiple of `k` octets, where `k` is greater than one. For such algorithms, the input shall be padded.

```swift
let input = Array("hello".utf8)
let padded = Padding.pkcs7.add(to: input, blockSize: AES.blockSize)
```

#### Working with Ciphers

Examples below use `[UInt8]` keys, IVs or nonces, and messages of the correct length for the selected algorithm.
##### ChaCha20

```swift
let encrypted = try ChaCha20(key: key, iv: iv).encrypt(message)
let decrypted = try ChaCha20(key: key, iv: iv).decrypt(encrypted)
```

##### Rabbit

```swift
let encrypted = try Rabbit(key: key, iv: iv).encrypt(message)
let decrypted = try Rabbit(key: key, iv: iv).decrypt(encrypted)
```
##### Blowfish

```swift
let encrypted = try Blowfish(key: key, blockMode: CBC(iv: iv), padding: .pkcs7).encrypt(message)
let decrypted = try Blowfish(key: key, blockMode: CBC(iv: iv), padding: .pkcs7).decrypt(encrypted)
```

##### AES

For new designs, prefer AES-GCM unless you need compatibility with an existing CBC, CFB, OFB, or CTR protocol.

Notice regarding padding: *Manual padding of data is optional, and CryptoSwift uses PKCS7 padding by default. If you need to manually disable or enable padding, configure the `AES` initializer explicitly.*

Variant of AES encryption (AES-128, AES-192, AES-256) depends on given key length:

- AES-128 = 16 bytes
- AES-192 = 24 bytes
- AES-256 = 32 bytes

AES-256 example

```swift
let aes = try AES(key: [1,2,3 /* ... 32 bytes total */], blockMode: CBC(iv: [1,2,3 /* ... 16 bytes total */]), padding: .pkcs7)
let encryptedBytes = try aes.encrypt(Array("secret message".utf8))
```

Full example:

```swift
let password: [UInt8] = Array("s33krit".utf8)
let salt: [UInt8] = Array("nacllcan".utf8)

/* Generate a key from a `password`. Optional if you already have a key */
let key = try PKCS5.PBKDF2(
    password: password,
    salt: salt,
    iterations: 4096,
    keyLength: 32, /* AES-256 */
    variant: .sha2(.sha256)
).calculate()

/* Generate random IV value. IV is public value. Either need to generate, or get it from elsewhere */
let iv = AES.randomIV(AES.blockSize)

/* AES cryptor instance */
let aes = try AES(key: key, blockMode: CBC(iv: iv), padding: .pkcs7)

/* Encrypt Data */
let inputData = Data()
let encryptedBytes = try aes.encrypt(inputData.byteArray)
let encryptedData = Data(encryptedBytes)

/* Decrypt Data */
let decryptedBytes = try aes.decrypt(encryptedData.byteArray)
let decryptedData = Data(decryptedBytes)
```

###### All at once
```swift
do {
    let aes = try AES(key: "keykeykeykeykeyk", iv: "drowssapdrowssap") // aes128
    let ciphertext = try aes.encrypt(Array("Nullam quis risus eget urna mollis ornare vel eu leo.".utf8))
} catch { }
```

###### Incremental updates

Incremental operations use instance of Cryptor and encrypt/decrypt one part at a time, this way you can save on memory for large files.

```swift
do {
    var encryptor = try AES(key: "keykeykeykeykeyk", iv: "drowssapdrowssap").makeEncryptor()

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
```

###### AES Advanced usage
```swift
let input: Array<UInt8> = [0,1,2,3,4,5,6,7,8,9]

let key: Array<UInt8> = [0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00]
let iv: Array<UInt8> = [] // Random bytes of `AES.blockSize` length

do {
    let encrypted = try AES(key: key, blockMode: CBC(iv: iv), padding: .pkcs7).encrypt(input)
    let decrypted = try AES(key: key, blockMode: CBC(iv: iv), padding: .pkcs7).decrypt(encrypted)
} catch {
    print(error)
}
```

AES without data padding

```swift
let input: Array<UInt8> = [0,1,2,3,4,5,6,7,8,9]
let encrypted: Array<UInt8> = try! AES(key: Array("secret0key000000".utf8), blockMode: CBC(iv: Array("0123456789012345".utf8)), padding: .noPadding).encrypt(input)
```

Using convenience extensions

```swift
let plain = Data([0x01, 0x02, 0x03])
let encrypted = try! plain.encrypt(ChaCha20(key: key, iv: iv))
let decrypted = try! encrypted.decrypt(ChaCha20(key: key, iv: iv))
```

##### AES-GCM

The result of Galois/Counter Mode (GCM) encryption is ciphertext and **authentication tag**, which is later used for decryption.

encryption

```swift
do {
    // In combined mode, the authentication tag is directly appended to the encrypted message. This is usually what you want.
    let gcm = GCM(iv: iv, mode: .combined)
    let aes = try AES(key: key, blockMode: gcm, padding: .noPadding)
    let encrypted = try aes.encrypt(plaintext)
    let tag = gcm.authenticationTag
} catch {
    // failed
}
```

decryption

```swift
do {
    // In combined mode, the authentication tag is appended to the encrypted message. This is usually what you want.
    let gcm = GCM(iv: iv, mode: .combined)
    let aes = try AES(key: key, blockMode: gcm, padding: .noPadding)
    let decrypted = try aes.decrypt(encrypted)
} catch {
    // failed
}
```

**Note**: GCM instance is not intended to be reused. So you can't use the same `GCM` instance from encoding to also perform decoding.

##### AES-CCM

The result of Counter with Cipher Block Chaining-Message Authentication Code encryption is ciphertext and **authentication tag**, which is later used for decryption.

```swift
do {
    // `encrypted` contains ciphertext with the authentication tag appended.
	let tagLength = 8
	let ccm = CCM(iv: iv, tagLength: tagLength, messageLength: encrypted.count - tagLength, additionalAuthenticatedData: data)
    let aes = try AES(key: key, blockMode: ccm, padding: .noPadding)
    let decrypted = try aes.decrypt(encrypted)
} catch {
    // failed
}
```

Check documentation or CCM specification for valid parameters for CCM.

##### AEAD

```swift
let sealed = try AEADChaCha20Poly1305.encrypt(plaintext, key: key, iv: nonce, authenticationHeader: header)
let opened = try AEADChaCha20Poly1305.decrypt(
  sealed.cipherText,
  key: key,
  iv: nonce,
  authenticationHeader: header,
  authenticationTag: sealed.authenticationTag
)
```

##### RSA

RSA initialization from parameters

```swift
let input: Array<UInt8> = [0,1,2,3,4,5,6,7,8,9]

let n: Array<UInt8> = [] // RSA modulus
let e: Array<UInt8> = [] // RSA public exponent
let d: Array<UInt8> = [] // RSA private exponent

let rsa = RSA(n: n, e: e, d: d)

do {
    let encrypted = try rsa.encrypt(input)
    let decrypted = try rsa.decrypt(encrypted)
} catch {
    print(error)
}
```

RSA key generation

```swift
let rsa = try RSA(keySize: 2048) // This generates a modulus, public exponent and private exponent with the given size
```

RSA Encryption & Decryption Example
``` swift
// Alice Generates a Private Key
let alicesPrivateKey = try RSA(keySize: 2048)
    
// Alice shares her **public** key with Bob
let alicesPublicKeyData = try alicesPrivateKey.publicKeyExternalRepresentation()
    
// Bob receives the raw external representation of Alice's public key and imports it
let bobsImportOfAlicesPublicKey = try RSA(rawRepresentation: alicesPublicKeyData)
    
// Bob can now encrypt a message for Alice using her public key
let message = "Hi Alice! This is Bob!"
let privateMessage = try bobsImportOfAlicesPublicKey.encrypt(message.bytes)
    
// This results in some encrypted output like this
// URcRwG6LfH63zOQf2w+HIllPri9Rb6hFlXbi/bh03zPl2MIIiSTjbAPqbVFmoF3RmDzFjIarIS7ZpT57a1F+OFOJjx50WYlng7dioKFS/rsuGHYnMn4csjCRF6TAqvRQcRnBueeINRRA8SLaLHX6sZuQkjIE5AoHJwgavmiv8PY=
      
// Bob can now send this encrypted message to Alice without worrying about people being able to read the original contents
    
// Alice receives the encrypted message and uses her private key to decrypt the data and recover the original message
let originalDecryptedMessage = try alicesPrivateKey.decrypt(privateMessage)
    
print(String(data: Data(originalDecryptedMessage), encoding: .utf8))
// "Hi Alice! This is Bob!"
```

RSA Signature & Verification Example
``` swift
// Alice Generates a Private Key
let alicesPrivateKey = try RSA(keySize: 2048)
    
// Alice wants to sign a message that she agrees with
let messageAliceSupports = "Hi my name is Alice!"
let alicesSignature = try alicesPrivateKey.sign(messageAliceSupports.bytes)
    
// Alice shares her Public key and the signature with Bob
let alicesPublicKeyData = try alicesPrivateKey.publicKeyExternalRepresentation()
    
// Bob receives the raw external representation of Alice's public key and imports it!
let bobsImportOfAlicesPublicKey = try RSA(rawRepresentation: alicesPublicKeyData)
        
// Bob can now verify that Alice signed the message using the Private key associated with her shared Public key.
let verifiedSignature = try bobsImportOfAlicesPublicKey.verify(signature: alicesSignature, for: "Hi my name is Alice!".bytes)
    
if verifiedSignature == true {
  // Bob knows that the signature Alice provided is valid for the message and was signed using the Private key associated with Alice's shared Public key.
} else {
  // The signature was invalid, so either
  // - the message Alice signed was different than what we expected.
  // - or Alice used a Private key that isn't associated with the shared Public key that Bob has.
}
```

These `SecKey` interoperability examples are available on Apple platforms only.

CryptoSwift RSA Key -> Apple's Security Framework SecKey Example
``` swift
/// Starting with a CryptoSwift RSA Key
let rsaKey = try RSA(keySize: 2048)

/// Define your Keys attributes
let attributes: [String:Any] = [
  kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
  kSecAttrKeyClass as String: kSecAttrKeyClassPrivate, // or kSecAttrKeyClassPublic
  kSecAttrKeySizeInBits as String: 2048, // The appropriate bits
  kSecAttrIsPermanent as String: false
]
var error:Unmanaged<CFError>? = nil
guard let rsaSecKey = try SecKeyCreateWithData(rsaKey.externalRepresentation() as CFData, attributes as CFDictionary, &error) else {
  /// Error constructing SecKey from raw key data
  return
}

/// You now have an RSA SecKey for use with Apple's Security framework
```

Apple's Security Framework SecKey -> CryptoSwift RSA Key Example
``` swift
/// Starting with a SecKey RSA Key
let rsaSecKey:SecKey

/// Copy External Representation
var externalRepError:Unmanaged<CFError>?
guard let cfdata = SecKeyCopyExternalRepresentation(rsaSecKey, &externalRepError) else {
  /// Failed to copy external representation for RSA SecKey
  return
}

/// Instantiate the RSA Key from the raw external representation
let rsaKey = try RSA(rawRepresentation: cfdata as Data)

/// You now have a CryptoSwift RSA Key
```


## Author

CryptoSwift is owned and maintained by [Marcin Krzyżanowski](https://www.krzyzanowskim.com)

You can follow me on Twitter at [@krzyzanowskim](https://x.com/krzyzanowskim) for project updates and releases.

# Cryptography Notice

This distribution includes cryptographic software. The country in which you currently reside may have restrictions on the import, possession, use, and/or re-export to another country, of encryption software. BEFORE using any encryption software, please check your country's laws, regulations and policies concerning the import, possession, or use, and re-export of encryption software, to see if this is permitted. See https://www.wassenaar.org/ for more information.

## License

Copyright (C) 2014-2025 Marcin Krzyżanowski <marcin@krzyzanowskim.com>
This software is provided 'as-is', without any express or implied warranty.

In no event will the authors be held liable for any damages arising from the use of this software.

Permission is granted to anyone to use this software for any purpose, including commercial applications, and to alter it and redistribute it freely, subject to the following restrictions:

- The origin of this software must not be misrepresented; you must not claim that you wrote the original software. If you use this software in a product, **an acknowledgment in the product documentation is required**.
- Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.
- This notice may not be removed or altered from any source or binary distribution.
- Redistributions of any form whatsoever must retain the following acknowledgment: 'This product includes software developed by the "Marcin Krzyzanowski" (https://krzyzanowskim.com/).'

## Changelog

See [CHANGELOG](./CHANGELOG) file.
