//
//  DRSaveTemplateViewController.swift
//  DoubleRoulette
//
//  Created by Narumi Nogawa on 2021/05/03.
//  Copyright © 2021 Narumi Nogawa. All rights reserved.
//

// MARK: - <OS固有フレームワーク>
import UIKit

// MARK: - <ルーレットテンプレをセーブする画面のクラス>
class DRSaveTemplateViewController: UIViewController {
    
    public var saveAction: ((String) -> Void)?
    public var cancelAction: (() -> Void)?
    
    @IBOutlet private weak var templateNameTextField: UITextField!
    @IBOutlet private weak var warningLabel: UILabel!
    
    // MARK: - <ライフサイクル>
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addToolBar(textField: self.templateNameTextField)
    }
    
    // MARK: - <private関数>
    
    private func resetContents() {
        self.warningLabel.isHidden = true
        self.templateNameTextField.text = ""
    }
    
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
        self.templateNameTextField.endEditing(true)
    }
    
    @objc private func cancelPressed() {
        self.templateNameTextField.endEditing(true)
    }
    
    // MARK: - <イベント登録(IBAction)>
    
    @IBAction private func saveButtonTapped(_ sender: Any) {
        if (self.templateNameTextField.text ?? "").isEmpty {
            // テンプレ名が未入力の場合、警告文を表示
            self.warningLabel.isHidden = false
        } else {
            self.saveAction?(self.templateNameTextField.text!)
            self.resetContents()
        }
    }
    
    @IBAction private func cancelButtonTapped(_ sender: Any) {
        self.cancelAction?()
        self.resetContents()
    }
    
}
