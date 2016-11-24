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
    
    // toggle the checkmark if row/cell is tapped
    func toggleChecked() {
        checked = !checked
    }
    
    // to encode ChecklistItems
    func encode(with aCoder: NSCoder) {
        aCoder.encode(text, forKey: "Text")
        aCoder.encode(checked, forKey: "Checked")
    }
    
    // initializer
    required init?(coder aDecoder: NSCoder) {
        // load previous checklist items
        text = aDecoder.decodeObject(forKey: "Text") as! String
        checked = aDecoder.decodeBool(forKey: "Checked")
        super.init()
    }
    
    override init() {
        super.init()
    }
}
