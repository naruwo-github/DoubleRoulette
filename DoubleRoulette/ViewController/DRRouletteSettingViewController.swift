//
//  DRRouletteSettingViewController.swift
//  DoubleRoulette
//
//  Created by Narumi Nogawa on 2020/07/14.
//  Copyright © 2020 Narumi Nogawa. All rights reserved.
//

// MARK: - <OS固有フレームワーク>
import UIKit
// MARK: - <外部フレームワーク>
import Firebase
import FirebaseAnalytics

// MARK: - <ルーレット画面右上ボタンより表示する設定画面のクラス>
class DRRouletteSettingViewController: UIViewController {
    
    @IBOutlet private weak var soundOnOffLabel: UILabel!
    @IBOutlet private weak var soundSwitch: UISwitch!
    @IBOutlet private weak var resultOnOffLabel: UILabel!
    @IBOutlet private weak var resultSwitch: UISwitch!
    
    // MARK: - <ライフサイクル>
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupSwitch()
        // 一度この画面にきたら下記フラグをtrueに設置する
        if !DRUserHelper.isShownAnimationSettingView {
            DRUserHelper.isShownAnimationSettingView = true
        }
        Analytics.logEvent("show_animation_setting_view", parameters: nil)
    }
    
    // MARK: - <private関数>
    
    private func setupSwitch() {
        let soundFlag = DRUserHelper.isAuthorizedPlaySound
        let resultFlag = DRUserHelper.isAuthorizedResultView
        self.soundOnOffLabel.text = soundFlag ? "ON":"OFF"
        self.soundSwitch.setOn(soundFlag, animated: true)
        self.resultOnOffLabel.text = resultFlag ? "ON":"OFF"
        self.resultSwitch.setOn(resultFlag, animated: true)
    }
    
    // MARK: - <イベント登録(IBAction)>
    
    @IBAction private func closeButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func soundOnOffSwitch(_ sender: Any) {
        let flag = (sender as! UISwitch).isOn
        self.soundOnOffLabel.text = flag ? "ON":"OFF"
        DRUserHelper.isAuthorizedPlaySound = flag
        Analytics.logEvent("sound_on_off_switch", parameters: nil)
    }
    
    @IBAction private func resultOnOffSwitch(_ sender: Any) {
        let flag = (sender as! UISwitch).isOn
        self.resultOnOffLabel.text = flag ? "ON":"OFF"
        DRUserHelper.isAuthorizedResultView = flag
        Analytics.logEvent("result_on_off_switch", parameters: nil)
    }
    
}
