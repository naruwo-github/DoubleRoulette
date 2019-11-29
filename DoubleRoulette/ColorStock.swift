//
//  ColorStock.swift
//  DoubleRoulette
//
//  Created by Narumi Nogawa on 2019/11/29.
//  Copyright © 2019 Narumi Nogawa. All rights reserved.
//

import Foundation
import UIKit

class ColorStock {
    //約20パターンくらい用意しておいて、数値によって色を返す関数を実装する
    let colorDic: [UIColor] =
    [UIColor(red: 1, green: 0, blue: 0, alpha: 1),
     UIColor(red: 0.8, green: 0.2, blue: 0, alpha: 1),
     UIColor(red: 0.6, green: 0.4, blue: 0, alpha: 1),
     UIColor(red: 0.4, green: 0.6, blue: 0, alpha: 1),
     UIColor(red: 0.2, green: 0.8, blue: 0, alpha: 1),
    UIColor(red: 0, green: 1, blue: 0, alpha: 1),
    UIColor(red: 0, green: 0.8, blue: 0.2, alpha: 1),
    UIColor(red: 0, green: 0.6, blue: 0.4, alpha: 1),
    UIColor(red: 0, green: 0.4, blue: 0.6, alpha: 1),
    UIColor(red: 0, green: 0.2, blue: 0.8, alpha: 1),
    UIColor(red: 0, green: 0, blue: 1, alpha: 1),
    UIColor(red: 0.2, green: 0, blue: 0.8, alpha: 1),
    UIColor(red: 0.4, green: 0, blue: 0.6, alpha: 1),
    UIColor(red: 0.6, green: 0, blue: 0.4, alpha: 1),
    UIColor(red: 0.8, green: 0, blue: 0.2, alpha: 1),
    UIColor(red: 1, green: 1, blue: 1, alpha: 1),
    UIColor(red: 1, green: 1, blue: 1, alpha: 1),
    UIColor(red: 1, green: 1, blue: 1, alpha: 1),
    UIColor(red: 1, green: 1, blue: 1, alpha: 1),
    UIColor(red: 1, green: 1, blue: 1, alpha: 1),
    ]
    
    func proposeColor(index: Int) -> UIColor {
        if index < colorDic.count {
            return colorDic[index]
        } else {
            return UIColor.init(red: CGFloat(Double(Int.random(in: 0 ... 5)) / 5.0), green: CGFloat(Double(Int.random(in: 0 ... 5)) / 5.0), blue: CGFloat(Double(Int.random(in: 0 ... 5)) / 5.0), alpha: CGFloat(1))
        }
    }
}
