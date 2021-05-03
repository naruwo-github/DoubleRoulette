//
//  DRTableViewCell.swift
//  DoubleRoulette
//
//  Created by Narumi Nogawa on 2021/05/03.
//  Copyright © 2021 Narumi Nogawa. All rights reserved.
//

// MARK: - <OS固有フレームワーク>
import UIKit

// MARK: - <ルーレットセルのクラス>
class DRTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var segmentedControl: UISegmentedControl!
    @IBOutlet private weak var itemNameTextField: UITextField!
    @IBOutlet private weak var colorButton: UIButton!
    
    // MARK: - <ライフサイクル>
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addToolBar(textField: self.itemNameTextField)
    }
    
    // MARK: - <public関数>
    
    public func setupCell(type: Int, name: String, color: UIColor) {
        self.segmentedControl.selectedSegmentIndex = type
        self.itemNameTextField.text = name
        self.colorButton.backgroundColor = color
    }
    
    // MARK: - <private関数>
    
    private func addToolBar(textField: UITextField) {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = R.color.navigationItemColor()
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.donePressed))
        let closeButton = UIBarButtonItem(title: "Close", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.cancelPressed))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([closeButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        textField.inputAccessoryView = toolBar
    }
    
    @objc private func donePressed() {
        self.endEditing(true)
    }
    
    @objc private func cancelPressed() {
        self.endEditing(true)
    }
    
}
