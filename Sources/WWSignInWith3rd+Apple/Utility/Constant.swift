//
//  Constant.swift
//  WWSignInWith3rd+Apple
//
//  Created by William.Weng on 2023/8/25.
//

import Foundation

// MARK: - 常數
open class Constant: NSObject {}

// MARK: - enum
extension Constant {
    
    /// 自訂錯誤
    public enum MyError: Error, LocalizedError {
        
        var errorDescription: String { errorMessage() }

        case unknown
        case unregistered
        case unauthorization
        case isEmpty
        case isCancel
        case isNotRunning
        case notUrlFormat
        case notGeocodeLocation
        case notUrlDownload
        case notCallTelephone
        case notEncoding
        case notOpenURL
        case notOpenSettingsPage
        case notSupports
        case notUseBiometric
        case notImage
        case notTypeCasting
        
        /// 顯示錯誤說明
        /// - Returns: String
        private func errorMessage() -> String {

            switch self {
            case .unknown: return "未知錯誤"
            case .unregistered: return "尚未註冊"
            case .unauthorization: return "尚未授權"
            case .isEmpty: return "資料是空的"
            case .isCancel: return "取消"
            case .isNotRunning: return "沒有在運作"
            case .notUrlFormat: return "URL格式錯誤"
            case .notCallTelephone: return "播打電話錯誤"
            case .notOpenURL: return "打開URL錯誤"
            case .notOpenSettingsPage: return "打開APP設定頁錯誤"
            case .notGeocodeLocation: return "地理編碼錯誤"
            case .notUrlDownload: return "URL下載錯誤"
            case .notUseBiometric: return "不能使用生物辨識"
            case .notSupports: return "該手機不支援"
            case .notEncoding: return "該資料編碼錯誤"
            case .notImage: return "不是圖片檔"
            case .notTypeCasting: return "不能轉型"
            }
        }
    }
}
