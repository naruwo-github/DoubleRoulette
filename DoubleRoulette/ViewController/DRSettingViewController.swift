//
//  DRSettingViewController.swift
//  DoubleRoulette
//
//  Created by Narumi Nogawa on 2021/05/03.
//  Copyright © 2021 Narumi Nogawa. All rights reserved.
//

// MARK: - <OS固有フレームワーク>
import AppTrackingTransparency
import UIKit
// MARK: - <外部フレームワーク>
import AMColorPicker
import CellAnimator
import Firebase
import FirebaseAnalytics
import GoogleMobileAds
import RealmSwift

// MARK: - <ルーレットセルの設定画面(初期画面)>
class DRSettingViewController: UIViewController {
    
    @IBOutlet private weak var topBannerAdView: GADBannerView!
    @IBOutlet private weak var bottomBannerAdView: GADBannerView!
    @IBOutlet private weak var tableView: UITableView!
    
    private let popupWindow: UIWindow = .init(frame: UIScreen.main.bounds)
    private let colorStock = ColorModel()
    private var rouletteData: Results<RouletteObject>!
    private var edittingData: RouletteObject?
    
    // MARK: - <ライフサイクル>
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // キーボードが閉じる際のイベントを受け取るNotification
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillHide(sender:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        
        self.navigationController?.navigationBar.tintColor = R.color.navigationItemColor()
        self.setupAd()
        self.setupTableView()
        self.roadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Analytics.logEvent("show_cell_setting_view", parameters: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization(completionHandler: { _ in })
        }
    }
    
    // MARK: - <public関数>
    
    // MARK: - <private関数>
    
    private func setupAd() {
        self.topBannerAdView.adUnitID = DRStringSource.init().CellTableVCTopAdID
        self.topBannerAdView.rootViewController = self
        self.topBannerAdView.load(GADRequest())
        
        self.bottomBannerAdView.adUnitID = DRStringSource.init().CellTableVCBottomAdID
        self.bottomBannerAdView.rootViewController = self
        self.bottomBannerAdView.load(GADRequest())
    }
    
    private func setupTableView() {
        self.tableView.register(UINib(resource: R.nib.drTableViewCell), forCellReuseIdentifier: "RouletteCell")
        self.tableView.rowHeight = UIDevice.current.userInterfaceIdiom == .pad ? 80 : 60
    }
    
    private func roadData() {
        self.rouletteData = DRRealmHelper.init().getRouletteData()
        self.tableView.reloadData()
    }
    
    private func preventHidingTextField(sender: UITextField) {
        let point = self.tableView.convert(sender.center, from: sender)
        let fieldY = point.y + 100 + self.view.safeAreaInsets.top
        if fieldY > self.view.center.y {
            let diff = fieldY - self.view.center.y - self.tableView.contentOffset.y
            UIView.animate(withDuration: TimeInterval(0.5), animations: { [unowned self] () -> Void in
                let transform = CGAffineTransform(translationX: 0, y: -diff)
                self.view.transform = transform
            })
        }
    }
    
