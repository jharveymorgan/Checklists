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
        return 1
    }
    
    // function for
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // variable for cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
        
        // what should the cells be(??)
        return cell
    }

}

/* 
 numberOfRows & cellForRow are part of TableView's data source protocol
 data source = link between data and table view
 */
