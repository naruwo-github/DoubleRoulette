//
//  DRUserHelper.swift
//  DoubleRoulette
//
//  Created by Narumi Nogawa on 2020/07/15.
//  Copyright © 2020 Narumi Nogawa. All rights reserved.
//

import Foundation

class DRUserHelper {
    // NOTE: ユーザの情報を保存するためのクラス
    
    // NOTE: アニメーションのセッティングを管理
    enum AnimationSettingKey: String {
        case playSound = "dr.playSound"
        case displayResult = "dr.displayResult"
    }
    
    // NOTE: データ保存のクラス関数
    class func save(_ key : String, value : Any?) {
        let userDefault = UserDefaults.standard
        userDefault.setValue(value, forKey: key)
    }
    
    // NOTE: 指定データの削除のクラス関数
    class func remove(_ key : String) {
        let userDefault = UserDefaults.standard
        userDefault.removeObject(forKey: key)
    }
    
    // NOTE: 指定データの読み込みのクラス関数
    class func load<T>(_ key : String, returnClass : T.Type) -> T? {
        let userDefault = UserDefaults.standard
        return userDefault.value(forKey: key) as? T
    }
    
    // NOTE: 指定データの真偽値を返すクラス関数
    class func bool(_ key : String) -> Bool {
        let userDefault = UserDefaults.standard
        return userDefault.bool(forKey: key)
    }
    
    // NOTE: ユーザデータを全削除するクラス関数
    class func clearAll() {
        let userDefault = UserDefaults.standard
        userDefault.dictionaryRepresentation().forEach({ userDefault.removeObject(forKey: $0.0) })
    }
    
    // NOTE: アニメーション中のサウンド管理（デフォルトはtrue）
    static var isAuthorizedPlaySound: Bool {
        get {
            return DRUserHelper.load(DRUserHelper.AnimationSettingKey.playSound.rawValue, returnClass: Bool.self) ?? true
        }
        set {
            DRUserHelper.save(DRUserHelper.AnimationSettingKey.playSound.rawValue, value: newValue)
        }
    }
    
    // NOTE: アニメーション後の結果画面表示管理（デフォルトはtrue）
    static var isAuthorizedResultView: Bool {
        get {
            return DRUserHelper.load(DRUserHelper.AnimationSettingKey.displayResult.rawValue, returnClass: Bool.self) ?? true
        }
        set {
            DRUserHelper.save(DRUserHelper.AnimationSettingKey.displayResult.rawValue, value: newValue)
        }
    }
}
