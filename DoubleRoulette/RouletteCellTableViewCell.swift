//
//  RouletteCellTableViewCell.swift
//  DoubleRoulette
//
//  Created by Narumi Nogawa on 2019/12/17.
//  Copyright © 2019 Narumi Nogawa. All rights reserved.
//

import UIKit

class RouletteCellTableViewCell: UITableViewCell {
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var colorButton: UIButton!
    
    var index: Int = 0
    
    var name: String = "Item"
    var color: UIColor = UIColor.init(red: CGFloat(Double(Int.random(in: 0 ... 5)) / 5.0), green: CGFloat(Double(Int.random(in: 0 ... 5)) / 5.0), blue: CGFloat(Double(Int.random(in: 0 ... 5)) / 5.0), alpha: CGFloat(1))
    var type: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
