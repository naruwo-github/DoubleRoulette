//
//  DRUserHelper.swift
//  DoubleRoulette
//
//  Created by Narumi Nogawa on 2020/07/15.
//  Copyright © 2020 Narumi Nogawa. All rights reserved.
//

import Foundation

// ユーザの情報を保存するためのクラス
class DRUserHelper {
    
    // アニメーションのセッティングを管理
    enum AnimationSettingKey: String {
        case isShownAnimationSettingView = "dr.isShownAnimationSettingView"
        
        case isShownPopup = "dr.isShownPopup"
        case playSound = "dr.playSound"
        case displayResult = "dr.displayResult"
    }
    
    // 表示回数など、動作の回数を管理
    enum CounterKey: String {
        case backToCellSettingFromRoulette = "dr.backToCellSettingFromRoulette"
    }
    
    class func sync() {
        let userDefault = UserDefaults.standard
        userDefault.synchronize()
    }
    
    // データ保存のクラス関数
    class func save(_ key: String, value: Any?) {
        let userDefault = UserDefaults.standard
        userDefault.setValue(value, forKey: key)
    }
    
    // 指定データの削除のクラス関数
    class func remove(_ key: String) {
        let userDefault = UserDefaults.standard
        userDefault.removeObject(forKey: key)
    }
    
    // 指定データの読み込みのクラス関数
    class func load<T>(_ key: String, returnClass: T.Type) -> T? {
        let userDefault = UserDefaults.standard
        return userDefault.value(forKey: key) as? T
    }
    
    // 指定データの真偽値を返すクラス関数
    class func bool(_ key: String) -> Bool {
        let userDefault = UserDefaults.standard
        return userDefault.bool(forKey: key)
    }
    
    // ユーザデータを全削除するクラス関数
    class func clearAll() {
        let userDefault = UserDefaults.standard
        userDefault.dictionaryRepresentation().forEach({ userDefault.removeObject(forKey: $0.0) })
    }
    
    // アニメーション中のサウンド管理（デフォルトはtrue）
    static var isAuthorizedPlaySound: Bool {
        get {
            return DRUserHelper.load(DRUserHelper.AnimationSettingKey.playSound.rawValue, returnClass: Bool.self) ?? true
        }
        set {
            DRUserHelper.save(DRUserHelper.AnimationSettingKey.playSound.rawValue, value: newValue)
        }
    }
    
    // アニメーション後の結果画面表示管理（デフォルトはtrue）
    static var isAuthorizedResultView: Bool {
        get {
            return DRUserHelper.load(DRUserHelper.AnimationSettingKey.displayResult.rawValue, returnClass: Bool.self) ?? true
        }
        set {
            DRUserHelper.save(DRUserHelper.AnimationSettingKey.displayResult.rawValue, value: newValue)
        }
    }
    
    // ルーレット画面からセル設定画面に戻るナビゲーションボタンを押した回数
    static var backToCellSettingFromRouletteCount: Int {
        get {
            return DRUserHelper.load(DRUserHelper.CounterKey.backToCellSettingFromRoulette.rawValue, returnClass: Int.self) ?? 0
        }
        set {
            DRUserHelper.save(DRUserHelper.CounterKey.backToCellSettingFromRoulette.rawValue, value: newValue)
        }
    }
    
    // Animation Setting画面を表示したかどうかのフラグ
    static var isShownAnimationSettingView: Bool {
        get {
            return DRUserHelper.load(DRUserHelper.AnimationSettingKey.isShownAnimationSettingView.rawValue, returnClass: Bool.self) ?? false
        }
        set {
            DRUserHelper.save(DRUserHelper.AnimationSettingKey.isShownAnimationSettingView.rawValue, value: newValue)
        }
    }
    
    // Animation Setting明示のポップアップを表示したかどうかのフラグ
    static var isShownPopupOfAnimationSetting: Bool {
        get {
            return DRUserHelper.load(DRUserHelper.AnimationSettingKey.isShownPopup.rawValue, returnClass: Bool.self) ?? false
        }
        set {
            DRUserHelper.save(DRUserHelper.AnimationSettingKey.isShownPopup.rawValue, value: newValue)
        }
    }
    
}
