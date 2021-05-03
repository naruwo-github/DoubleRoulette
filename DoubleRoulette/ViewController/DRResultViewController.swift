//
//  DRResultViewController.swift
//  DoubleRoulette
//
//  Created by Narumi Nogawa on 2020/07/09.
//  Copyright © 2020 Narumi Nogawa. All rights reserved.
//

// MARK: - <OS固有フレームワーク>
import UIKit

// MARK: - <ルーレットが止まった後に表示される結果モーダル画面のクラス>
class DRResultViewController: UIViewController {
    
    @IBOutlet private weak var alphaView: UIView!
    @IBOutlet private weak var resultView: UIView!
    @IBOutlet private weak var resultLabel: UILabel!
    
    var outer: String?
    var inner: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupLabel(outer: self.outer, inner: self.inner)
    }
    
    func setupLabel(outer: String? = nil, inner: String? = nil) {
        if let _outer = outer {
            if let _inner = inner {
                self.resultLabel.text = _outer + "\n&\n" + _inner
            } else {
                self.resultLabel.text = _outer
            }
        } else if let _inner = inner {
            self.resultLabel.text = _inner
        } else {
            self.resultLabel.text = "???"
        }
    }
    
}
