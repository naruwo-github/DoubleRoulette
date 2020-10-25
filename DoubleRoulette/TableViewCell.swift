//
//  TableViewCell.swift
//  DoubleRoulette
//
//  Created by Narumi Nogawa on 2019/07/01.
//  Copyright © 2019 Narumi Nogawa. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell, UITextFieldDelegate {
    @IBOutlet private weak var itemName: UITextField! // tag = 1
    @IBOutlet private weak var itemColor: UIButton! // tag = 2
    @IBOutlet private weak var itemType: UISegmentedControl! // tag = 3
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.itemName.delegate = self
    }
    
    func setupCell(name: String, color: UIColor, type: Int) {
        self.itemName.text = name
        self.itemColor.backgroundColor = color
        self.itemType.selectedSegmentIndex = type
        self.addToolBar(textField: self.itemName)
    }
    
    private func addToolBar(textField: UITextField) {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = R.color.navigationItemColor()
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(donePressed))
        let closeButton = UIBarButtonItem(title: "Close", style: UIBarButtonItem.Style.plain, target: self, action: #selector(cancelPressed))
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
    
    internal func textFieldShouldReturn(_ itemName: UITextField) -> Bool {
        self.itemName.resignFirstResponder()
        return true
    }
}
