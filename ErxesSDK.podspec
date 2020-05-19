Pod::Spec.new do|spec|
  spec.name='ErxesSDK'
  spec.version='0.13.0'
  spec.summary='A short description of erxes-ios-sdk.'
  spec.swift_version='5.0'
  spec.description='erxes for IOS SDK, for integrating erxes into your iOS application https://erxes.io/'
  spec.homepage='https://github.com/erxes/erxes-ios-sdk'
  spec.license={:type=>'Commons Clause',:file=>'LICENSE'}
  spec.author={'erxes'=>'info@erxes.io'}
  spec.source={:git=>'https://github.com/erxes/erxes-ios-sdk.git',:tag=>spec.version.to_s}
  spec.ios.deployment_target='9.0'
  spec.source_files='ErxesSDK/Classes/**/*'
  spec.resource_bundles={'ErxesSDK'=>['ErxesSDK/Assets/**/*.{jpg,storyboard,png,ttf,gif,strings,lproj,json}']}
  spec.pod_target_xcconfig={'DEFINES_MODULE'=>'YES','SWIFT_VERSION'=>'5.0'}
  spec.frameworks='Photos'
  spec.dependency'Apollo','~> 0.27.1'
  spec.dependency'Apollo/WebSocket'
  spec.dependency'Apollo/SQLite'
  spec.dependency'Fusuma','~> 1.3.0'
  spec.dependency'Alamofire','~> 4.8.0'
  spec.dependency'SDWebImage','~> 5.1.0'
  spec.dependency'SnapKit','~> 4.2.0'
  spec.dependency'ErxesFont','~> 1.0.1'
  spec.dependency'GDCheckbox','~> 1.0.3'
  spec.dependency'IQKeyboardManagerSwift','~> 6.5.5'
  spec.dependency'MaterialComponents/TextControls+FilledTextAreas'
  spec.dependency'MaterialComponents/TextControls+FilledTextFields'
end
