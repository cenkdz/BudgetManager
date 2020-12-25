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

import MaterialComponents.MaterialButtons
import MaterialComponents.MaterialButtons_Theming
import MaterialComponents.MaterialTextControls_FilledTextAreas
import MaterialComponents.MaterialTextControls_FilledTextFields
import MaterialComponents.MaterialTextControls_OutlinedTextAreas
import MaterialComponents.MaterialTextControls_OutlinedTextFields

class TestAddEntry: UIViewController {
    var dateField: MDCFilledTextField!
    var amountField: MDCFilledTextField!
    var noteField: MDCFilledTextField!
    let db = Firestore.firestore()

  
    @IBOutlet weak var entryTypeOutlet: UISegmentedControl!
    var catName = "Select Category"
    var selectedEntryType = ""
    
    @IBAction func entrySelectorChanged(_ sender: UISegmentedControl) {
                  selectedEntryType = entryTypeOutlet.titleForSegment(at: entryTypeOutlet.selectedSegmentIndex)!
                  print(selectedEntryType)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedEntryType = entryTypeOutlet.titleForSegment(at: entryTypeOutlet.selectedSegmentIndex)!
        print(selectedEntryType)
        view.backgroundColor = UIColor(hex: "#000000ff")
    }
//    @objc func backButtonPressed() {
//           goToHomeVC()
//       }
    
