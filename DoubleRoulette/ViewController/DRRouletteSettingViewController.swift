//
//  DRRouletteSettingViewController.swift
//  DoubleRoulette
//
//  Created by Narumi Nogawa on 2020/07/14.
//  Copyright © 2020 Narumi Nogawa. All rights reserved.
//

import UIKit

class DRRouletteSettingViewController: UIViewController {
    @IBOutlet private weak var soundOnOffLabel: UILabel!
    @IBOutlet private weak var soundSwitch: UISwitch!
    @IBOutlet private weak var resultOnOffLabel: UILabel!
    @IBOutlet private weak var resultSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupSwitch()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.layer.cornerRadius = 20.0
    }
    
    private func setupSwitch() {
        let soundFlag = DRUserHelper.isAuthorizedPlaySound
        let resultFlag = DRUserHelper.isAuthorizedResultView
        self.soundOnOffLabel.text = soundFlag ? "ON":"OFF"
        self.soundSwitch.setOn(soundFlag, animated: true)
        self.resultOnOffLabel.text = resultFlag ? "ON":"OFF"
        self.resultSwitch.setOn(resultFlag, animated: true)
    }
    
    @IBAction private func closeButtonTapped(_ sender: Any) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.dismiss(animated: true, completion: nil)
        }
        UIView.animate(withDuration: 1.0) {
            self.view.layer.position.y += self.view.frame.height / 2.0
        }
    }
    
    @IBAction private func soundOnOffSwitch(_ sender: Any) {
        let flag = (sender as! UISwitch).isOn
        self.soundOnOffLabel.text = flag ? "ON":"OFF"
        DRUserHelper.isAuthorizedPlaySound = flag
    }
    
    @IBAction private func resultOnOffSwitch(_ sender: Any) {
        let flag = (sender as! UISwitch).isOn
        self.resultOnOffLabel.text = flag ? "ON":"OFF"
        DRUserHelper.isAuthorizedResultView = flag
    }
    
}
