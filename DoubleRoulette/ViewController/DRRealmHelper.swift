//
//  DRRealmHelper.swift
//  DoubleRoulette
//
//  Created by Narumi Nogawa on 2020/10/07.
//  Copyright © 2020 Narumi Nogawa. All rights reserved.
//

import UIKit

import RealmSwift

// MARK: - <ユーザの情報をRealmを使って保存するためのクラス>
final class DRRealmHelper {
    private let realm = try! Realm()
    
    init() {
    }
    
    func getRouletteData() -> Results<RouletteObject> {
        return self.realm.objects(RouletteObject.self)
    }
    
    func deleteAll() {
        do {
            try self.realm.write {
                self.realm.deleteAll()
            }
        } catch {
            print("Error in deleteAll...")
        }
    }
    
    func add(object: Object) {
        do {
            try self.realm.write({ () -> Void in
                self.realm.add(object)
            })
        } catch {
            print("Error in add...")
        }
    }
    
    func delete(object: Object) {
        do {
            try self.realm.write {
                self.realm.delete(object)
            }
        } catch {
            print("Error in delete...")
        }
    }
    
    func segmentControlUpdate(cell: RouletteObject, segment: UISegmentedControl) {
        do {
            try self.realm.write({ () -> Void in
                cell.type = segment.selectedSegmentIndex
                self.realm.add(cell, update: .modified)
            })
        } catch {
            print("Error in segmentControlUpdate...")
        }
    }
    
    func textFieldUpdate(cell: RouletteObject, textField: UITextField) {
        do {
            try self.realm.write({ () -> Void in
                cell.item = textField.text ?? "Item"
                self.realm.add(cell, update: .modified)
            })
        } catch {
            print("Error in textFieldUpdate...")
        }
    }
    
    func colorButtonUpdate(cell: RouletteObject, hexColor: String) {
        do {
            try self.realm.write({ () -> Void in
                cell.color = hexColor
                self.realm.add(cell, update: .modified)
            })
        } catch {
            print("Error in colorButtonUpdate...")
        }
    }
    
}
