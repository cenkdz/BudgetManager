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

        do {
            try db.collection("entries").addDocument(data: dictionary)
        } catch let error {
            print("Error writing entry to Firestore: \(error)")
        }
        self.performSegue(withIdentifier: "unwindFromAddVC", sender: self)

    }
    @IBAction func entrySelectorChanged(_ sender: UISegmentedControl) {
        print("Entry Selector Changed!")
    }
    func goToHomeVC() {
        let homeViewController = storyboard?.instantiateViewController(identifier: "HomeVC") as? HomeVC
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }

}
