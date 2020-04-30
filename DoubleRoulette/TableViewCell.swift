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

    static var supportsSecureCoding: Bool {
        return true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        itemName.delegate = self
    }
    
    internal func textFieldShouldReturn(_ itemName: UITextField) -> Bool {
        itemName.resignFirstResponder()
        return true
    }
}
