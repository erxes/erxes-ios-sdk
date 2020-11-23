Pod::Spec.new do|spec|
  spec.name='ErxesSDK'
  spec.version='0.19.0'
  spec.summary='A short description of erxes-ios-sdk.'
  spec.swift_version='5.3'
  spec.description='erxes for IOS SDK, for integrating erxes into your iOS application https://erxes.io/'
  spec.homepage='https://github.com/erxes/erxes-ios-sdk'
  spec.license={:type=>'Commons Clause',:file=>'LICENSE'}
  spec.author={'erxes'=>'info@erxes.io'}
  spec.source={:git=>'https://github.com/erxes/erxes-ios-sdk.git',:tag=>spec.version.to_s}
  spec.ios.deployment_target='11.0'
  spec.source_files='ErxesSDK/Classes/**/*'
  spec.resource_bundles={'ErxesSDK'=>['ErxesSDK/Assets/**/*.{jpg,storyboard,png,ttf,gif,strings,lproj,json}']}
  spec.pod_target_xcconfig={'DEFINES_MODULE'=>'YES','SWIFT_VERSION'=>'5.3'}
  spec.frameworks='Photos'
  spec.dependency'Apollo','~> 0.37.0'
  spec.dependency'Apollo/WebSocket'
  spec.dependency'Apollo/SQLite'
  spec.dependency'Fusuma'
  spec.dependency'SDWebImage'
  spec.dependency'SnapKit'
  spec.dependency'ErxesFont','~> 1.0.1'
  spec.dependency'GDCheckbox'
  spec.dependency'IQKeyboardManagerSwift'
  spec.dependency'MaterialComponents/TextControls+FilledTextAreas'
  spec.dependency'MaterialComponents/TextControls+FilledTextFields'
end
