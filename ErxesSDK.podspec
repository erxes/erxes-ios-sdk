Pod::Spec.new do |s|
  s.name             = 'ErxesSDK'
  s.module_name      = 'MessengerSDK'
  s.version          = '0.30.14'
  s.summary          = 'erxes Messenger iOS SDK'
  s.description      = 'Native iOS SDK for embedding erxes Messenger into iOS applications.'
  s.homepage         = 'https://github.com/erxes/erxes-ios-sdk'
  s.license          = { :type => 'AGPL-3.0', :file => 'LICENSE' }
  s.author           = { 'erxes' => 'info@erxes.io' }

  s.source           = {
    :git => 'https://github.com/erxes/erxes-ios-sdk.git',
    :tag => s.version.to_s
  }

  s.ios.deployment_target = '16.0'
  s.swift_version = '5.9'

  s.source_files = 'Sources/MessengerSDK/**/*.{swift,h,m,mm}'

  s.resource_bundles = {
    'MessengerSDKResources' => [
      'Sources/MessengerSDK/Resources/**/*'
    ]
  }

  s.frameworks = [
    'UIKit',
    'Foundation',
    'SwiftUI',
    'Combine',
    'WebKit',
    'SafariServices',
    'Photos',
    'PhotosUI',
    'AVFoundation',
    'Speech',
    'ImageIO'
  ]

  s.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES',
    'SWIFT_VERSION' => '5.9'
  }
end
