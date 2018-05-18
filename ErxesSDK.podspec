
Pod::Spec.new do |s|
  s.name             = 'ErxesSDK'
  s.version          = '0.1.0'
  s.summary          = 'A short description of erxes-ios-sdk.'

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/erxes/erxes-ios-sdk'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'erxes' => 'info@erxes.io' }
  s.source           = { :git => 'https://github.com/erxes/erxes-ios-sdk.git', :tag => s.version.to_s }
  s.ios.deployment_target = '9.0'
  s.source_files = 'ErxesSDK/Classes/**/*'
   s.resource_bundles = {
       'ErxesSDK' => ['ErxesSDK/Assets/*.{jpg,storyboard,png,ttf}']
   }
  s.pod_target_xcconfig = {'DEFINES_MODULE' => 'YES','SWIFT_VERSION' => '4.0'}
  
  s.dependency 'Apollo', '~> 0.8.0'
  s.dependency 'SwiftyJSON', '~> 4.1.0'
  s.dependency 'LiveGQL', '~> 2.0.0'
end
