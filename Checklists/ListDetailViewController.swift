//
//  ListDetailViewController.swift
//  Checklists
//
//  Created by Jordan Harvey-Morgan on 11/24/16.
//  Copyright © 2016 Jordan Harvey-Morgan. All rights reserved.
//

import Foundation
import UIKit

// ChecklistViewController is a delegate of ItemDetailViewController
// any object that conforms to a certain protocol has to use stated methods
protocol ListDetailViewControllerDelegate: class {
    func listDetailViewControllerDidCancel(_ controller: ListDetailViewController)
    func listDetailViewController(_ controller: ListDetailViewController, didFinishAdding checklist: Checklist)
    func listDetailViewController(_ controller: ListDetailViewController, didFinishEditing checklist: Checklist)
}

class ListDetailViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var iconImageView: UIImageView!
    
    
    weak var delegate: ListDetailViewControllerDelegate?
    
    var checklistToEdit: Checklist?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let checklist = checklistToEdit {
            title = "Edit Checklist"
            textField.text = checklist.name
            doneBarButton.isEnabled = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    // user can't select cell with the textfield
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        // if user is trying to choose an icon, then the segue can be triggered. if any other section, they can't select the row
        if indexPath.section == 1 {
            return indexPath
        } else {
            return nil
        }
    }
    
    // text field delegate to tell when text is being edited and if done button should be enabled
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text! as NSString
        let newText = oldText.replacingCharacters(in: range, with: string) as NSString
        doneBarButton.isEnabled = (newText.length > 0)
        return true
    }
    
    // cancel button
    @IBAction func cancel() {
        // send addItemViewControllerDidCancel message to delegate
        delegate?.listDetailViewControllerDidCancel(self)
    }
    
    // done button
    @IBAction func done() {
        // if checklist name is being edited
        if let checklist = checklistToEdit {
            checklist.name = textField.text!
            // send didFinishEditing message to delegate
            delegate?.listDetailViewController(self, didFinishEditing: checklist)
        } else {
            // create new checklist from user input
            let checklist = Checklist(name: textField.text!)
            // send didFinishAdding message to delegate
            delegate?.listDetailViewController(self, didFinishAdding: checklist)
        }
    }

}
