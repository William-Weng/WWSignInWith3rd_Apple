//
//  Extension.swift
//  WWSignInWith3rd+Apple
//
//  Created by William.Weng on 2023/8/25.
//

import AuthenticationServices
import WebKit

// MARK: - String (function)
public extension String {
    
    /// URL編碼 (百分比)
    /// - 是在哈囉 => %E6%98%AF%E5%9C%A8%E5%93%88%E5%9B%89
    /// - Parameter characterSet: 字元的判斷方式
    /// - Returns: String?
    func _encodingURL(characterSet: CharacterSet = .urlQueryAllowed) -> String? { return addingPercentEncoding(withAllowedCharacters: characterSet) }
}

// MARK: - Data (function)
public extension Data {
    
    /// Data => 字串
    /// - Parameter encoding: 字元編碼
    /// - Returns: String?
    func _string(using encoding: String.Encoding = .utf8) -> String? {
        return String(bytes: self, encoding: encoding)
    }
    
    /// Data => JSON
    /// - 7b2268747470223a2022626f6479227d => {"http": "body"}
    /// - Returns: Any?
    func _jsonObject(options: JSONSerialization.ReadingOptions = .allowFragments) -> Any? {
        let json = try? JSONSerialization.jsonObject(with: self, options: options)
        return json
    }
}

// MARK: - URL (static function)
public extension URL {
    
    /// 將URL標準化 (百分比)
    /// - 是在哈囉 => %E6%98%AF%E5%9C%A8%E5%93%88%E5%9B%89
    /// - Parameters:
    ///   - string: url字串
    ///   - characterSet: 字元的判斷方式
    /// - Returns: URL?
    static func _standardization(string: String, characterSet: CharacterSet = .urlQueryAllowed) -> URL? {
        
        var url: URL?
        url = URL(string: string)
        
        guard url == nil,
              let encodeString = string._encodingURL(characterSet: characterSet)
        else {
            return url
        }

        return URL(string: encodeString)
    }
}

// MARK: - UIWindow (function)
public extension UIWindow {
    
    /// [取得作用中的KeyWindow](https://stackoverflow.com/questions/57134259/how-to-resolve-keywindow-was-deprecated-in-ios-13-0)
    /// - Parameter hasScene: [有沒有使用Scene ~ iOS 13](https://juejin.cn/post/6844903993496305671)
    /// - Returns: UIWindow?
    static func _keyWindow(hasScene: Bool = true) -> UIWindow? {
        
        var keyWindow: UIWindow?

        keyWindow = UIApplication.shared.connectedScenes.filter({$0.activationState == .foregroundActive}).compactMap({$0 as? UIWindowScene}).first?.windows.filter({$0.isKeyWindow}).first
        if (!hasScene) { keyWindow = UIApplication.shared.keyWindow }
        
        return keyWindow
    }
}

// MARK: - ASAuthorizationController (static function)
public extension ASAuthorizationController {
    
    /// [產生Apple登入的ViewController](https://developer.apple.com/documentation/authenticationservices/implementing_user_authentication_with_sign_in_with_apple)
    /// - Parameters:
    ///   - scopes: 要取得的資料範圍 => [.fullName, .email]
    ///   - delegate: ASAuthorizationControllerDelegate & ASAuthorizationControllerPresentationContextProviding
    /// - Returns: ASAuthorizationController
    static func _build(with scopes: [ASAuthorization.Scope] = [.fullName, .email], delegate: ASAuthorizationControllerDelegate & ASAuthorizationControllerPresentationContextProviding) -> ASAuthorizationController {
        
        let requests = ASAuthorizationRequest._build(with: scopes)
        let authorizationController = ASAuthorizationController(authorizationRequests: requests)

        authorizationController.delegate = delegate
        authorizationController.presentationContextProvider = delegate

        return authorizationController
    }
}

// MARK: - ASAuthorizationRequest (static function)
public extension ASAuthorizationRequest {
    
    /// [要取得哪些資訊的Request](https://qiita.com/shiz/items/5e094910f742c2ad72a4)
    /// - Parameter scopes: [ASAuthorization.Scope] => [.fullname, .email]
    /// - Returns: [ASAuthorizationRequest]
    static func _build(with scopes: [ASAuthorization.Scope]?) -> [ASAuthorizationRequest] {

        let authorizationAppleIDRequest = ASAuthorizationAppleIDProvider().createRequest()
        authorizationAppleIDRequest.requestedScopes = scopes

        return [authorizationAppleIDRequest]
    }
}

