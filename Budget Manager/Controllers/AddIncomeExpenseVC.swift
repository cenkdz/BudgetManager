//
//  AddIncomeExpenseVC.swift
//  Budget Manager
//
//  Created by Cenk Donmez on 23.12.2020.
//  Copyright © 2020 CTIS. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class AddIncomeExpenseVC: UIViewController {
    let db = Firestore.firestore()

    @IBOutlet weak var entryTypeOutlet: UISegmentedControl!
    @IBOutlet weak var categoryButtonOutlet: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    var catName = "Select Category"
    var selectedEntryType = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        selectedEntryType = entryTypeOutlet.titleForSegment(at: entryTypeOutlet.selectedSegmentIndex)!
        print(selectedEntryType)
        
    }
    
    @IBAction func unwindFromTableVC(_ sender: UIStoryboardSegue){
        if sender.source is TableVC {
            if let senderVC = sender.source as? TableVC{
                catName = senderVC.selectedC
                print(catName)
                categoryButtonOutlet.setTitle(catName, for: .normal)
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
    }
    
    @IBAction func selectCategoryPressed(_ sender: UIButton) {
    }

    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "unwindFromAddVC", sender: self)
    }
    @IBAction func addButtonPressed(_ sender: UIButton) {
        let user = Auth.auth().currentUser
        let userEntry = UserEntry(category: catName, entryName: nameTextField.text!, entryAmount: amountTextField.text!, uid: user!.uid, entryDate: Timestamp(date: Date()), entryType: selectedEntryType, entryID: Int.random(in: 10000000000 ..< 100000000000000000) )
        let dictionary = userEntry.getDictionary()
        if nameTextField.text!.isEmpty {
            displayAlert(message: "Name field can't be empty.", title: "Warning")
        }
        else if amountTextField.text!.isEmpty {
            displayAlert(message: "Amount field can't be empty.", title: "Warning")
        }
        else if categoryButtonOutlet.title(for: .normal) == "SELECT CATEGORY"{
            displayAlert(message: "Please select a category from the predefined list", title: "Warning")
        }
        else{
        do {
            try db.collection("entries").addDocument(data: dictionary)
        } catch let error {
            print("Error writing entry to Firestore: \(error)")
        }
        self.performSegue(withIdentifier: "unwindFromAddVC", sender: self)
        }

    }
    @IBAction func entrySelectorChanged(_ sender: UISegmentedControl) {
        selectedEntryType = entryTypeOutlet.titleForSegment(at: entryTypeOutlet.selectedSegmentIndex)!
        print(selectedEntryType)

    }
    
    func displayAlert(message: String,title: String) {
        let dialogMessage = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
        })
        dialogMessage.addAction(ok)
        self.present(dialogMessage, animated: true, completion: nil)
        
    }

}
