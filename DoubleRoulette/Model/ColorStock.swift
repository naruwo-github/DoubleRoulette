//
//  ColorStock.swift
//  DoubleRoulette
//
//  Created by Narumi Nogawa on 2019/11/29.
//  Copyright © 2019 Narumi Nogawa. All rights reserved.
//

import UIKit

class ColorStock {
    // 約20パターンくらい用意しておいて、数値によって色を返す関数を実装する
    // 赤→黄色→緑→水色→青→紫のように遷移
    let colorDic: [UIColor] =
        [UIColor(red: 1, green: 0, blue: 0, alpha: 1), // 赤
         UIColor(red: 1, green: 0.4, blue: 0, alpha: 1), // オレンジ
         UIColor(red: 1, green: 0.7, blue: 0, alpha: 1), // 橙
         UIColor(red: 1, green: 1, blue: 0, alpha: 1), // 黄色
         UIColor(red: 0.7, green: 1, blue: 0, alpha: 1), // ライム
            
         UIColor(red: 0.4, green: 1, blue: 0, alpha: 1), // 黄緑
         UIColor(red: 0, green: 1, blue: 0.4, alpha: 1), // 緑
         UIColor(red: 0.4, green: 1, blue: 1, alpha: 1), // 水色
         UIColor(red: 0, green: 0.7, blue: 1, alpha: 1), // ターコイズ？
         UIColor(red: 0, green: 0, blue: 1, alpha: 1), // 青
            
         UIColor(red: 0.2, green: 0, blue: 0.8, alpha: 1), // 青紫
         UIColor(red: 0.4, green: 0, blue: 0.6, alpha: 1), // 紫
         UIColor(red: 0.6, green: 0, blue: 0.4, alpha: 1), // 赤紫
         UIColor(red: 0.8, green: 0, blue: 0.2, alpha: 1), // 明るい茶色
         UIColor(red: 0.5, green: 0, blue: 0, alpha: 1), // ブラウン
            
         UIColor(red: 0.5, green: 0.2, blue: 0, alpha: 1), // 茶色
         UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1), // 灰色
            UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1), // 薄灰色
         UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1), // 薄薄灰色
         UIColor(red: 1, green: 1, blue: 1, alpha: 1), // 白
    ]
    
    func proposeColor(index: Int) -> UIColor {
        if index < colorDic.count {
            return colorDic[index]
        } else {
            return UIColor.init(red: CGFloat(Double(Int.random(in: 0 ... 5)) / 5.0), green: CGFloat(Double(Int.random(in: 0 ... 5)) / 5.0), blue: CGFloat(Double(Int.random(in: 0 ... 5)) / 5.0), alpha: CGFloat(1))
        }
    }
}
