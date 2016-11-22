//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Jordan Harvey-Morgan on 11/21/16.
//  Copyright © 2016 Jordan Harvey-Morgan. All rights reserved.
//

import Foundation

// create ChecklistItem object

class ChecklistItem {
    var text = ""
    var checked = false
    
    // toggle the checkmark if row/cell is tapped
    func toggleChecked() {
        checked = !checked
    }
}
