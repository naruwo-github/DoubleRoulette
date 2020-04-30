//
//  RouletteObject.swift
//  DoubleRoulette
//
//  Created by Narumi Nogawa on 2020/04/30.
//  Copyright © 2020 Narumi Nogawa. All rights reserved.
//

import Foundation
import RealmSwift

class RouletteObject: Object {
    @objc dynamic var type: Int = 0
    @objc dynamic var item: String = "item"
    @objc dynamic var color: String = "#FF0000"
}
