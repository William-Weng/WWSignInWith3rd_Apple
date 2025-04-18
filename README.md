# WWSignInWith3rd_Apple

[![Swift-5.7](https://img.shields.io/badge/Swift-5.7-orange.svg?style=flat)](https://developer.apple.com/swift/) [![iOS-15.0](https://img.shields.io/badge/iOS-15.0-pink.svg?style=flat)](https://developer.apple.com/swift/) ![TAG](https://img.shields.io/github/v/tag/William-Weng/WWSignInWith3rd_Apple) [![Swift Package Manager-SUCCESS](https://img.shields.io/badge/Swift_Package_Manager-SUCCESS-blue.svg?style=flat)](https://developer.apple.com/swift/) [![LICENSE](https://img.shields.io/badge/LICENSE-MIT-yellow.svg?style=flat)](https://developer.apple.com/swift/)

### [Introduction - 簡介](https://swiftpackageindex.com/William-Weng)
- Use native Apple third-party login.
- 使用原生的Apple第三方登入。

![](./Example.gif)

### [Installation with Swift Package Manager](https://medium.com/彼得潘的-swift-ios-app-開發問題解答集/使用-spm-安裝第三方套件-xcode-11-新功能-2c4ffcf85b4b)
```
dependencies: [
    .package(url: "https://github.com/William-Weng/WWSignInWith3rd_Apple.git", .upToNextMajor(from: "1.1.4"))
]
```

### Function - 可用函式
|函式|功能|
|-|-|
|login(for:completion:)|彈出Apple登入視窗 - 要加入.entitlements|
|logout()|Apple登入 -> 沒有登出功能 => 要自己去設定|
|loginButton(with:cornerRadius:type:style:)|產生SignInWithApple的原生按鈕 / 按鈕按下後的功能|

### Example
```swift
import UIKit
import WWSignInWith3rd_Apple

final class ViewController: UIViewController {
    
    @IBAction func signInWithApple(_ sender: UIButton) {
        
        WWSignInWith3rd.Apple.shared.login { result in
            print(result)
        }
    }
}
```
