//
//  Checklist.swift
//  Checklists
//
//  Created by Jordan Harvey-Morgan on 11/23/16.
//  Copyright © 2016 Jordan Harvey-Morgan. All rights reserved.
//

import UIKit

class Checklist: NSObject, NSCoding {
    var name = ""
    // items for each specific checklist
    var items = [ChecklistItem]()
    
    // initializer
    init(name: String) {
        self.name = name
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "Name") as! String
        items = aDecoder.decodeObject(forKey: "Items") as! [ChecklistItem]
        super.init()
    }
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "Name")
        aCoder.encode(items, forKey: "Items")
    }
    
    // function to count unchecked items on each list
    func countUncheckedItems() -> Int {
        var count = 0
        
        // loop for items where the checked property is false
        for item in items where !item.checked {
            count += 1
        }
        return count
    }
}
