//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Jordan Harvey-Morgan on 11/21/16.
//  Copyright © 2016 Jordan Harvey-Morgan. All rights reserved.
//

import Foundation

// create ChecklistItem object

class ChecklistItem: NSObject, NSCoding {
    var text = ""
    var checked = false
    
    // for local notifications
    var dueDate = Date()
    var shouldRemind = false
    var itemID: Int
    
    /*init(text: String, checked: Bool) {
        self.text = text
        self.checked = checked
        super.init()
    } */
    
    // initilizer
    override init() {
        // asks DataModel for a new item ID whenever a new ChecklistItem is created
        itemID = DataModel.nextChecklistItemID()
        super.init()
    }
    
    // toggle the checkmark if row/cell is tapped
    func toggleChecked() {
        checked = !checked
    }
    
    // to encode ChecklistItems
    func encode(with aCoder: NSCoder) {
        aCoder.encode(text, forKey: "Text")
        aCoder.encode(checked, forKey: "Checked")
        aCoder.encode(dueDate, forKey: "DueDate")
        aCoder.encode(shouldRemind, forKey: "ShouldRemind")
        aCoder.encode(itemID, forKey: "ItemID")
    }
    
    // initializer
    required init?(coder aDecoder: NSCoder) {
        // load previous checklist items
        text = aDecoder.decodeObject(forKey: "Text") as! String
        checked = aDecoder.decodeBool(forKey: "Checked")
        dueDate = aDecoder.decodeObject(forKey: "DueDate") as! Date
        shouldRemind = aDecoder.decodeBool(forKey: "ShouldRemind")
        itemID = aDecoder.decodeInteger(forKey: "ShouldREemind")
        super.init()
    }
    
}
