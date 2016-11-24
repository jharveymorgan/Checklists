//
//  ItemDetailViewController.swift
//  Checklists
//
//  Created by Jordan Harvey-Morgan on 11/22/16.
//  Copyright © 2016 Jordan Harvey-Morgan. All rights reserved.
//

import Foundation
import UIKit

// ChecklistViewController is a delegate of ItemDetailViewController
// any object that conforms to a certain protocol has to use stated methods
protocol ItemDetailViewControllerDelegate: class {
    func addItemViewControllerDidCancel(_ controller: ItemDetailViewController)
    func addItemViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem)
    func addItemViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem)
}

class ItemDetailViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    // refer to ChecklistViewController via delegate
    weak var delegate: ItemDetailViewControllerDelegate?
    // variable for when user wants to edit an item
    var itemToEdit: ChecklistItem?
    
    // before screen is loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // if there is an existing item to be edited
        if let item = itemToEdit {
            title = "Edit Item"
            textField.text = item.text
            doneBarButton.isEnabled = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // make keyboard pop up without tapping the text field
        textField.becomeFirstResponder()
    }
    
    // cancel button
    @IBAction func cancel() {
        // send addItemViewControllerDidCancel message to delegate
        delegate?.addItemViewControllerDidCancel(self)
    }
    
    // done button
    @IBAction func done() {
        // if item is being edited
        if let item = itemToEdit {
            item.text = textField.text!
            item.checked = false
            // send didFinishEditing message to delegate
            delegate?.addItemViewController(self, didFinishEditing: item)
        } else {
            // create new item from user input
            let item = ChecklistItem()
            item.text = textField.text!
            item.checked = false
            // send didFinishAdding message to delegate
            delegate?.addItemViewController(self, didFinishAdding: item)
        }
    }
    
    // user isn't allowed to select the row, so it won't turn gray
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    // delegate method from UITextField
    // invoked every time a user changes the text
    // gives what text should be changed (the range) and text it should be replaced with (the replacement string)
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // figure out what new text will be
        // TO-DO: REVIEW!! -- p.93
        // get whatever was in the text field beforehand
        let oldText = textField.text! as NSString
        // if user changes the text, replace the old text (within a certain range) with the new text
        let newText = oldText.replacingCharacters(in: range, with: string) as NSString
        
        // enable done button if there is text
        doneBarButton.isEnabled = (newText.length > 0)
        return true
    }
}// end class

/* 
 delegate methods generally reference their owner as the first or only parameter
 */
