//
//  DRTemplateTableViewCell.swift
//  DoubleRoulette
//
//  Created by Narumi Nogawa on 2021/05/04.
//  Copyright © 2021 Narumi Nogawa. All rights reserved.
//

// MARK: - <OS固有フレームワーク>
import UIKit

// MARK: - <外部フレームワーク>
import RealmSwift

// MARK: - <テンプレートセルのクラス>
class DRTemplateTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var outerItemLabel: UILabel!
    @IBOutlet private weak var innerItemLabel: UILabel!
    @IBOutlet private weak var outerChartView: PieChartView!
    @IBOutlet private weak var innerChartView: PieChartView!
    
    // MARK: - <ライフサイクル>
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - <public関数>
    
    public func setup(template: RouletteListObject) {
        self.titleLabel.text = template.title
        let outerItems = template.rouletteList.filter({ $0.type == 0 })
        let innerItems = template.rouletteList.filter({ $0.type == 1 })
        self.setItemLabel(outerCount: outerItems.count, innerCount: innerItems.count)
        self.drawInstantRoulette(outer: outerItems, inner: innerItems)
    }
    
    // MARK: - <private関数>
    
    private func setItemLabel(outerCount: Int, innerCount: Int) {
        self.outerItemLabel.text = "Outer: " + outerCount.description + " items"
        self.innerItemLabel.text = "Inner: " + innerCount.description + " items"
    }
    
    private func drawInstantRoulette(outer: LazyFilterSequence<List<RouletteCellInfoObject>>,
                                     inner: LazyFilterSequence<List<RouletteCellInfoObject>>) {
        self.outerChartView.radius = self.outerChartView.frame.height / 2.0 - 10
        self.outerChartView.viewCenter = self.outerChartView.center
        self.outerChartView.segments.removeAll()
        outer.forEach({
            let rgb = UIColor.hexToRGB(hex: $0.color)
            let color = UIColor(red: CGFloat(rgb[0])/255, green: CGFloat(rgb[1])/255, blue: CGFloat(rgb[2])/255, alpha: 1)
            self.outerChartView.segments.insert(Segment(color: color, value: .pi * 2.0 / CGFloat(outer.count)), at: 0)
        })
        
        self.innerChartView.radius = self.innerChartView.frame.height / 4.0 - 5
        self.innerChartView.viewCenter = self.innerChartView.center
        self.innerChartView.segments.removeAll()
        inner.forEach({
            let rgb = UIColor.hexToRGB(hex: $0.color)
            let color = UIColor(red: CGFloat(rgb[0])/255, green: CGFloat(rgb[1])/255, blue: CGFloat(rgb[2])/255, alpha: 1)
            self.innerChartView.segments.insert(Segment(color: color, value: .pi * 2 / CGFloat(inner.count)), at: 0)
        })
    }
    
}
