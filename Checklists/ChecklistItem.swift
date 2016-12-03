//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Jordan Harvey-Morgan on 11/21/16.
//  Copyright © 2016 Jordan Harvey-Morgan. All rights reserved.
//

import Foundation
import UserNotifications

// create ChecklistItem object

class ChecklistItem: NSObject, NSCoding {
    var text = ""
    var checked = false
    
    // for local notifications
    var dueDate = Date()
    var shouldRemind = false
    var itemID: Int
    
    
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
    
    // initializer
    required init?(coder aDecoder: NSCoder) {
        // load previous checklist items
        text = aDecoder.decodeObject(forKey: "Text") as! String
        checked = aDecoder.decodeBool(forKey: "Checked")
        // for notifications
        dueDate = aDecoder.decodeObject(forKey: "DueDate") as! Date
        shouldRemind = aDecoder.decodeBool(forKey: "ShouldRemind")
        itemID = aDecoder.decodeInteger(forKey: "ItemID")
        super.init()
    }
    
    // when an item is about to be deleted, delete all pending notifications associated with it
    deinit {
        removeNotification()
    }
    
    // to encode ChecklistItems
    func encode(with aCoder: NSCoder) {
        aCoder.encode(text, forKey: "Text")
        aCoder.encode(checked, forKey: "Checked")
        // for notifications
        aCoder.encode(dueDate, forKey: "DueDate")
        aCoder.encode(shouldRemind, forKey: "ShouldRemind")
        aCoder.encode(itemID, forKey: "ItemID")
    }
    
    // to schedule a notification
    func scheduleNotification() {
        removeNotification()
        // the user turned on the remind switch and the due date is set in the future of the current date
        if shouldRemind && dueDate > Date() {
            
            // set item's text as reminder message
            let content = UNMutableNotificationContent()
            content.title = "Reminder: "
            content.body = text
            content.sound = UNNotificationSound.default()
            
            // schedule notification to exact minute
            let calendar = Calendar(identifier: .gregorian)
            let components = calendar.dateComponents([.month, .day, .hour, .minute], from: dueDate)
            
            // trigger notification at a specific date
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            
            // create NotificationRequest object, convert itemID to string in order to uniquely identify each notification in case of cancellation
            let request = UNNotificationRequest(identifier: "\(itemID)", content: content, trigger: trigger)
            
            // add new notification to UserNotificationCenter
            let center = UNUserNotificationCenter.current()
            center.add(request)
            
            print("Schedule notification\(request) for itemID \(itemID)")
        }
    }
    
    // for when wants to remove a notification
    func removeNotification() {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["\(itemID)"])
    }
    
}
