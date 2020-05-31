//
//  TableViewController.swift
//  DoubleRoulette
//
//  Created by Narumi Nogawa on 2019/07/01.
//  Copyright © 2019 Narumi Nogawa. All rights reserved.
//

import UIKit
import AMColorPicker
import GoogleMobileAds
import CellAnimator
import RealmSwift

class TableViewController: UITableViewController, AMColorPickerDelegate, GADBannerViewDelegate {
    @IBOutlet private weak var adView: UIView!
    @IBOutlet private weak var plusButton: UIBarButtonItem!
    @IBOutlet private weak var playButton: UIBarButtonItem!
    
    private var bannerView: GADBannerView!
    private let AD_UNIT_ID: String = "ca-app-pub-6492692627915720/2967728941"
    let realm = try! Realm()                        //レルムのインスタンス生成
    var rouletteCells: Results<RouletteObject>!     //データ
    private var indexPath: NSIndexPath?                     //一時的なインデックスパス
    let colorStock = ColorStock()                   //カラーストックのインスタンス生成
    let userDefaults = UserDefaults.standard        //端末内データ保存
    private var newCellId: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //ナビゲーションバーのアイテムの色を指定
        self.navigationController?.navigationBar.tintColor = UIColor.navigationItem
        self.configureTableView()   //TableViewCellの高さを設定
        //Realmに保存したデータを取得
        do{
            self.rouletteCells = realm.objects(RouletteObject.self)
            tableView.reloadData()
        }
        
        if self.userDefaults.bool(forKey: "fixed") {
            self.newCellId = userDefaults.integer(forKey: "id")
        } else {
            //全データ削除
            do{
                try realm.write {
                    realm.deleteAll()
                }
            }catch{
                print("Error in All Clear Method...")
            }
            self.tableView.reloadData()
            
            self.userDefaults.set(true, forKey: "fixed")
            self.userDefaults.set(0, forKey: "id")
        }
        
        //広告
        self.bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        self.bannerView.translatesAutoresizingMaskIntoConstraints = true
        self.adView.addSubview(self.bannerView)
        self.bannerView.center.x = self.view.center.x
        self.bannerView.adUnitID = self.AD_UNIT_ID
        self.bannerView.rootViewController = self
        self.bannerView.load(GADRequest())
        self.bannerView.delegate = self
    }
    
    @IBAction func allClearButtonTapped(_ sender: Any) {
        //全データ削除
        do{
            try realm.write {
                realm.deleteAll()
            }
        }catch{
            print("Error in All Clear Method...")
        }
        self.tableView.reloadData()
        self.userDefaults.set(0, forKey: "id")
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        let newCell = RouletteObject()
        newCell.id = self.newCellId
        
        self.newCellId += 1
        self.userDefaults.set(self.newCellId, forKey: "id")
        
        let colorRGB = UIColor.convertToRGB(self.colorStock.proposeColor(index: self.rouletteCells.count))
        newCell.color = UIColor.rgbToHex(red: Int(colorRGB.red*255), green: Int(colorRGB.green*255), blue: Int(colorRGB.blue*255))
        do{
            let realm = try Realm()
            try realm.write({ () -> Void in
                realm.add(newCell)
                print("Cell Saved")
            })
        }catch{
            print("Save is Faild")
        }
        self.tableView.reloadData()
        self.tableView.scrollToRow(at: IndexPath(row: rouletteCells.count - 1, section: 0), at: UITableView.ScrollPosition.bottom, animated: true)
    }
    
    @IBAction func playButtonTapped(_ sender: Any) {
    }
    
    @IBAction func buttonButtonTapped(_ sender: Any) {
        if let button = sender as? UIButton {
            if let superview = button.superview {
                if let cell = superview.superview as? TableViewCell {
                    self.indexPath = tableView.indexPath(for: cell) as NSIndexPath?
                }
            }
        }
        let colorPickerViewController = AMColorPickerViewController()
        colorPickerViewController.selectedColor = UIColor.red
        colorPickerViewController.delegate = self
        present(colorPickerViewController, animated: true, completion: nil)
        
    }
    
    @IBAction func segmentedControl(_ sender: UISegmentedControl) {
        let point = self.tableView.convert(sender.center, from: sender)
        if let indexPath = self.tableView.indexPathForRow(at: point) {
            let cell = rouletteCells[indexPath.row]
            do{
                let realm = try Realm()
                try realm.write({ () -> Void in
                    cell.type = sender.selectedSegmentIndex
                    realm.add(cell, update: .modified)
                    print("Cell Saved")
                })
            }catch{
                print("Save is Faild")
            }
        } else {
            print("indexPath not found.")
        }
    }
    
    @IBAction func textField(_ sender: UITextField) {
        let point = self.tableView.convert(sender.center, from: sender)
        if let indexPath = self.tableView.indexPathForRow(at: point) {
            let cell = rouletteCells[indexPath.row]
            do{
                let realm = try Realm()
                try realm.write({ () -> Void in
                    cell.item = sender.text ?? "Item"
                    realm.add(cell, update: .modified)
                    print("Cell Saved")
                })
            }catch{
                print("Save is Faild")
            }
        } else {
            print("indexPath not found.")
        }
    }
    
    func colorPicker(_ colorPicker: AMColorPicker, didSelect color: UIColor) {
        guard (indexPath != nil) else {
            return
        }
        
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        color.getRed(&r, green: &g , blue: &b, alpha: &a)
        
        let cell = rouletteCells[indexPath!.row]
        do{
            let realm = try Realm()
            try realm.write({ () -> Void in
                cell.color = UIColor.rgbToHex(red: Int(r*255), green: Int(g*255), blue: Int(b*255))
                realm.add(cell, update: .modified)
                print("Cell Saved")
            })
        }catch{
            print("Save is Faild")
        }
        let modifiedCell = self.tableView.cellForRow(at: indexPath! as IndexPath)
        (modifiedCell?.viewWithTag(2) as! UIButton).backgroundColor = UIColor(red: r, green: g, blue: b, alpha: a)
        //self.tableView.reloadRows(at: [indexPath! as IndexPath], with: UITableView.RowAnimation.fade)
        //self.tableView.reloadData()
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            do{
                let realm = try Realm()
                try realm.write {
                    realm.delete(self.rouletteCells[indexPath.row])
                }
                tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
            }catch{
            }
            self.tableView.reloadData()
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rouletteCells.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! TableViewCell
        let object = rouletteCells[indexPath.row]
        cell.itemType.selectedSegmentIndex = object.type
        cell.itemName.text = object.item
        let rgb = UIColor.hexToRGB(hex: object.color)
        cell.itemColor.backgroundColor = UIColor.rgbToColor(red: rgb[0], green: rgb[1], blue: rgb[2])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        CellAnimator.animateCell(cell: cell, withTransform: CellAnimator.TransformTilt, andDuration: 1)
    }
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "toViewController") {
            let controller = segue.destination as! ViewController
            controller.rouletteCells = rouletteCells
        }else if(segue.identifier == "toColorPicker") {
        }
    }
    
    func configureTableView() {
        tableView.rowHeight = UIDevice.current.userInterfaceIdiom == .pad ? 70 : 55
    }
    
}
