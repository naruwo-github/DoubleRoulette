//
//  TableViewCell.swift
//  DoubleRoulette
//
//  Created by Narumi Nogawa on 2019/07/01.
//  Copyright © 2019 Narumi Nogawa. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell, NSSecureCoding, UITextFieldDelegate{
    
    //tag = 1
    @IBOutlet weak var itemName: UITextField!
    //tag = 2
    @IBOutlet weak var itemColor: UIButton!
    //tag = 3
    @IBOutlet weak var itemType: UISegmentedControl!
    
    var name: String = "Item"
    var color: UIColor = UIColor.init(red: CGFloat(Double(Int.random(in: 0 ... 5)) / 5.0), green: CGFloat(Double(Int.random(in: 0 ... 5)) / 5.0), blue: CGFloat(Double(Int.random(in: 0 ... 5)) / 5.0), alpha: CGFloat(1))
    var type: Int = 0
    
    static var supportsSecureCoding: Bool {
        return true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        itemName.delegate = self
        
        itemName.text = "Item"
        
        itemColor.backgroundColor = UIColor.init(red: CGFloat(Double(Int.random(in: 0 ... 5)) / 5.0), green: CGFloat(Double(Int.random(in: 0 ... 5)) / 5.0), blue: CGFloat(Double(Int.random(in: 0 ... 5)) / 5.0), alpha: CGFloat(1))
        
        itemType.selectedSegmentIndex = 0
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func textFieldDidBeginEditing(itemName: UITextField){
        self.name = itemName.text ?? "Item"
        self.color = itemColor.backgroundColor ?? UIColor.init(red: CGFloat(Double(Int.random(in: 0 ... 5)) / 5.0), green: CGFloat(Double(Int.random(in: 0 ... 5)) / 5.0), blue: CGFloat(Double(Int.random(in: 0 ... 5)) / 5.0), alpha: CGFloat(1))
        self.type = itemType.selectedSegmentIndex
    }
    
    //UITextFieldDelegate
    internal func textFieldShouldReturn(_ itemName: UITextField) -> Bool {
        self.name = itemName.text ?? "Item"
        self.color = itemColor.backgroundColor ?? UIColor.init(red: CGFloat(Double(Int.random(in: 0 ... 5)) / 5.0), green: CGFloat(Double(Int.random(in: 0 ... 5)) / 5.0), blue: CGFloat(Double(Int.random(in: 0 ... 5)) / 5.0), alpha: CGFloat(1))
        self.type = itemType.selectedSegmentIndex
        itemName.resignFirstResponder()
        return true
    }
    
    @IBAction func colorButtonTapped(_ sender: Any) {
        itemName.resignFirstResponder()
    }
}
