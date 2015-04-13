Pod::Spec.new do |s|
  s.name         = "CryptoSwift"
  s.version      = "0.0.10"
  s.summary      = "Cryptography in Swift. SHA, MD5, CRC, Poly1305, HMAC, ChaCha20, AES."
  s.description  = "Cryptography functions and helpers for Swift implemented in Swift. SHA, MD5, CRC, Poly1305, HMAC, ChaCha20, AES."
  s.homepage     = "https://github.com/krzyzanowskim/CryptoSwift"
  s.license      = {:type => "Attribution License", :file => "LICENSE"}
  s.source       = { :git => "https://github.com/krzyzanowskim/CryptoSwift.git", :tag => "#{s.version}" }
  s.authors      = {'Marcin Krzyżanowski' => 'marcin.krzyzanowski@hakore.com'}
  s.social_media_url   = "https://twitter.com/krzyzanowskim"
  s.ios.platform  = :ios, '8.0'
  s.ios.deployment_target = "8.0"
  s.osx.platform  = :osx, '10.9'
  s.osx.deployment_target = "10.9"
  s.source_files  = "CryptoSwift/*"
  s.requires_arc = true
end