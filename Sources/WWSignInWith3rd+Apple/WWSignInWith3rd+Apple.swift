//
//  WWSignInWith3rd+Apple.swift
//  WWSignInWith3rd+Apple
//
//  Created by William.Weng on 2028/8/25.
//

import AuthenticationServices

// MARK: - APPLE第三方登入 (原生)
extension WWSignInWith3rd {
    
    /// [AuthenticationServices Framework - iOS 13](https://developer.apple.com/documentation/authenticationservices)
    open class Apple: NSObject {
        
        public typealias SignInInformation = (credential: ASAuthorizationAppleIDCredential?, state: ASAuthorizationAppleIDProvider.CredentialState)
        
        public static let shared = Apple()
        private var completionBlock: ((Result<SignInInformation, Error>) -> Void)?

        private override init() {}
    }
}

// MARK: - ASAuthorizationControllerDelegate / ASAuthorizationControllerPresentationContextProviding
extension WWSignInWith3rd.Apple: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) { loginInformation(with: controller, authorization: authorization) }
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) { completionBlock?(.failure(error)) }
    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor { return UIWindow._keyWindow() ?? UIWindow() }
}

// MARK: - WWSignInWith3rd.Apple (public class function)
public extension WWSignInWith3rd.Apple {
    
    /// [彈出Apple登入視窗 - 要加入.entitlements](https://developer.apple.com/documentation/authenticationservices/implementing_user_authentication_with_sign_in_with_apple)
    /// - Parameters:
    ///   - scopes: 要取得的資料範圍 => [.fullName, .email]
    ///   - completion: [完成後取得ASAuthorizationAppleIDCredential](https://www.bnext.com.tw/article/53765/what-is-the-meaning-of-sign-in-with-apple)
    func login(for scopes: [ASAuthorization.Scope] = [.fullName, .email], completion: ((Result<SignInInformation, Error>) -> Void)?) {
        
        let authorizationController = ASAuthorizationController._build(with: scopes, delegate: self)
        authorizationController.performRequests()
        
        completionBlock = completion
    }
    
    /// Apple登入 -> 沒有登出功能 => 要自己去設定
    func logout() { fatalError("設定 -> Apple ID -> 密碼與安全性 -> 使用 Apple ID的 App") }
    
    /// [產生SignInWithApple的原生按鈕 / 按鈕按下後的功能](https://medium.com/@tuzaiz/如何整合-sign-in-with-apple-到自己的-ios-app-上-ios-backend-e64d9de15410)
    /// - Parameters:
    ///   - frame: CGRect
    ///   - cornerRadius: 圓角
    ///   - type: ASAuthorizationAppleIDButton.ButtonType
    ///   - style: ASAuthorizationAppleIDButton.Style
    /// - Returns: ASAuthorizationAppleIDButton
    func loginButton(with frame: CGRect = .zero, cornerRadius: CGFloat = 10, type: ASAuthorizationAppleIDButton.ButtonType = .default, style: ASAuthorizationAppleIDButton.Style = .black) -> ASAuthorizationAppleIDButton {
        return ASAuthorizationAppleIDButton._build(with: frame, cornerRadius: cornerRadius, type: type, style: style)
    }
}

// MARK: - WWSignInWith3rd.Apple (private function)
private extension WWSignInWith3rd.Apple {
    
    /// 取得Login後的相關資訊 (確認 / 取消)
    /// - Parameters:
    ///   - controller: ASAuthorizationController
    ///   - authorization: ASAuthorization
    func loginInformation(with controller: ASAuthorizationController, authorization: ASAuthorization) {
        
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential,
              let completionBlock = completionBlock
        else {
            completionBlock?(.failure(Constant.MyError.isEmpty)); return
        }
        
        controller._credentialState(userID: credential.user) { result in
            switch result {
            case .failure(let error): completionBlock(.failure(error))
            case .success(let state): completionBlock(.success((credential: credential, state: state)))
            }
        }
    }
}
