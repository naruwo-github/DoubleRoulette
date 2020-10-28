//
//  DRPopupWithBalloonView.swift
//  DoubleRoulette
//
//  Created by Narumi Nogawa on 2020/10/29.
//  Copyright © 2020 Narumi Nogawa. All rights reserved.
//

import UIKit

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
        }, completion: { (finished) in
            UIView.animate(withDuration: 0.3, delay: 5.0, animations: {
                self.alpha = 0.0
            }, completion: { _ in
                self.isHidden = true
            })
        })
    }
    
    private func commonInit() {
        let view: UIView = R.nib.drPopupWithBalloonView.firstView(owner: self, options: nil)!
        addSubviewWithConstraintAround(view)
    }
}

extension UIView {
    
    func addSubviewWithConstraintAround(_ subview: UIView) {
        self.addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = false
        subview.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        subview.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        subview.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        subview.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }

}