    override func viewWillAppear(_ animated: Bool) {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        let result = formatter.string(from: date)

        
        let dateLabel = UILabel(frame: CGRect(x: 20, y: 100, width: 300, height: 50))
        dateLabel.text = "Date"
        dateLabel.textColor = .systemYellow
        dateLabel.font = UIFont.systemFont(ofSize: 20)
        view.addSubview(dateLabel)
        
        let dateFieldFrame = CGRect(x: 150, y: 100, width: 200, height: 40)
        dateField = MDCFilledTextField(frame: dateFieldFrame)
        dateField.setFilledBackgroundColor(UIColor(hex: "#00000000")!, for: .editing)
        dateField.setFilledBackgroundColor(UIColor(hex: "#00000000")!, for: .normal)
        dateField.text = result
        dateField.backgroundColor = UIColor.systemYellow
        dateField.textColor = UIColor.systemYellow
        
        //border
        let myColor = UIColor.systemYellow
        dateField.layer.borderColor = myColor.cgColor
        dateField.layer.borderWidth = 1.0
        dateField.sizeToFit()
        view.addSubview(dateField)

        
        let categoryLabel = UILabel(frame: CGRect(x: 20, y: 150, width: 300, height: 50))
        categoryLabel.text = "Category"
        categoryLabel.textColor = .systemYellow
        categoryLabel.font = UIFont.systemFont(ofSize: 20)
        view.addSubview(categoryLabel)
        
        let categoryButton = UIButton(frame: CGRect(x: 150, y: 150, width: 200, height: 40))
        categoryButton.backgroundColor = UIColor.systemYellow
        categoryButton.layer.borderColor = myColor.cgColor
        categoryButton.layer.borderWidth = 1.0
        categoryButton.addTarget(self, action: #selector(didTapActionSheet), for: .touchUpInside)
        categoryButton.setTitle("my text here", for: .normal)
        categoryButton.setTitleColor(.black, for: .normal)
        view.addSubview(categoryButton)
        
        let amountLabel = UILabel(frame: CGRect(x: 20, y: 200, width: 300, height: 50))
        amountLabel.text = "Amount"
        amountLabel.textColor = .systemYellow
        amountLabel.font = UIFont.systemFont(ofSize: 20)
        view.addSubview(amountLabel)
        
        let amountFieldFrame = CGRect(x: 150, y: 200, width: 200, height: 40)
        amountField = MDCFilledTextField(frame: amountFieldFrame)
        amountField.setFilledBackgroundColor(UIColor(hex: "#00000000")!, for: .editing)
        amountField.setFilledBackgroundColor(UIColor(hex: "#00000000")!, for: .normal)
        amountField.backgroundColor = UIColor.systemYellow
        amountField.layer.borderColor = myColor.cgColor
        amountField.keyboardType = .numberPad
        amountField.layer.borderWidth = 1.0
        amountField.sizeToFit()
        view.addSubview(amountField)
        
        let noteLabel = UILabel(frame: CGRect(x: 20, y: 250, width: 300, height: 50))
        noteLabel.text = "Note"
        noteLabel.textColor = .systemYellow
        noteLabel.font = UIFont.systemFont(ofSize: 20)
        view.addSubview(noteLabel)
        
        let noteFieldFrame = CGRect(x: 150, y: 250, width: 200, height: 40)
        noteField = MDCFilledTextField(frame: noteFieldFrame)
        noteField.textColor = UIColor.red
        noteField.setFilledBackgroundColor(UIColor(hex: "#00000000")!, for: .editing)
        noteField.setFilledBackgroundColor(UIColor(hex: "#00000000")!, for: .normal)
        noteField.backgroundColor = UIColor.systemYellow
        noteField.layer.borderColor = myColor.cgColor
        noteField.layer.borderWidth = 1.0
        noteField.sizeToFit()
        view.addSubview(noteField)
        
        let backButton = UIButton(frame: CGRect(x: 25, y: 40, width: 100, height: 30))
        backButton.setTitle("Back", for: .normal)
        backButton.backgroundColor = .systemYellow
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        backButton.setTitleColor(.black, for: .normal)
        view.addSubview(backButton)
        
        let addButton = UIButton(frame: CGRect(x: (view.frame.size.width-220)/2, y: 400, width: 220, height: 50))
        addButton.setTitle("Add", for: .normal)
        addButton.backgroundColor = .systemYellow
        addButton.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
        addButton.setTitleColor(.black, for: .normal)
        view.addSubview(addButton)
        
    }
    
    @IBAction func unwindFromTableVC(_ sender: UIStoryboardSegue){
        if sender.source is TableVC {
            if let senderVC = sender.source as? TableVC{
                catName = senderVC.selectedC
                print(catName)
               // categoryButtonOutlet.setTitle(catName, for: .normal)
            }
        }
    }
    
 @objc func backButtonPressed(_ sender: UIButton) {
         self.performSegue(withIdentifier: "unwindFromTestAddVC", sender: self)
     }
    
    @objc func addButtonPressed() {
        let user = Auth.auth().currentUser
        let userEntry = UserEntry(category: catName, entryName: noteField.text!, entryAmount: amountField.text!, uid: user!.uid, entryDate: Timestamp(date: Date()), entryType: selectedEntryType, entryID: Int.random(in: 10000000000 ..< 100000000000000000) )
        let dictionary = userEntry.getDictionary()
        if noteField.text!.isEmpty {
            displayAlert(message: "Name field can't be empty.", title: "Warning")
        }
        else if amountField.text!.isEmpty {
            displayAlert(message: "Amount field can't be empty.", title: "Warning")
        }
//        else if categoryButtonOutlet.title(for: .normal) == "SELECT CATEGORY"{
//            displayAlert(message: "Please select a category from the predefined list", title: "Warning")
//        }
        else{
        do {
            try db.collection("entries").addDocument(data: dictionary)
        } catch let error {
            print("Error writing entry to Firestore: \(error)")
        }
        self.performSegue(withIdentifier: "unwindFromTestAddVC", sender: self)
        }

    }
    
    func displayAlert(message: String,title: String) {
        let dialogMessage = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
        })
        dialogMessage.addAction(ok)
        self.present(dialogMessage, animated: true, completion: nil)
        
    }
    
    @objc private func didTapAlert() {
        // Present a modal alert
        let alertController = MDCAlertController(title: "Log Out", message: "Would you like to log out?")
        let action = MDCAlertAction(title:"Cancel") { (action) in
            print("OK")
            
        }
        let action2 = MDCAlertAction(title:"Log Out", emphasis: .high) { (action) in
                   print("OK")
                   
               }
        alertController.addAction(action2)
        alertController.addAction(action)

        present(alertController, animated:true, completion: nil)
        
    }
    
    @objc private func didTapActionSheet() {
        let actionSheet = MDCActionSheetController(title: "Category",
                                                   message: "Pick a category")
        actionSheet.backgroundColor = .systemBackground
        actionSheet.titleTextColor = .label
        actionSheet.messageTextColor = .secondaryLabel
        actionSheet.actionTintColor = .label
        actionSheet.actionTextColor = .label
        
        let action1 = MDCActionSheetAction(title: "Market",
                                             image: UIImage(systemName: "house"),
                                             handler: {_ in return "Home action" })
        let action2 = MDCActionSheetAction(title: "Loan",
                                             image: UIImage(systemName: "gear"),
                                             handler: {_ in print("Email action") })
        let action3 = MDCActionSheetAction(title: "Food",
                                             image: UIImage(systemName: "gear"),
                                             handler: {_ in print("Email action") })
        let action4 = MDCActionSheetAction(title: "Online Shopping",
                                             image: UIImage(systemName: "gear"),
                                             handler: {_ in print("Email action") })
        actionSheet.addAction(action1)
        actionSheet.addAction(action2)
        actionSheet.addAction(action3)
        actionSheet.addAction(action4)


        present(actionSheet, animated: true, completion: nil)
        
    }
    
  func selectCategoryPressed(_ sender: UIButton) {
        print("Select category Pressed!")
    }

    func goToHomeVC() {
        let homeViewController = storyboard?.instantiateViewController(identifier: "HomeVC") as? HomeVC
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
    
}
