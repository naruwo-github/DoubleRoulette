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
    //ルーレットのラベル(文字)の色
    class var rouletteLabel: UIColor {
        return UIColor(named: "rouletteLabel") ?? UIColor.black
    }
    //ナビゲーションアイテムの色
    class var navigationItem: UIColor {
        return UIColor(named: "navigationItemColor") ?? UIColor.gray
    }
}

extension UIView {
    //    こんな感じでいける！
    //    let image: UIImage = self.view.getScreenShot(windowFrame: self.view.frame, adFrame: self.bannerView.frame)
    //    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    //広告を隠したスクリーンショットを撮る関数（WindowFrameが画面領域、adFrameが広告領域）
    func getScreenShot(windowFrame: CGRect, adFrame: CGRect) -> UIImage {
        //context処理開始
        UIGraphicsBeginImageContextWithOptions(windowFrame.size, false, 0.0);
        //UIGraphicsBeginImageContext(windowFrame.size);  <-だめなやつ
        //context用意
        let context: CGContext = UIGraphicsGetCurrentContext()!;
        //contextにスクリーンショットを書き込む
        layer.render(in: context);
        //広告の領域を白で塗りつぶす
        context.setFillColor(UIColor.white.cgColor);
        context.fill(adFrame);
        //contextをUIImageに書き出す
        let capturedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!;
        //context処理終了
        UIGraphicsEndImageContext();
        //UIImageをreturn
        return capturedImage;
    }
}
