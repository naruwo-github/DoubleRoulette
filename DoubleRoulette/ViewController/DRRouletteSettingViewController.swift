//
//  DRRouletteSettingViewController.swift
//  DoubleRoulette
//
//  Created by Narumi Nogawa on 2020/07/14.
//  Copyright © 2020 Narumi Nogawa. All rights reserved.
//

import UIKit

class DRRouletteSettingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.layer.cornerRadius = 20.0
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.dismiss(animated: true, completion: nil)
        }
        UIView.animate(withDuration: 1.0) {
            self.view.layer.position.y += self.view.frame.height / 2.0
        }
    }
    
}
