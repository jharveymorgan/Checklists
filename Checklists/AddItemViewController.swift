//
//  AddItemViewController.swift
//  Checklists
//
//  Created by Jordan Harvey-Morgan on 11/22/16.
//  Copyright © 2016 Jordan Harvey-Morgan. All rights reserved.
//

import Foundation
import UIKit

// ChecklistViewController is a delegate of AddItemViewController
protocol AddItemViewControllerDelegate: class {
    func addItemViewControllerDidCancel(_ controller: AddItemViewController)
    func addItemViewController(_ controller: AddItemViewController, didFinishAdding item: ChecklistItem)
}

class AddItemViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // make keyboard pop up without tapping the text field
        textField.becomeFirstResponder()
    }
    
    // cancel button
    @IBAction func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    // done button
    @IBAction func done() {
        print("Contents of the text field: \(textField.text!)")
        dismiss(animated: true, completion: nil)
    }
    
    // user isn't allowed to select the row, so it won't turn gray
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    // delegate method from UITextField
    // invoked every time a user changes the text
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // figure out what new text will be
        let oldText = textField.text! as NSString
        let newText = oldText.replacingCharacters(in: range, with: string) as NSString
        
        // enable done button if there is text
        doneBarButton.isEnabled = (newText.length > 0)
        return true
    }
}// end class
