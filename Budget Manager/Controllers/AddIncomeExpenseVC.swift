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
        print(catName)
        categoryButtonOutlet.setTitle(catName, for: .normal)
        selectedEntryType = entryTypeOutlet.titleForSegment(at: entryTypeOutlet.selectedSegmentIndex)!
        print(selectedEntryType)
    }
    
    @IBAction func selectCategoryPressed(_ sender: UIButton) {
        print("Select category Pressed!")
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        goToHomeVC()
    }
    @IBAction func addButtonPressed(_ sender: UIButton) {
        print("Add buttonPressed!")
        let user = Auth.auth().currentUser
        let userEntry = UserEntry(category: catName, entryName: nameTextField.text!, entryAmount: Double(amountTextField.text!)!, uid: user!.uid, entryDate: Timestamp(date: Date()), entryType: selectedEntryType)
        let dictionary = userEntry.getDictionary()

        do {
            try db.collection("entries").addDocument(data: dictionary)
        } catch let error {
            print("Error writing entry to Firestore: \(error)")
        }
    }
    @IBAction func entrySelectorChanged(_ sender: UISegmentedControl) {
        print("Entry Selector Changed!")
    }
    func goToHomeVC() {
        let homeViewController = storyboard?.instantiateViewController(identifier: "HomeVC") as? HomeVC
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
