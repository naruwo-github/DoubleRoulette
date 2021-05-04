//
//  RouletteObject.swift
//  DoubleRoulette
//
//  Created by Narumi Nogawa on 2020/04/30.
//  Copyright © 2020 Narumi Nogawa. All rights reserved.
//

// MARK: - <OS固有フレームワーク>
import Foundation
// MARK: - <外部フレームワーク>
import RealmSwift

// MARK: - <realmに保存するデータのクラス>
class RouletteObject: Object {
    
    @objc dynamic var id = 0
    @objc dynamic var type: Int = 0
    @objc dynamic var item: String = "item"
    @objc dynamic var color: String = "FF0000"
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}

// MARK: - <RouletteObjectのまとまりを持つクラス>
class RouletteListObject: Object {
    
    @objc dynamic var title: String = "template"
    let rouletteList = List<RouletteCellInfoObject>()
    
}

// MARK: - <単体のセルの情報を持つクラス>
class RouletteCellInfoObject: Object {
    
    @objc dynamic var type: Int = 0
    @objc dynamic var item: String = "item"
    @objc dynamic var color: String = "FF0000"
    
}
