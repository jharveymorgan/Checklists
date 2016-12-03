//
//  ItemDetailViewController.swift
//  Checklists
//
//  Created by Jordan Harvey-Morgan on 11/22/16.
//  Copyright © 2016 Jordan Harvey-Morgan. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

// ChecklistViewController is a delegate of ItemDetailViewController
// any object that conforms to a certain protocol has to use stated methods
protocol ItemDetailViewControllerDelegate: class {
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController)
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem)
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem)
}

class ItemDetailViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var shouldRemindSwitch: UISwitch!
    @IBOutlet weak var dueDateLabel: UILabel!
    // to show DatePicker
    @IBOutlet weak var datePickerCell: UITableViewCell!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    // refer to ChecklistViewController via delegate
    weak var delegate: ItemDetailViewControllerDelegate?
    
    // variable for when user wants to edit an item
    var itemToEdit: ChecklistItem?
    
    // variable for the due date of an item
    var dueDate = Date()
    
    // variable to keep track of whether or not the DatePicker is visible
    var datePickerVisible = false
    
    // before screen is loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // if there is an existing item to be edited
        if let item = itemToEdit {
            title = "Edit Item"
            textField.text = item.text
            doneBarButton.isEnabled = true
            // update if item has reminder flag an updated due date
            shouldRemindSwitch.isOn = item.shouldRemind
            dueDate = item.dueDate
        }
        
        // call function to show new due date
        updateDueDateLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // make keyboard pop up without tapping the text field
        textField.becomeFirstResponder()
    }
    
    // user is only allowed to tap certain rows
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        // if user wants to change the due date
        if indexPath.section == 1 && indexPath.row == 1 {
            return indexPath
        } else {
            return nil
        }
    }
    
    // something for DatePicker
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // if cellRowAt is called with the Index Path for the DatePicker row
        if indexPath.section == 1 && indexPath.row == 2 {
            return datePickerCell
        } else {
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
    }
    
    // if datePicker is visible, then there are 3 rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 && datePickerVisible {
            return 3
        } else {
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
    }
    
    // change height if date picker is visible
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 && indexPath.row == 2 {
            return 217
        } else {
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }
    
    // only show the date picker after the user has tapped on the DueDate row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        textField.resignFirstResponder()
        
        // if user selects dueDateLabel cell
        if indexPath.section == 1 && indexPath.row == 1 {
            
            // if DatePicker is hidden
            if !datePickerVisible {
                showDatePicker()
            } else {
                hideDatePicker()
            }
        }
    }
    
    // because DatePicker row isn't initially visible, the data source doesn't think it exists
    // func to make data source think there is a third row
    override func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
        var newIndexPath = indexPath
        if indexPath.section == 1 && indexPath.row == 2 {
            newIndexPath = IndexPath(row: 0, section: indexPath.section)
        }
        return super.tableView(tableView, indentationLevelForRowAt: newIndexPath)
    }
    
    // delegate method from UITextField
    // invoked every time a user changes the text
    // gives what text should be changed (the range) and text it should be replaced with (the replacement string)
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // figure out what new text will be
        // get whatever was in the text field beforehand
        let oldText = textField.text! as NSString
        // if user changes the text, replace the old text (within a certain range) with the new text
        let newText = oldText.replacingCharacters(in: range, with: string) as NSString
        
        // enable done button if there is text
        doneBarButton.isEnabled = (newText.length > 0)
        return true
    }
    
    // cancel button
    @IBAction func cancel() {
        // send addItemViewControllerDidCancel message to delegate
        delegate?.itemDetailViewControllerDidCancel(self)
    }
    
    // done button
    @IBAction func done() {
        // if item is being edited
        if let item = itemToEdit {
            item.text = textField.text!
            item.checked = false
            
            // put value of switch and dueDate back into the ChecklistItem
            item.shouldRemind = shouldRemindSwitch.isOn
            item.dueDate = dueDate
            
            item.scheduleNotification()
            
            // send didFinishEditing message to delegate
            delegate?.itemDetailViewController(self, didFinishEditing: item)
        } else {
            // create new item from user input
            let item = ChecklistItem()
            item.text = textField.text!
            item.checked = false
            
            // put value of switch and dueDate back into the ChecklistItem
            item.shouldRemind = shouldRemindSwitch.isOn
            item.dueDate = dueDate
            
            item.scheduleNotification()
            
            // send didFinishAdding message to delegate
            delegate?.itemDetailViewController(self, didFinishAdding: item)
        }
    }
    
    // for when user chooses a new date using the DatePicker
    @IBAction func dateChanged(_ datePicker: UIDatePicker) {
        dueDate = datePicker.date
        updateDueDateLabel()
    }
    
    // function to display new due date
    func updateDueDateLabel() {
        // use DateFormatter to convert Date value to string
        let formatter = DateFormatter()
        // style date component and style time component
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        dueDateLabel.text = formatter.string(from: dueDate)
    }
    
    // function for when user needs to pick a date
    func showDatePicker() {
        datePickerVisible = true
        
        // row for due date
        let indexPathDateRow = IndexPath(row: 1, section: 1)
        // row for DatePicker
        let indexPathDatePicker = IndexPath(row: 2, section: 1)
        
        // set text color to tint color
        if let dateCell = tableView.cellForRow(at: indexPathDateRow) {
            dateCell.detailTextLabel!.textColor = dateCell.detailTextLabel!.tintColor
        }
        
        // reload the rows so that the separator shows up correctly
        // put between beginUpdates and endUpdates, so that everything changes at the same time
        tableView.beginUpdates()
        tableView.insertRows(at: [indexPathDatePicker], with: .fade)
        tableView.reloadRows(at: [indexPathDateRow], with: .none)
        tableView.endUpdates()
        
        datePicker.setDate(dueDate, animated: false)
    }
    
    // when to ask user for permission to send notifications
    @IBAction func shouldRemindToggled(_ switchControl: UISwitch) {
        
        // if remind switch is on
        if switchControl.isOn {
            // ask for permission to send notifications
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .sound], completionHandler: { granted, error in /* do nothing*/})
        }
    }
    
    // hide DatePicker after use
    func hideDatePicker() {
        if datePickerVisible {
            datePickerVisible = false
            
            let indexPathDateRow = IndexPath(row: 1, section: 1)
            let indexPathDatePicker = IndexPath(row: 2, section: 1)
            
            // change color back to grey when done editing dueDateLabel
            if let cell = tableView.cellForRow(at: indexPathDateRow) {
                cell.detailTextLabel!.textColor = UIColor(white: 0, alpha: 0.5)
            }
            
            // delete DatePicker cell from tableView
            tableView.beginUpdates()
            tableView.reloadRows(at: [indexPathDateRow], with: .none)
            tableView.deleteRows(at: [indexPathDatePicker], with: .fade)
            tableView.endUpdates()
        }
    }
    
    // hide DatePicker if user begins typing in the textfield
    func textFieldDidBeginEditing(_ textField: UITextField) {
        hideDatePicker()
    }
    
    
}// end class

/* 
 delegate methods generally reference their owner as the first or only parameter
 */
