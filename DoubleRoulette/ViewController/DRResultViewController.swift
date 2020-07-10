//
//  DRResultViewController.swift
//  DoubleRoulette
//
//  Created by Narumi Nogawa on 2020/07/09.
//  Copyright © 2020 Narumi Nogawa. All rights reserved.
//

import UIKit

class DRResultViewController: UIViewController {
    @IBOutlet private weak var alphaView: UIView!
    @IBOutlet private weak var resultView: UIView!
    @IBOutlet weak var resultLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setupLabel(outer: String?, inner: String?) {
        if let _outer = outer {
            if let _inner = inner {
                let result = _outer + " & " + _inner
                self.resultLabel.text = result
            } else {
                self.resultLabel.text = _outer
            }
        }
        
        if let _inner = inner {
            if let _outer = outer {
                self.resultLabel.text = _outer + " & " + _inner
            } else {
                self.resultLabel.text = _inner
            }
        }
    }
    
}
