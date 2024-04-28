@testable import CryptoSwift
import XCTest

final class FernetTests: XCTestCase {
  func testEncode() throws {
    let key = "3b-Nqg6ry-jrAuDyVjSwEe8wrdyEPQfPuOQNH1q5olE="
    let plaintext = "my deep dark secret"
    
    let now = Date(timeIntervalSince1970: 1_627_721_798)
    let iv: [UInt8] = [41, 44, 26, 236, 9, 110, 52, 150, 33, 193, 102, 135, 173, 1, 176, 0]
    
    let fernet = try Fernet(
      encodedKey: Data(key.utf8),
      makeDate: { now },
      makeIV: { _ in iv }
    )
    let encoded = try fernet.encode(Data(plaintext.utf8))
    
    XCTAssertEqual(
      String(data: encoded, encoding: .utf8),
      "gAAAAABhBRBGKSwa7AluNJYhwWaHrQGwAA8UpMH8Wtw3tEoTD2E_-nbeoAvxbtBpFiC0ZjbVne_ZetFinKSyMjxwWaPRnXVSVqz5QqpUXp6h-34_TL7BaDs"
    )
  }
  
  func testDecode() throws {
    let key = "3b-Nqg6ry-jrAuDyVjSwEe8wrdyEPQfPuOQNH1q5olE"
    let encrypted = "gAAAAABhBRBGKSwa7AluNJYhwWaHrQGwAA8UpMH8Wtw3tEoTD2E_-nbeoAvxbtBpFiC0ZjbVne_ZetFinKSyMjxwWaPRnXVSVqz5QqpUXp6h-34_TL7BaDs"
    let fernet = try Fernet(encodedKey: Data(key.utf8))
    let decoded = try fernet.decode(Data(encrypted.utf8))
    XCTAssertEqual(String(data: decoded.data, encoding: .utf8), "my deep dark secret")
    XCTAssertTrue(decoded.hmacSuccess)
  }
}
