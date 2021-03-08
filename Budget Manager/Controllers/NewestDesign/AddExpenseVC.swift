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
    var addedText = ""
    var selectedType = ""
    var catName = "Select Category"
    var selectedEntryType = ""
    var editName = ""
    var typeType = ""
    var categories: [Category] = []
    var sources: [Source] = [Source(sourceID: "1", sourceName: "Salary", sourceIcon: "", uid: "6"),Source(sourceID: "2", sourceName: "Stock Market", sourceIcon: "", uid: "6"),Source(sourceID: "3", sourceName: "Borrowed Money", sourceIcon: "", uid: "6"),Source(sourceID: "3", sourceName: "Cryptocurrency", sourceIcon: "", uid: "6")]
    let user = Auth.auth().currentUser


    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.isHidden = true
        tableView.delegate = self
        tableView.dataSource = self
        self.getUserCategories(completionHandler: { (categoryID, categoryIcon, categoryName,uid) in
            let category = Category(categoryID: categoryID, categoryName: categoryName, categoryIcon: categoryIcon, uid: uid)
        self.categories.append(category)
    }, uid: self.user!.uid)
        tableView.reloadData()
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
    
    @IBAction func unwindToADDEXPENSE(_ sender: UIStoryboardSegue){
        if sender.source is AddCategoryViewController {
            if let senderVC = sender.source as? AddCategoryViewController{
                
                addedText = senderVC.selectedI
                selectedType = senderVC.type
                switch selectedType {
                case "Category":
                    categories.append(Category(categoryID: "113", categoryName: addedText, categoryIcon: "", uid: "5"))
                case "Source":
                    sources.append(Source(sourceID: "113", sourceName: addedText, sourceIcon: "", uid: "123321"))
                default:
                    print("Error")
                }
                
                tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .default, title: "Delete") { (action, indexPath) in
            switch self.selectedButton {
            case "CategoryButton":
                let entry = self.categories[indexPath.row]
                self.deleteUserCategory(selectedEntryID: entry.categoryID)

                var changedEntries = self.categories
                changedEntries.remove(at: indexPath.row)
                self.categories = changedEntries
                tableView.reloadData()
            case "SourceButton":
                let entry = self.sources[indexPath.row]
                var changedEntries = self.sources
                changedEntries.remove(at: indexPath.row)
                self.sources = changedEntries
            default:
                print("error")
            }
            //deleteUserCategory(selectedEntryID: entry.categoryID)
            
            tableView.reloadData()
            
        }
        delete.backgroundColor = UIColor.red
        
        let edit = UITableViewRowAction(style: .default, title: "Edit") { (action, indexPath) in
            switch self.selectedButton{
            case "CategoryButton":
                let entry = self.categories[indexPath.row]
                self.editName = entry.categoryName
                
                self.typeType = "Category"
                
                
                
            case "SourceButton":
                let entry = self.sources[indexPath.row]
                self.editName = entry.sourceName
                
                self.typeType = "Source"
                
                
            default:
                print("ERRROR")
            }
            DispatchQueue.main.async(){
                self.performSegue(withIdentifier: "goAndExEdit", sender: self)
            }
        }
        edit.backgroundColor = UIColor(red: 0.13, green: 0.17, blue: 0.40, alpha: 1.00)
        
        //edit put back
        return [delete,edit]
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "goAndExEdit" {
            let vc = segue.destination as? AddCategoryViewController
            vc?.name = editName
            vc?.senderController = "Expense"
            
            vc?.type = typeType
            
        }
    }
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
        if selectedButton == "CategoryButton" {
            cell.setCategories(category: categories[indexPath.row])
        }
        else if selectedButton == "SourceButton" {
            cell.setSources(source: sources[indexPath.row])
            
        }
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

    
    
    func getUserCategories(completionHandler:@escaping(String, String, String,String)->(),uid: String){
        categories = []
        db.collection("categories").whereField("uid", isEqualTo: uid)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        let data = document.data()
                        completionHandler (data["categoryID"] as! String, data["categoryIcon"] as! String, data["categoryName"] as! String,data["uid"] as! String)
                        self.tableView.reloadData()
                    }
                }
            }
    }
    func getUserSources(completionHandler:@escaping(String, String, String,String)->(),uid: String){
        categories = []
        db.collection("sources").whereField("uid", isEqualTo: uid)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        let data = document.data()
                        completionHandler (data["sourceID"] as! String, data["sourceIcon"] as! String, data["sourceName"] as! String,data["uid"] as! String)
                        self.tableView.reloadData()
                    }
                }
            }
    }
    func deleteUserCategory(selectedEntryID: Any){
        db.collection("categories").whereField("categoryID", isEqualTo: selectedEntryID).getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    document.reference.delete()
                }
            }
        }
    }
    
    
}