    // キーボードが閉じられた時
    @objc private func keyboardWillHide(sender: NSNotification) {
        guard let userInfo = sender.userInfo else { return }
        let duration: Float = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).floatValue
        UIView.animate(withDuration: TimeInterval(duration), animations: { [unowned self] () -> Void in
            // 画面をずらした分を元に戻す
            self.view.transform = CGAffineTransform.identity
        })
    }
    
    // MARK: - <イベント登録(IBAction)>
    
    @IBAction private func clearAllButtonTapped(_ sender: Any) {
        self.rouletteData.forEach({
            DRRealmHelper.init().delete(object: $0)
        })
        self.tableView.reloadData()
        Analytics.logEvent("all_clear_button", parameters: nil)
    }
    
    @IBAction private func playButtonTapped(_ sender: Any) {
        guard let rouletteVC = R.storyboard.main.drRouletteViewController() else { return }
        self.navigationController?.pushViewController(rouletteVC, animated: true)
    }
    
    @IBAction private func addButtonTapped(_ sender: Any) {
        let newCell = RouletteObject()
        newCell.id = DRRealmHelper.init().getLastRouletteObjectId() + 1
        
        let colorRGB = UIColor.convertToRGB(self.colorStock.proposeColor(index: self.rouletteData.count))
        newCell.color = UIColor.rgbToHex(red: Int(colorRGB.red * 255), green: Int(colorRGB.green * 255), blue: Int(colorRGB.blue * 255))
        DRRealmHelper.init().add(object: newCell)
        self.tableView.reloadData()
        self.tableView.scrollToRow(at: IndexPath(row: rouletteData.count - 1, section: 0), at: .bottom, animated: true)
        Analytics.logEvent("add_cell_button", parameters: nil)
    }
    
    @IBAction private func templateButtonTapped(_ sender: Any) {
        let vc = R.storyboard.modal.drTemplateListViewController()!
        vc.cellSelectedAction = { [unowned self] in
            self.tableView.reloadData()
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    // 現在のセルのデータをテンプレートとして保存する機能
    @IBAction private func saveButtonTapped(_ sender: Any) {
        // セルが一つも追加されてない場合はsaveボタンの挙動を行わない
        guard self.rouletteData.count > 0 else { return }
        
        // 遷移先のポップアップの表示と挙動の設定
        let vc = R.storyboard.popup.drSaveTemplateViewController()!
        vc.saveAction = { [unowned self] text in
            let templateData = RouletteListObject()
            templateData.title = text
            self.rouletteData.forEach({
                let cellInfo = RouletteCellInfoObject()
                cellInfo.type = $0.type
                cellInfo.item = $0.item
                cellInfo.color = $0.color
                templateData.rouletteList.append(cellInfo)
            })
            DRRealmHelper.init().add(object: templateData)
            self.view.window?.makeKeyAndVisible()
        }
        vc.cancelAction = {
            self.view.window?.makeKeyAndVisible()
        }
        self.popupWindow.rootViewController = vc
        self.popupWindow.makeKeyAndVisible()
    }
    
}

// MARK: - <UITableViewを扱うための拡張>
extension DRSettingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rouletteData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RouletteCell") as! DRTableViewCell
        let object = self.rouletteData[indexPath.row]
        let rgb = UIColor.hexToRGB(hex: object.color)
        cell.setupCell(object: object, type: object.type, name: object.item, color: UIColor.rgbToUIColor(red: rgb[0], green: rgb[1], blue: rgb[2]))
        // セグメントをタップした際の挙動
        cell.segmentedControlAction = { [unowned self] object, sender in
            self.edittingData = object
            DRRealmHelper.init().segmentControlUpdate(cell: object, segment: sender)
            Analytics.logEvent("segment_controll_tapped", parameters: nil)
        }
        // テキストフィールド編集時の挙動
        cell.textFieldEdittingAction = { [unowned self] object, sender in
            self.edittingData = object
            DRRealmHelper.init().textFieldUpdate(cell: object, textField: sender)
            Analytics.logEvent("text_field_tapped", parameters: nil)
        }
        // テキストフィールドタップ時の挙動
        cell.textFieldFocusedAction = { [unowned self] sender in
            // テキストフィールドがキーボードで隠れないようにする
            self.preventHidingTextField(sender: sender)
        }
        // セルのカラーボタンをタップした際の挙動
        cell.colorButtonAction = { [unowned self] object in
            self.edittingData = object
            self.showColorPicker()
            Analytics.logEvent("show_color_picker_button", parameters: nil)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        CellAnimator.animateCell(cell: cell, withTransform: CellAnimator.TransformTilt, andDuration: 1)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            DRRealmHelper.init().delete(object: self.rouletteData[indexPath.row])
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.tableView.reloadData()
        }
    }
    
}

// MARK: - <AMColorPickerを使うための拡張>
extension DRSettingViewController: AMColorPickerDelegate {
    
    func colorPicker(_ colorPicker: AMColorPicker, didSelect color: UIColor) {
        guard let object = self.edittingData else { return }

        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        DRRealmHelper.init().colorButtonUpdate(cell: object, hexColor: UIColor.rgbToHex(red: Int(r * 255), green: Int(g * 255), blue: Int(b * 255)))
        self.tableView.reloadData()
    }
    
    private func showColorPicker() {
        let colorPickerViewController = AMColorPickerViewController()
        colorPickerViewController.selectedColor = UIColor.red
        colorPickerViewController.delegate = self
        self.present(colorPickerViewController, animated: true, completion: nil)
    }
    
}
