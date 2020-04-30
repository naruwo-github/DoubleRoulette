//
//  Extentions.swift
//  DoubleRoulette
//
//  Created by Narumi Nogawa on 2020/04/30.
//  Copyright © 2020 Narumi Nogawa. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    //ルーレットのラベルのいろ
    class var rouletteLabel: UIColor {
        return UIColor(named: "rouletteLabel") ?? UIColor.black
    }
    
    class var navigationItem: UIColor {
        return UIColor(named: "navigationItemColor") ?? UIColor.gray
    }
}
