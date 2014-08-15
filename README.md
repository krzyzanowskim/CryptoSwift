#CryptoSwift
Crypto related helpers for Swift implemented in Swift.

##Requirements
Good mood

##Usage

    import CryptoSwift
    
    /* Calculate hash for array of bytes */
    var data:NSData = NSData(bytes: [49, 50, 51] as [Byte], length: 3)
    if let data = CryptoHash.md5.hash(data) {
        println(data.hexString)
    }
    
    /* Calculate hash for string with convenience extension */
    var string:String = "123"
    if let hash = string.md5() {
        println(string.md5())
    }
    

