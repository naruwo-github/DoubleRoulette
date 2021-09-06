//
//  DRPopupWithBalloonView.swift
//  DoubleRoulette
//
//  Created by Narumi Nogawa on 2020/10/29.
//  Copyright © 2020 Narumi Nogawa. All rights reserved.
//

// MARK: - <OS固有フレームワーク>
import UIKit

// MARK: - <ルーレット画面の右上ボタンが設定であることを示すオレンジポップアップ画面>
class DRPopupWithBalloonView: UIView {
    
    @IBOutlet private weak var balloonView: DRBalloonView!
    @IBOutlet private weak var popupLabelView: DRCustomUIView!
    @IBOutlet private weak var popUpLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    func show(fillColor: UIColor, title: String) {
        self.balloonView.fillColor = fillColor
        self.balloonView.layer.setNeedsDisplay()
        self.balloonView.layer.displayIfNeeded()
        
        self.popupLabelView.backgroundColor = fillColor
        self.popUpLabel.text = title
        
        self.showAnimateing()
    }
    
    private func showAnimateing() {
        self.isHidden = false
        self.alpha = 0.0
        UIView.animate(withDuration: 0.4, delay: 0.2, options: .curveEaseIn, animations: {
            self.alpha = 1.0
        }, completion: { [unowned self] _ in
            UIView.animate(withDuration: 0.3, delay: 3.0, animations: {
                self.alpha = 0.0
            }, completion: { [unowned self] _ in
                self.isHidden = true
            })
        })
    }
    
    private func commonInit() {
        let view: UIView = R.nib.drPopupWithBalloonView.firstView(owner: self, options: nil)!
        addSubviewWithConstraintAround(view)
    }
}
