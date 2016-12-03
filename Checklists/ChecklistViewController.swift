//
//  ViewController.swift
//  Checklists
//
//  Created by Jordan Harvey-Morgan on 11/18/16.
//  Copyright © 2016 Jordan Harvey-Morgan. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController, ItemDetailViewControllerDelegate {
    
    
    // variable to hold a list
    var checklist: Checklist!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = checklist.name
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // functions listed in ItemDetailViewControllerDelegate
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
        // cancel button, dismiss the view
        dismiss(animated: true, completion: nil)
    }
    // done button
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem) {
        // find index of user inputed item and add it to the array of items
        let newRowIndex = checklist.items.count
        checklist.items.append(item)
        
        // display new item in table
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        
        // dismiss the view
        dismiss(animated: true, completion: nil)
    }
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem) {
        // find row number for specific item
        if let index = checklist.items.index(of: item) {
            // replace the item's original row instead of creating a new row
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                // call method to show new edited text
                configureText(for: cell, with: item)
            }
        }
        // dismiss edit screen
        dismiss(animated: true, completion: nil)
    }

    // function for number of rows that should be in the list(TableView)
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // how many rows should there be
        return checklist.items.count
    }
    
    // function for when Table View needs to show particular row on the screen
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Get a copy of a prototype cell, new or reused, and put it in local constant named cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
        
        // find the checklist item for whatever row is needed by looking in the items array at that index
        let item = checklist.items[indexPath.row]
        
        // function to get/configure the cells
        configureText(for: cell, with: item)
        configureCheckmark(for: cell, with: item)
        return cell
    }
    
    // function for when a row is tapped
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // if there is a visible cell, look at the accessory on that cell
        if let cell = tableView.cellForRow(at: indexPath) {
            // find the checklist item for whatever row is needed by looking in the items array at that index
            let item = checklist.items[indexPath.row]
            item.toggleChecked()
            
            // set checkmark based on cell and row
            configureCheckmark(for: cell, with: item)
        }
        // makes sure a row doesn't stay gray/selected after it is tapped
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // swipe to delete
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        // remove the item from the data model(items list/checklist/array) at the specified index
        checklist.items.remove(at: indexPath.row)
        
        // delete the corresponding row from the table view
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    
    // function to toggle the checkmark, pass the checklist item in directly
    func configureCheckmark(for cell: UITableViewCell, with item:ChecklistItem) {
        // checkmark label
        let label = cell.viewWithTag(12) as! UILabel
        label.textColor = view.tintColor
        // see if checkmark is visible or not
        if item.checked {
            label.text = "√"
        } else {
            label.text = ""
        }
    }
    
    // function to add/change the text label
    func configureText(for cell: UITableViewCell, with item: ChecklistItem) {
        // variable to access/change label on a cell with a certain tag
        let label = cell.viewWithTag(11) as! UILabel
        
        // set text
        //label.text = item.text
        
        // TEST:
        label.text = "\(item.itemID): \(item.text)"
    }
    
    // segue to other view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // if add button is pressed
        if segue.identifier == "AddItem" {
            // set destination of segue
            let navigationController = segue.destination as! UINavigationController
            // look at screen that is currently active inside the UINavigationController
            let controller = navigationController.topViewController as! ItemDetailViewController
            // tell ItemDetailViewController that ChecklistViewController is its delegate
            controller.delegate = self
        } else if segue.identifier == "EditItem" {
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController as! ItemDetailViewController
            controller.delegate = self
            
            // send correct item to edit
            // use UITableViewCells to find the row
            // where sender is control that triggered the segue, so the specific TableViewCell that was tapped
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                controller.itemToEdit = checklist.items[indexPath.row]
            }
        }
    }

}//end class

/* 
 numberOfRows & cellForRow are part of TableView's data source protocol
 data source = link between data and table view
 IndexPath = an object that points to a specific row in the table
 taps on rows are handled by the table view's delegate
 protocol = groups of methods
 
 rows = data; cells = views
 */
