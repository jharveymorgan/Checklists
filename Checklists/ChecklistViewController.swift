//
//  ViewController.swift
//  Checklists
//
//  Created by Jordan Harvey-Morgan on 11/18/16.
//  Copyright © 2016 Jordan Harvey-Morgan. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController {

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
        
        // how many rows should there be?
        return 100
    }
    
    // function for when Table View needs to show particular row on the screen
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Get a copy of a prototype cell, new or reused, and put it in local constant named cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
        
        // variable to change the label on a cell with a certain tag
        let label = cell.viewWithTag(11) as! UILabel
        
        if indexPath.row % 5 == 0 {
            label.text = "Practice/Learn Coding"
        } else if indexPath.row % 5 == 1 {
            label.text = "Sleep"
        } else if indexPath.row % 5 == 2 {
            label.text = "Study/Do Homework"
        } else if indexPath.row % 5 == 3 {
            label.text = "Work Out"
        } else if indexPath.row % 5 == 4 {
            label.text = "Buy More HaloTop"
        }
        
        // what should the cells be(??)
        return cell
    }
    
    // function for when a row is tapped
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // toggle checkmark
        if let cell = tableView.cellForRow(at: indexPath) {
            // if there isn't a checkmark, add one
            if cell.accessoryType == .none {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
        }
        
        // makes sure a row doesn't stay gray/selected after it is tapped
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

/* 
 numberOfRows & cellForRow are part of TableView's data source protocol
 data source = link between data and table view
 IndexPath = an object that points to a specific row in the table
 taps on rows are handled by the table view's delegate
 */
