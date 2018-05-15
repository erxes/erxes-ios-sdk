# erxes-ios-sdk

[![CI Status](https://img.shields.io/travis/devpurevee/ErxesSDK.svg?style=flat)](https://travis-ci.org/devpurevee/ErxesSDK)
[![Version](https://img.shields.io/cocoapods/v/ErxesSDK.svg?style=flat)](https://cocoapods.org/pods/ErxesSDK)
[![License](https://img.shields.io/cocoapods/l/ErxesSDK.svg?style=flat)](https://cocoapods.org/pods/ErxesSDK)
[![Platform](https://img.shields.io/cocoapods/p/ErxesSDK.svg?style=flat)](https://cocoapods.org/pods/ErxesSDK)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

```ruby
pod 'ErxesSDK', :git => 'https://github.com/erxes/erxes-ios-sdk.git'
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

## Author

erxes, info@erxes.io

## License

erxes-ios-sdk is available under the MIT license. See the LICENSE file for more info.
