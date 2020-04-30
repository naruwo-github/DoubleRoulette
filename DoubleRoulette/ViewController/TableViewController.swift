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

class TableViewController: UITableViewController, AMColorPickerDelegate, GADBannerViewDelegate {
    @IBOutlet weak var adView: UIView!
    @IBOutlet weak var plusButton: UIBarButtonItem!
    @IBOutlet weak var playButton: UIBarButtonItem!
    
    var bannerView: GADBannerView!
    
    var itemData = [TableViewCell]()
    var itemName: [String] = []
    var itemColor: [UIColor] = []
    var itemType: [Int] = []
    
    //itemColorの代わりに4つの配列を使用する
    var R: [Double] = []
    var G: [Double] = []
    var B: [Double] = []
    var A: [Double] = []
    
    var indexPath: NSIndexPath!
    
    //storage
    let userDefaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.navigationItem
        configureTableView()
        
        let cellNum = userDefaults.integer(forKey: "itemDataNum")
        itemName = userDefaults.object(forKey: "itemName") as? [String] ?? []
        itemType = userDefaults.object(forKey: "itemType") as? [Int] ?? []
        
        R = userDefaults.object(forKey: "R") as? [Double] ?? []
        G = userDefaults.object(forKey: "G") as? [Double] ?? []
        B = userDefaults.object(forKey: "B") as? [Double] ?? []
        A = userDefaults.object(forKey: "A") as? [Double] ?? []
        
        for _ in 0..<cellNum {
            let item = TableViewCell()
            self.itemData.insert(item, at: 0)
            self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: UITableView.RowAnimation.right)
            //self.itemName.insert(item.name, at: 0)
            self.itemColor.insert(item.color, at: 0)
            //self.itemType.insert(item.type, at: 0)
        }
        
        //広告
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        bannerView.translatesAutoresizingMaskIntoConstraints = true
        self.adView.addSubview(bannerView)
        bannerView.center.x = self.view.center.x
        
        //デバイスID : "01fa9aa834a520d7ce4f9ccc98ab3993"
        //DRTableViewのユニット
        bannerView.adUnitID = "ca-app-pub-6492692627915720/2967728941"
        //テスト
        //bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        bannerView.delegate = self
    }
    
    @IBAction func allClearButtonTapped(_ sender: Any) {
        self.itemData = [TableViewCell]()
        self.itemName = []
        self.itemColor = []
        self.itemType = []
        self.R = []
        self.G = []
        self.B = []
        self.A = []
        self.tableView.reloadData()
        self.saveCellsToUserDefaults()
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        let item = TableViewCell()
        let colorStock = ColorStock()
        item.color = colorStock.proposeColor(index: self.itemData.count)
        
        self.itemData.insert(item, at: 0)
        self.itemName.insert(item.name, at: 0)
        self.itemColor.insert(item.color, at: 0)
        self.itemType.insert(item.type, at: 0)
        
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        item.color.getRed(&r, green: &g , blue: &b, alpha: &a)
        
        self.R.insert(Double(r), at: 0)
        self.G.insert(Double(g), at: 0)
        self.B.insert(Double(b), at: 0)
        self.A.insert(Double(a), at: 0)
        //alert to tableView
        self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: UITableView.RowAnimation.right)
        saveCellsToUserDefaults()
    }
    
    @IBAction func playButtonTapped(_ sender: Any) {
        saveCellsToUserDefaults()
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
            itemType[indexPath.row] = sender.selectedSegmentIndex
        } else {
            print("indexPath not found.")
        }
        saveCellsToUserDefaults()
    }
    
    @IBAction func textField(_ sender: UITextField) {
        let point = self.tableView.convert(sender.center, from: sender)
        if let indexPath = self.tableView.indexPathForRow(at: point) {
            itemName[indexPath.row] = sender.text ?? "Item"
        } else {
            print("indexPath not found.")
        }
        saveCellsToUserDefaults()
    }
    
    func colorPicker(_ colorPicker: AMColorPicker, didSelect color: UIColor) {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        color.getRed(&r, green: &g , blue: &b, alpha: &a)
        self.R[indexPath.row] = Double(r)
        self.G[indexPath.row] = Double(g)
        self.B[indexPath.row] = Double(b)
        self.A[indexPath.row] = Double(a)
        
        self.itemColor[indexPath.row] = color
        
        self.tableView.cellForRow(at: indexPath as IndexPath)?.contentView.viewWithTag(2)?.backgroundColor = color
        saveCellsToUserDefaults()
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            self.itemData.remove(at: indexPath.row)

            self.itemName.remove(at: indexPath.row)
            self.itemColor.remove(at: indexPath.row)
            self.itemType.remove(at: indexPath.row)
            
            self.R.remove(at: indexPath.row)
            self.G.remove(at: indexPath.row)
            self.B.remove(at: indexPath.row)
            self.A.remove(at: indexPath.row)
            
            self.tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
        }
        saveCellsToUserDefaults()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! TableViewCell
        cell.itemType.selectedSegmentIndex = self.itemType[indexPath.row]
        cell.itemName.text = self.itemName[indexPath.row]
        cell.itemColor.backgroundColor = UIColor.init(red: CGFloat(self.R[indexPath.row]), green: CGFloat(self.G[indexPath.row]), blue: CGFloat(self.B[indexPath.row]), alpha: CGFloat(self.A[indexPath.row]))
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //cell animator
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        CellAnimator.animateCell(cell: cell, withTransform: CellAnimator.TransformTilt, andDuration: 1)
    }
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "toViewController") {
            for i in 0..<itemData.count {
                let field = self.tableView.cellForRow(at: [0,i])?.contentView.viewWithTag(1) as? UITextField
                self.itemName[i] = field?.text ?? "Item"
                let btcolor = self.tableView.cellForRow(at: [0,i])?.contentView.viewWithTag(2) as? UIButton
                self.itemColor[i] = btcolor?.backgroundColor ?? UIColor.init(red: CGFloat(Double(Int.random(in: 0 ... 5)) / 5.0), green: CGFloat(Double(Int.random(in: 0 ... 5)) / 5.0), blue: CGFloat(Double(Int.random(in: 0 ... 5)) / 5.0), alpha: CGFloat(1))
                let type = self.tableView.cellForRow(at: [0, i])?.contentView.viewWithTag(3) as? UISegmentedControl
                self.itemType[i] = type?.selectedSegmentIndex ?? 0
            }
            
            let controller = segue.destination as! ViewController
            controller.itemData = self.itemData
            controller.itemName = self.itemName
            controller.itemColor = self.itemColor
            controller.itemType = self.itemType
        }else if(segue.identifier == "toColorPicker") {
        }
        saveCellsToUserDefaults()
    }
    
    func saveCellsToUserDefaults() -> Void {
        userDefaults.set(itemData.count, forKey: "itemDataNum")
        userDefaults.set(itemName, forKey: "itemName")
        userDefaults.set(itemType, forKey: "itemType")
        
        userDefaults.set(R, forKey: "R")
        userDefaults.set(G, forKey: "G")
        userDefaults.set(B, forKey: "B")
        userDefaults.set(A, forKey: "A")
    }
    
    func configureTableView() {
        tableView.rowHeight = UIDevice.current.userInterfaceIdiom == .pad ? 70 : 50
    }
    
}