// MARK: - ASAuthorizationAppleIDButton (static function)
public extension ASAuthorizationAppleIDButton {
    
    /// [產生SignInWithApple的原生按鈕 / 按鈕按下後的功能](https://medium.com/@tuzaiz/如何整合-sign-in-with-apple-到自己的-ios-app-上-ios-backend-e64d9de15410)
    /// - Parameters:
    ///   - frame: CGRect
    ///   - cornerRadius: 圓角
    ///   - type: ASAuthorizationAppleIDButton.ButtonType
    ///   - style: ASAuthorizationAppleIDButton.Style
    /// - Returns: ASAuthorizationAppleIDButton
    static func _build(with frame: CGRect = .zero, cornerRadius: CGFloat = 10, type: ASAuthorizationAppleIDButton.ButtonType = .default, style: ASAuthorizationAppleIDButton.Style = .black) -> ASAuthorizationAppleIDButton {

        let authorizationButton = ASAuthorizationAppleIDButton(type: type, style: style)
        
        authorizationButton.frame = frame
        authorizationButton.cornerRadius = cornerRadius

        return authorizationButton
    }
}

// MARK: - ASAuthorizationController (class function)
public extension ASAuthorizationController {
    
    /// [測試認證的狀態 (ASAuthorizationAppleIDCredential.user)](https://ciao-chung.com/page-article/sign-in-with-app)
    /// - Parameters:
    ///   - userID: 取得的使用者編號
    ///   - result: Result<ASAuthorizationAppleIDProvider.CredentialState, Error>
    func _credentialState(userID: String, result: @escaping (Result<ASAuthorizationAppleIDProvider.CredentialState, Error>) -> Void) {

        let appleIDProvider = ASAuthorizationAppleIDProvider()

        appleIDProvider.getCredentialState(forUserID: userID) { (credentialState, error) in
            if let error = error { result(.failure(error)); return }
            result(.success(credentialState))
        }
    }
}

// MARK: - WKWebsiteDataStore (function)
public extension WKWebsiteDataStore {
    
    /// [登出 - 清除存在WebView裡面的Cookie值](https://stackoverflow.com/questions/31289838/how-to-delete-wkwebview-cookies)
    /// - Parameters:
    ///   - key: String
    ///   - completion: (Bool)
    func _cleanWebsiteData(contains key: String, completion: ((Bool) -> Void)?) {
        
        let websiteDataTypes = WKWebsiteDataStore.allWebsiteDataTypes()
                
        self.fetchDataRecords(ofTypes: websiteDataTypes) { records in
            
            self.removeData(ofTypes: websiteDataTypes, for: records.filter({ record in
                return record.displayName.contains(key)
            }), completionHandler: {
                completion?(true)
            })
        }
    }
}

// MARK: - WKWebView (static function)
public extension WKWebView {
    
    /// 產生WKWebView (WKNavigationDelegate & WKUIDelegate)
    /// - Parameters:
    ///   - delegate: WKNavigationDelegate & WKUIDelegate
    ///   - frame: WKWebView的大小
    ///   - configuration: WKWebViewConfiguration
    ///   - contentInsetAdjustmentBehavior: scrollView是否為全畫面 => 滿版(導覽列)
    /// - Returns: WKWebView
    static func _build(delegate: (WKNavigationDelegate & WKUIDelegate)?, frame: CGRect, configuration: WKWebViewConfiguration = WKWebViewConfiguration(), contentInsetAdjustmentBehavior: UIScrollView.ContentInsetAdjustmentBehavior = .never) -> WKWebView {
        
        let webView = WKWebView(frame: frame, configuration: configuration)
 
        webView.backgroundColor = .white
        webView.navigationDelegate = delegate
        webView.uiDelegate = delegate
        webView.scrollView.contentInsetAdjustmentBehavior = contentInsetAdjustmentBehavior

        return webView
    }
}

// MARK: - WKWebView (function)
public extension WKWebView {
    
    /// 載入WebView網址
    func _load(urlString: String?, cachePolicy: URLRequest.CachePolicy = .reloadIgnoringCacheData, timeoutInterval: TimeInterval) -> WKNavigation? {
        
        guard let urlString = urlString,
              let url = URL(string: urlString),
              let urlRequest = Optional.some(URLRequest(url: url, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval))
        else {
            return nil
        }
        
        return self.load(urlRequest)
    }
}
