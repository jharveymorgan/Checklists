//
//  ViewController.swift
//  Checklists
//
//  Created by Jordan Harvey-Morgan on 11/18/16.
//  Copyright © 2016 Jordan Harvey-Morgan. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController {
    
    // variable to hold array of ChecklistItems
    var items: [ChecklistItem]
    
    required init?(coder aDecoder: NSCoder) {
        // empty array of ChecklistItems
        items = [ChecklistItem]()
        
        // create checklist time
        let row0item = ChecklistItem()
        // set properties
        row0item.text = "Do homework"
        row0item.checked = false
        // add to array of checklist items
        items.append(row0item)
        
        let row1item = ChecklistItem()
        row1item.text = "Brush my teeth"
        row1item.checked = false
        items.append(row1item)
        
        let row2item = ChecklistItem()
        row2item.text = "Learn iOS development"
        row2item.checked = false
        items.append(row2item)
        
        let row3item = ChecklistItem()
        row3item.text = "Work out"
        row3item.checked = false
        items.append(row3item)
        
        let row4item = ChecklistItem()
        row4item.text = "Eat HaloTop"
        row4item.checked = false
        items.append(row4item)
        
        let row5item = ChecklistItem()
        row5item.text = "Do laundry"
        row5item.checked = false
        items.append(row5item)
        
        let row6item = ChecklistItem()
        row6item.text = "Pack for Phoenix"
        row6item.checked = false
        items.append(row6item)
        
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // function for number of rows that should be in the list(TableView)
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // how many rows should there be
        return items.count
    }
    
    // function for when Table View needs to show particular row on the screen
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Get a copy of a prototype cell, new or reused, and put it in local constant named cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
        
        // find the checklist item for whatever row is needed by looking in the items array at that index
        let item = items[indexPath.row]
        
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
            let item = items[indexPath.row]
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
        items.remove(at: indexPath.row)
        
        // delete the corresponding row from the table view
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    
    // function to toggle the checkmark, pass the checklist item in directly
    func configureCheckmark(for cell: UITableViewCell, with item:ChecklistItem) {
        // see if checkmark is visible or not
        if item.checked {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
    }
    
    // function to add/change the text label
    func configureText(for cell: UITableViewCell, with item: ChecklistItem) {
        // variable to access/change label on a cell with a certain tag
        let label = cell.viewWithTag(11) as! UILabel
        // set text
        label.text = item.text
    }
    
    // add button for user
    @IBAction func addItem() {
        // index for new items in the array
        let nextRowIndex = items.count
        
        // new item created by add button, for a test
        let item = ChecklistItem()
        item.text = "TEST: I am a new row"
        item.checked = false
        items.append(item)
        
        // tell table view that a new row has been added at a certain index
        let indexPath = IndexPath(row: nextRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        
    }

}//end glass

/* 
 numberOfRows & cellForRow are part of TableView's data source protocol
 data source = link between data and table view
 IndexPath = an object that points to a specific row in the table
 taps on rows are handled by the table view's delegate
 protocol = groups of methods
 
 rows = data; cells = views
 */
