//
//  Extension+Apple.swift
//  WWSignInWith3rd_Apple
//
//  Created by William.Weng on 2025/3/24.
//

import AuthenticationServices

// MARK: - ASAuthorizationController (static function)
extension ASAuthorizationController {
    
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
extension ASAuthorizationRequest {
    
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
extension ASAuthorizationAppleIDButton {
    
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
extension ASAuthorizationController {
    
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
