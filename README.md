# erxes Inc - erxes for IOS SDK

erxes is an AI meets open source messaging platform for sales and marketing

<a href="https://demohome.erxes.io/">View demo</a> <b>| </b> <a href="https://github.com/erxes/erxes-ios-sdk/archive/master.zip">Download ZIP </a> <b> | </b> <a href="https://gitter.im/erxes/Lobby">Join us on Gitter</a>

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

- Minimum deployment target : iOS 9
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


## Contributors

This project exists thanks to all the people who contribute. [[Contribute]](CONTRIBUTING.md).
<a href="graphs/contributors"><img src="https://opencollective.com/erxes/contributors.svg?width=890" /></a>


## Backers

Thank you to all our backers! 🙏 [[Become a backer](https://opencollective.com/erxes#backer)]

<a href="https://opencollective.com/erxes#backers" target="_blank"><img src="https://opencollective.com/erxes/backers.svg?width=890"></a>


## Sponsors

Support this project by becoming a sponsor. Your logo will show up here with a link to your website. [[Become a sponsor](https://opencollective.com/erxes#sponsor)]

<a href="https://opencollective.com/erxes/sponsor/0/website" target="_blank"><img src="https://opencollective.com/erxes/sponsor/0/avatar.svg"></a>
<a href="https://opencollective.com/erxes/sponsor/1/website" target="_blank"><img src="https://opencollective.com/erxes/sponsor/1/avatar.svg"></a>
<a href="https://opencollective.com/erxes/sponsor/2/website" target="_blank"><img src="https://opencollective.com/erxes/sponsor/2/avatar.svg"></a>
<a href="https://opencollective.com/erxes/sponsor/3/website" target="_blank"><img src="https://opencollective.com/erxes/sponsor/3/avatar.svg"></a>
<a href="https://opencollective.com/erxes/sponsor/4/website" target="_blank"><img src="https://opencollective.com/erxes/sponsor/4/avatar.svg"></a>
<a href="https://opencollective.com/erxes/sponsor/5/website" target="_blank"><img src="https://opencollective.com/erxes/sponsor/5/avatar.svg"></a>
<a href="https://opencollective.com/erxes/sponsor/6/website" target="_blank"><img src="https://opencollective.com/erxes/sponsor/6/avatar.svg"></a>
<a href="https://opencollective.com/erxes/sponsor/7/website" target="_blank"><img src="https://opencollective.com/erxes/sponsor/7/avatar.svg"></a>
<a href="https://opencollective.com/erxes/sponsor/8/website" target="_blank"><img src="https://opencollective.com/erxes/sponsor/8/avatar.svg"></a>
<a href="https://opencollective.com/erxes/sponsor/9/website" target="_blank"><img src="https://opencollective.com/erxes/sponsor/9/avatar.svg"></a>

## In-kind sponsors

<a href="https://www.cloudflare.com/" target="_blank"><img src="https://erxes.io/img/logo/cloudflare.png" width="130px;" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</a>
<a href="https://www.saucelabs.com/" target="_blank"><img src="https://erxes.io/img/logo/saucelabs.png" width="130px;" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</a>
<a href="https://www.transifex.com/" target="_blank"><img src="https://erxes.io/img/logo/transifex.png" width="100px;" /></a>

## Copyright & License
Copyright (c) 2018 erxes Inc - Released under the [MIT license.](https://github.com/erxes/erxes/blob/develop/LICENSE.md)
