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
    
    // for UserDefaults and when showing last viewed list
    var indexOfSelectedChecklist: Int {
        // when indexOfSelectedChecklist gets read
        get {
            return UserDefaults.standard.integer(forKey: "ChecklistIndex")
        }
        // when new value is put into indexOfSelectedChecklist 
        set {
            UserDefaults.standard.set(newValue, forKey: "ChecklistIndex")
        }
    }
    
    init() {
        loadChecklists()
        registerDefaults()
        handleFirstTime()
        
        // print path to plist
        print(documentsDirectory())
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
            
            // sort
            sortChecklists()
        }
    }
    
    // set default values for UserDefaults
    func registerDefaults() {
        let dictionary: [String: Any] = ["ChecklistIndex": -1, "FirstTime": true, "ChecklistItemID": 0]
        UserDefaults.standard.register(defaults: dictionary)
    }
    
    // for when user opens app for the first time
    func handleFirstTime() {
        let userDefaults = UserDefaults.standard
        let firstTime = userDefaults.bool(forKey: "FirstTime")
        
        // if user is using app for first time
        if firstTime {
            let checklist = Checklist(name: "List")
            lists.append(checklist)
            
            indexOfSelectedChecklist = 0
            userDefaults.set(false, forKey: "FirstTime")
            userDefaults.synchronize()
        }
    }
    
    // sort checklists
    func sortChecklists() {
        // use closure and apply sorting formula
        lists.sort(by: { checklist1, checklist2 in return checklist1.name.localizedStandardCompare(checklist2.name) == .orderedAscending })
    }
    
    // use class so that this function can be used without referencing DataModel object
    class func nextChecklistItemID() -> Int {
        let userDefaults = UserDefaults.standard
        // get current ChecklistItemID from UserDefaults and add 1
        let itemID = userDefaults.integer(forKey: "ChecklistItemID")
        userDefaults.set(itemID + 1, forKey: "ChecklistItemID")
        // update the changes immediately
        userDefaults.synchronize()
        
        return itemID
    }
}// end class
