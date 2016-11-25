//
//  DataModel.swift
//  Checklists
//
//  Created by Jordan Harvey-Morgan on 11/25/16.
//  Copyright © 2016 Jordan Harvey-Morgan. All rights reserved.
//

import Foundation

class DataModel {
    var lists = [Checklist]()
    
    init() {
        loadChecklists()
    }
    
    // methods to save user's data
    func documentsDirectory() -> URL {
        // path to the Document's folder
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    func dataFilePath() -> URL {
        // return full path to the file that will store the user's data
        return documentsDirectory().appendingPathComponent("Checklists.plist")
    }
    
    // save current checklists
    func saveChecklists() {
        let data = NSMutableData()
        // NSKeyedArchiver creates plist files
        let archiver = NSKeyedArchiver(forWritingWith: data)
        
        // encode array of checklists in it into binary that can be written to a file
        archiver.encode(lists, forKey: "Checklist")
        
        archiver.finishEncoding()
        // write data to specified path
        data.write(to: dataFilePath(), atomically: true)
    }
    
    // load previous checklists
    func loadChecklists() {
        // path to the file that hold's the user's data
        let path = dataFilePath()
        // try and load contents of the data file to the variable, if it exists execute following commands
        if let data = try? Data(contentsOf: path) {
            // decode the data file
            let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
            
            // load entire contents of the array
            lists = unarchiver.decodeObject(forKey: "Checklist") as! [Checklist]
            
            unarchiver.finishDecoding()
        }
    }
}
