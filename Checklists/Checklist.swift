//
//  Checklist.swift
//  Checklists
//
//  Created by Jordan Harvey-Morgan on 11/23/16.
//  Copyright © 2016 Jordan Harvey-Morgan. All rights reserved.
//

import UIKit

class Checklist: NSObject {
    var name = ""
    
    // initializer
    init(name: String) {
        self.name = name
        super.init()
    }
}
