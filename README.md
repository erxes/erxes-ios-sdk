# erxes-ios-sdk

[![CI Status](https://img.shields.io/travis/devpurevee/ErxesSDK.svg?style=flat)](https://travis-ci.org/devpurevee/ErxesSDK)
[![Version](https://img.shields.io/cocoapods/v/ErxesSDK.svg?style=flat)](https://cocoapods.org/pods/ErxesSDK)
[![License](https://img.shields.io/cocoapods/l/ErxesSDK.svg?style=flat)](https://cocoapods.org/pods/ErxesSDK)
[![Platform](https://img.shields.io/cocoapods/p/ErxesSDK.svg?style=flat)](https://cocoapods.org/pods/ErxesSDK)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

- Minimum deployment target : iOS 9.0
- Swift 4 compatible
- Objective-C compatible


## Installation

```ruby
pod 'ErxesSDK', :git => 'https://github.com/erxes/erxes-ios-sdk.git'
```

In Objective-C put this line at top of the Podfile

```ruby
use_modular_headers!
```

## Swift Instruction

```swift
import ErxesSDK
```

```swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    Erxes.setBrandCode(brandCode: "YOUR_BRAND_CODE")
    Erxes.setHosts(apiHost: "ERXES_API_HOST", subsHost: "ERXES_SUBSCRIPTION_HOST")
    return true
}
```

```swift
@IBAction func btnClick(){
    Erxes.startWithUserEmail(email: "tester@test.com")
}
```
or
```swift
@IBAction func btnClick(){
    Erxes.start()
}
```

## Objective-C Instruction

```objc
@import ErxesSDK;
```

```objc
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [Erxes setBrandCodeWithBrandCode:@"YOUR_BRAND_CODE"];
    [Erxes setHostsWithApiHost:@"ERXES_API_HOST" subsHost:@"ERXES_SUBSCRIPTION_HOST"];
    return YES;
}
```

```objc
- (IBAction)btnClick:(id)sender {
    [Erxes startWithUserEmailWithEmail:@"test@test.com"];
}
```
or
```objc
- (IBAction)btnClick:(id)sender {
    [Erxes start];
}
```

## Author

erxes, info@erxes.io

## License

erxes-ios-sdk is available under the MIT license. See the LICENSE file for more info.
