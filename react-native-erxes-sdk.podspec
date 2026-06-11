require "json"

package = JSON.parse(File.read(File.join(__dir__, "package.json")))

Pod::Spec.new do |s|
  s.name         = "ErxesSdk"
  s.version      = package["version"]
  s.summary      = package["description"]
  s.homepage     = "https://github.com/Munkhorgilb/ios-sdk"
  s.license      = "AGPL-3.0"
  s.authors      = { "erxes" => "info@erxes.io" }
  s.platforms    = { :ios => "16.0" }
  s.source       = { :git => "https://github.com/Munkhorgilb/react-native-erxes-sdk.git", :tag => "#{s.version}" }

  s.source_files = "ios/**/*.{h,m,mm,swift}"

  # The underlying native messenger SDK. Published as a CocoaPod, or vendored.
  s.dependency "MessengerSDK"

  # Pulls in React-Core, and on the new architecture the codegen-generated
  # TurboModule sources + folly/RCT-Folly flags via install_modules_dependencies.
  install_modules_dependencies(s)
end
