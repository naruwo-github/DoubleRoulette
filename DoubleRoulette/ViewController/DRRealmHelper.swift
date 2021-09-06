//
//  DRRealmHelper.swift
//  DoubleRoulette
//
//  Created by Narumi Nogawa on 2020/10/07.
//  Copyright © 2020 Narumi Nogawa. All rights reserved.
//

// MARK: - <OS固有フレームワーク>
import UIKit
// MARK: - <外部フレームワーク>
import RealmSwift

// MARK: - <ユーザの情報をRealmを使って保存するためのクラス>
final class DRRealmHelper {
    private let realm = try! Realm()
    
    init() {
    }
    
    public func getRouletteData() -> Results<RouletteObject> {
        return self.realm.objects(RouletteObject.self)
    }
    
    public func getTemplateData() -> Results<RouletteListObject> {
        return self.realm.objects(RouletteListObject.self)
    }
    
    public func getLastRouletteObjectId() -> Int {
        var rtn = 0
        if let last = self.realm.objects(RouletteObject.self).sorted(byKeyPath: "id", ascending: true).last {
            rtn = last.id
        }
        return rtn
    }
    
    public func add(object: Object) {
        do {
            try self.realm.write({ [unowned self] in
                self.realm.add(object)
            })
        } catch {
            print("Error in add...")
        }
    }
    
    public func delete(object: Object) {
        do {
            try self.realm.write {
                self.realm.delete(object)
            }
        } catch {
            print("Error in delete...")
        }
    }
    
    public func deleteRouletteData() {
        self.getRouletteData().forEach {
            self.delete(object: $0)
        }
    }
    
    public func deleteAllData() {
        do {
            try self.realm.write {
                self.realm.deleteAll()
            }
        } catch {
            print("Error in deleteAllData...")
        }
    }
    
    public func segmentControlUpdate(cell: RouletteObject, segment: UISegmentedControl) {
        do {
            try self.realm.write({ [unowned self] in
                cell.type = segment.selectedSegmentIndex
                self.realm.add(cell, update: .modified)
            })
        } catch {
            print("Error in segmentControlUpdate...")
        }
    }
    
    public func textFieldUpdate(cell: RouletteObject, textField: UITextField) {
        do {
            try self.realm.write({ [unowned self] in
                cell.item = textField.text ?? "Item"
                self.realm.add(cell, update: .modified)
            })
        } catch {
            print("Error in textFieldUpdate...")
        }
    }
    
    public func colorButtonUpdate(cell: RouletteObject, hexColor: String) {
        do {
            try self.realm.write({ [unowned self] in
                cell.color = hexColor
                self.realm.add(cell, update: .modified)
            })
        } catch {
            print("Error in colorButtonUpdate...")
        }
    }
    
}
