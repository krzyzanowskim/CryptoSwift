Pod::Spec.new do |s|
  s.name         = "CryptoSwift"
  s.version      = "0.0.1"
  s.summary      = "Crypto helpers. Written in Swift"
  s.homepage     = "https://github.com/krzyzanowskim/CryptoSwift"
  
  s.license      = "Apache License"
  s.license      = { :type => "Apache", :file => "LICENSE" }
  s.author             = { "Marcin Krzyżanowski" => "marcin.krzyzanowski@gmail.com" }
  s.social_media_url   = "http://twitter.com/krzyzanowskim"
  s.platform     = :ios
  s.ios.deployment_target = '7.0'
  s.source       = { :git => "https://github.com/krzyzanowskim/CryptoSwift.git", :tag => "0.0.1" }
  s.source_files = "CryptoSwift/*"
  s.dependency   = "OpenSSL-Universal"
  s.requires_arc = true
  s.dependa
end