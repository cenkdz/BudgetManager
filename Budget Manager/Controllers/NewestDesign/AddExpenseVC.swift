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

class AddExpenceVC: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var saveButtonOutlet: UIButton!
    @IBOutlet weak var amountFieldOutlet: UITextField!
    @IBOutlet weak var sourceButtonOutlet: UIButton!
    @IBOutlet weak var categoryButtonOutlet: UIButton!
    @IBOutlet weak var screenLabelOutlet: UILabel!
    
    
    
    
    let db = Firestore.firestore()
    var selectedButton = ""
    var catName = "Select Category"
    var selectedEntryType = ""
    var categories: [Category] = [Category(categoryID: "1", categoryName: "Home", categoryIcon: "", uid: "6"),Category(categoryID: "2", categoryName: "Car", categoryIcon: "", uid: "6"),Category(categoryID: "3", categoryName: "Health", categoryIcon: "", uid: "6"),Category(categoryID: "3", categoryName: "Self-Care", categoryIcon: "", uid: "6")]
    var sources: [Source] = [Source(sourceID: "1", sourceName: "Salary", sourceIcon: "", uid: "6"),Source(sourceID: "2", sourceName: "Stock Market", sourceIcon: "", uid: "6"),Source(sourceID: "3", sourceName: "Borrowed Money", sourceIcon: "", uid: "6"),Source(sourceID: "3", sourceName: "Cryptocurrency", sourceIcon: "", uid: "6")]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.isHidden = true
        tableView.delegate = self
        tableView.dataSource = self
    }
    @IBAction func selectCategoryPressed(_ sender: UIButton) {
        selectedButton = "CategoryButton"
        self.tableView.isHidden = false
        self.tableView.reloadData()
    }
    @IBAction func selectSourcePressed(_ sender: UIButton) {
        selectedButton = "SourceButton"
        self.tableView.isHidden = false
        self.tableView.reloadData()


    }
    @IBAction func savePressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        self.performSegue(withIdentifier: "unwindFromExpenseToHome", sender: self)

        
    }
    
    @IBAction func unwindFromTableVC(_ sender: UIStoryboardSegue){
        if sender.source is TableVC {
            if let senderVC = sender.source as? TableVC{
                catName = senderVC.selectedC
                print(catName)
               //categoryButtonOutlet.setTitle(catName, for: .normal)
            }
        }
    }
    
 @objc func backButtonPressed(_ sender: UIButton) {
         self.performSegue(withIdentifier: "unwindFromTestAddVC", sender: self)
     }
    
//    @objc func addButtonPressed() {
//        let user = Auth.auth().currentUser
//        let userEntry = UserEntry(category: catName, entryName: noteField.text!, entryAmount: amountField.text!, uid: user!.uid, entryDate: Timestamp(date: Date()), entryType: selectedEntryType, entryID: Int.random(in: 10000000000 ..< 100000000000000000) )
//        let dictionary = userEntry.getDictionary()
//        if noteField.text!.isEmpty {
//            displayAlert(message: "Name field can't be empty.", title: "Warning")
//        }
//        else if amountField.text!.isEmpty {
//            displayAlert(message: "Amount field can't be empty.", title: "Warning")
//        }
////        else if categoryButtonOutlet.title(for: .normal) == "SELECT CATEGORY"{
////            displayAlert(message: "Please select a category from the predefined list", title: "Warning")
////        }
//        else{
//        do {
//            try db.collection("entries").addDocument(data: dictionary)
//        } catch let error {
//            print("Error writing entry to Firestore: \(error)")
//        }
//        self.performSegue(withIdentifier: "unwindFromTestAddVC", sender: self)
//        }
//
//    }
    
//    func displayAlert(message: String,title: String) {
//        let dialogMessage = UIAlertController(title: title, message: message, preferredStyle: .alert)
//
//        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
//        })
//        dialogMessage.addAction(ok)
//        self.present(dialogMessage, animated: true, completion: nil)
//
//    }
    
//    @objc private func didTapAlert() {
//        // Present a modal alert
//        let alertController = MDCAlertController(title: "Log Out", message: "Would you like to log out?")
//        let action = MDCAlertAction(title:"Cancel") { (action) in
//            print("OK")
//
//        }
//        let action2 = MDCAlertAction(title:"Log Out", emphasis: .high) { (action) in
//                   print("OK")
//
//               }
//        alertController.addAction(action2)
//        alertController.addAction(action)
//
//        present(alertController, animated:true, completion: nil)
//
//    }
    
//    @objc private func didTapActionSheet() {
//        let actionSheet = MDCActionSheetController(title: "Category",
//                                                   message: "Pick a category")
//        actionSheet.backgroundColor = .systemBackground
//        actionSheet.titleTextColor = .label
//        actionSheet.messageTextColor = .secondaryLabel
//        actionSheet.actionTintColor = .label
//        actionSheet.actionTextColor = .label
//
//        let action1 = MDCActionSheetAction(title: "Market",
//                                             image: UIImage(systemName: "house"),
//                                             handler: {_ in return "Home action" })
//        let action2 = MDCActionSheetAction(title: "Loan",
//                                             image: UIImage(systemName: "gear"),
//                                             handler: {_ in print("Email action") })
//        let action3 = MDCActionSheetAction(title: "Food",
//                                             image: UIImage(systemName: "gear"),
//                                             handler: {_ in print("Email action") })
//        let action4 = MDCActionSheetAction(title: "Online Shopping",
//                                             image: UIImage(systemName: "gear"),
//                                             handler: {_ in print("Email action") })
//        actionSheet.addAction(action1)
//        actionSheet.addAction(action2)
//        actionSheet.addAction(action3)
//        actionSheet.addAction(action4)
//
//
//        present(actionSheet, animated: true, completion: nil)
//        self.performSegue(withIdentifier: "gototable", sender: self)
//
//    }
    

//    func goToHomeVC() {
//        let homeViewController = storyboard?.instantiateViewController(identifier: "HomeVC") as? HomeVC
//        view.window?.rootViewController = homeViewController
//        view.window?.makeKeyAndVisible()
//    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        switch selectedButton {
        case "CategoryButton":
            return categories.count
        case "SourceButton":
            return sources.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch selectedButton {
        case "CategoryButton":
            return "Categories"
        case "SourceButton":
            return "Sources"
        default:
            return ""
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CategoryCellVC
        cell.setEntry(category: categories[indexPath.row], source: sources[indexPath.row], selectedButton: selectedButton)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 30
        }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NSLog("You selected cell number: \(indexPath.row)!")
        if selectedButton == "CategoryButton" {
            let title = categories[indexPath.row].categoryName
            categoryButtonOutlet.setAttributedTitle((NSAttributedString(string: title)), for: .normal)
        }
        else if selectedButton == "SourceButton" {
            let title = sources[indexPath.row].sourceName
            sourceButtonOutlet.setAttributedTitle((NSAttributedString(string: title)), for: .normal)
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}
