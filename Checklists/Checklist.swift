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
    var iconName: String
    // items for each specific checklist
    var items = [ChecklistItem]()
    
    
    // initializer for just a name
     convenience init(name: String) {
        // call init(name, iconName) and have "No Icon" as iconName parameter
        self.init(name: name, iconName: "No Icon")
    }
    
    // initializer of a name and an icon
    init(name: String, iconName: String) {
        self.name = name
        self.iconName = iconName
        super.init()
    }
    
    // for loading object from plist file
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "Name") as! String
        items = aDecoder.decodeObject(forKey: "Items") as! [ChecklistItem]
        iconName = aDecoder.decodeObject(forKey: "IconName") as! String
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "Name")
        aCoder.encode(items, forKey: "Items")
        aCoder.encode(iconName, forKey: "IconName")
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
