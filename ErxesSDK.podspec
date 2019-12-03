
Pod::Spec.new do |s|
  s.name             = 'ErxesSDK'
  s.version          = '0.9.0'
  s.summary          = 'A short description of erxes-ios-sdk.'
  s.swift_version = '5.0'
  s.description      = 'erxes for IOS SDK, for integrating erxes into your iOS application https://erxes.io/'

  s.homepage         = 'https://github.com/erxes/erxes-ios-sdk'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'erxes' => 'info@erxes.io' }
  s.source           = { :git => 'https://github.com/erxes/erxes-ios-sdk.git', :tag => s.version.to_s }
  s.ios.deployment_target = '9.0'
  s.source_files = 'ErxesSDK/Classes/**/*'
   s.resource_bundles = {
       'ErxesSDK' => ['ErxesSDK/Assets/**/*.{jpg,storyboard,png,ttf,gif,strings,lproj}']
   }
  s.pod_target_xcconfig = {'DEFINES_MODULE' => 'YES','SWIFT_VERSION' => '5.0'}
  s.frameworks = 'Photos'
  s.dependency 'Apollo', '~> 0.20.0'
  s.dependency 'Apollo/WebSocket'
  s.dependency 'Apollo/SQLite'
  s.dependency 'Fusuma', '~> 1.3.0'
  s.dependency 'Alamofire', '~> 4.8.0'
  s.dependency 'SDWebImage', '~> 5.1.0'
  s.dependency 'SnapKit', '~> 4.2.0'
  s.dependency 'ErxesFont','~> 1.0.1'
end
