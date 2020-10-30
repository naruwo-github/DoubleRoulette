//
//  DRRouletteSettingViewController.swift
//  DoubleRoulette
//
//  Created by Narumi Nogawa on 2020/07/14.
//  Copyright © 2020 Narumi Nogawa. All rights reserved.
//

import UIKit

// MARK: - <ルーレット画面右上ボタンより表示する設定画面のクラス>
class DRRouletteSettingViewController: UIViewController {
    
    @IBOutlet private weak var soundOnOffLabel: UILabel!
    @IBOutlet private weak var soundSwitch: UISwitch!
    @IBOutlet private weak var resultOnOffLabel: UILabel!
    @IBOutlet private weak var resultSwitch: UISwitch!
    private let showCloseDuration: Double = 1.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupSwitch()
        // 一度この画面にきたら下記フラグをtrueに設置する
        if !DRUserHelper.isShownAnimationSettingView {
            DRUserHelper.isShownAnimationSettingView = true
        }
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
        DispatchQueue.main.asyncAfter(deadline: .now() + self.showCloseDuration) {
            self.dismiss(animated: true, completion: nil)
        }
        UIView.animate(withDuration: self.showCloseDuration) {
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
