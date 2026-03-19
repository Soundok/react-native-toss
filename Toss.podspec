require "json"

package = JSON.parse(File.read(File.join(__dir__, "package.json")))

Pod::Spec.new do |s|
  s.name         = "Toss"
  s.version      = package["version"]
  s.summary      = package["description"]
  s.homepage     = package["homepage"]
  s.license      = package["license"]
  s.authors      = package["author"]

  s.platforms    = { :ios => "13.0" }
  s.source       = { :git => "https://github.com/Soundok/react-native-toss.git", :tag => "#{s.version}" }

  s.source_files = "ios/**/*.{h,m,mm,swift,cpp}"
  s.private_header_files = "ios/**/*.h"

  s.swift_version = "5.7"

  install_modules_dependencies(s)

  spm_dependency(s,
    url: 'https://github.com/toss/toss-sdk-ios.git',
    requirement: {kind: 'upToNextMajorVersion', minimumVersion: '1.0.0'},
    products: ['TossSDK']
  )
end
