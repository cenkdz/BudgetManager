//
//  AllEditingViewController.swift
//  Budget Manager
//
//  Created by CTIS Student on 9.03.2021.
//  Copyright © 2021 CTIS. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class AllEditingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var selectCategoryButtonOutlet: UIButton!
    @IBOutlet weak var selectSourceButtonOutlet: UIButton!
    @IBOutlet weak var addCustomCategorySourceOutlet: UIButton!
    @IBOutlet weak var amountTextFieldOutlet: UITextField!
    @IBOutlet weak var tableViewOutlet: UITableView!
    @IBOutlet weak var saveButtonOutlet: UIButton!
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser
    var amount = "0"
    var category = "Source"
    var selectedButton = ""
    var entryID: Any!
    var source = "Category"
    var categories: [Category] = []
    var sources: [Source] = []
    var typeType = ""
    var editName = ""
    var addedText = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewOutlet.isHidden = true
        tableViewOutlet.delegate = self
        tableViewOutlet.dataSource = self

        // Do any additional setup after loading the view.
    }
    
    @IBAction func unwindToAllEditingVC(_ sender: UIStoryboardSegue){
        if sender.source is AddCategoryViewController {
            if let senderVC = sender.source as? AddCategoryViewController{
                addedText = senderVC.selectedI
                switch senderVC.type {
                case "Source":
                    source = senderVC.type
                    DispatchQueue.main.async {
                        self.getUserSources(completionHandler: { (sourceID, sourceIcon, sourceName, uid) in
                            let source = Source(sourceID: sourceID, sourceName: sourceName, sourceIcon: sourceIcon, uid: uid)
                            self.sources.append(source)
                        }, uid: self.user!.uid)
                        
                    }
                    tableViewOutlet.reloadData()


                case "Category":
                    source = senderVC.type
                    DispatchQueue.main.async {
                                self.getUserCategories(completionHandler: { (categoryID, categoryIcon, categoryName,uid) in
                            let category = Category(categoryID: categoryID, categoryName: categoryName, categoryIcon: categoryIcon, uid: uid)
                            self.categories.append(category)
                        }, uid: self.user!.uid)
                    }
                    tableViewOutlet.reloadData()


                default:
                    print("Error unwinding")
                    tableViewOutlet.reloadData()

                }
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        selectCategoryButtonOutlet.setAttributedTitle(NSAttributedString(string: category), for: .normal)
        selectSourceButtonOutlet.setAttributedTitle(NSAttributedString(string: source), for: .normal)
        amountTextFieldOutlet.text = amount

    }
    @IBAction func selectCategoryPressed(_ sender: UIButton) {
        print("Select Category Pressed!")
        selectedButton = "CategoryButton"
        self.getUserCategories(completionHandler: { (categoryID, categoryIcon, categoryName,uid) in
            let category = Category(categoryID: categoryID, categoryName: categoryName, categoryIcon: categoryIcon, uid: uid)
            self.categories.append(category)
        }, uid: self.user!.uid)
        self.tableViewOutlet.isHidden = false
        self.tableViewOutlet.reloadData()
    }
    @IBAction func selectSourcePressed(_ sender: UIButton) {
        print("Select Source Pressed!")
            selectedButton = "SourceButton"
            self.getUserSources(completionHandler: { (sourceID, sourceIcon, sourceName, uid) in
                let source = Source(sourceID: sourceID, sourceName: sourceName, sourceIcon: sourceIcon, uid: uid)
                self.sources.append(source)
            }, uid: self.user!.uid)
        self.tableViewOutlet.isHidden = false
        self.tableViewOutlet.reloadData()
    }
    @IBAction func addCustomCategorySourcePressed(_ sender: UIButton) {
        print("AddCustomCategorySource Pressed!")

        self.performSegue(withIdentifier: "goToCategoryVC", sender: self)
    }
    @IBAction func savePressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "unwindFromAllEditingVC", sender: self)
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
                        self.tableViewOutlet.reloadData()
                    }
                }
        }
    }
    
    func getUserSources(completionHandler:@escaping(String, String, String,String)->(),uid: String){
         sources = []
         db.collection("sources").whereField("uid", isEqualTo: uid)
             .getDocuments() { (querySnapshot, err) in
                 if let err = err {
                     print("Error getting documents: \(err)")
                 } else {
                     for document in querySnapshot!.documents {
                         let data = document.data()
                         completionHandler (data["sourceID"] as! String, data["sourceIcon"] as! String, data["sourceName"] as! String,data["uid"] as! String)
                         self.tableViewOutlet.reloadData()
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
    
    func deleteUserSource(selectedEntryID: Any){
        db.collection("sources").whereField("sourceID", isEqualTo: selectedEntryID).getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    document.reference.delete()
                }
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NSLog("You selected cell number: \(indexPath.row)!")
        if selectedButton == "CategoryButton" {
            let title = categories[indexPath.row].categoryName
            selectCategoryButtonOutlet.setAttributedTitle((NSAttributedString(string: title)), for: .normal)
        }
        else if selectedButton == "SourceButton" {
            let title = sources[indexPath.row].sourceName
            selectSourceButtonOutlet.setAttributedTitle((NSAttributedString(string: title)), for: .normal)
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .default, title: "Delete") { (action, indexPath) in
            switch self.selectedButton {
            case "CategoryButton":
                let entry = self.categories[indexPath.row]
                self.entryID = entry.categoryID
                
                print("BUTTON\(self.selectedButton)")
                self.deleteUserCategory(selectedEntryID: entry.categoryID)

                var changedEntries = self.categories
                changedEntries.remove(at: indexPath.row)
                self.categories = changedEntries
                tableView.reloadData()
            case "SourceButton":
                let entry = self.sources[indexPath.row]
                self.entryID = entry.sourceID
                self.deleteUserSource(selectedEntryID: entry.sourceID)

                var changedEntries = self.sources
                changedEntries.remove(at: indexPath.row)
                self.sources = changedEntries
            default:
                print("error")
            }
            
            tableView.reloadData()
            
        }
        delete.backgroundColor = UIColor.red
        
        let edit = UITableViewRowAction(style: .default, title: "Edit") { (action, indexPath) in
            switch self.selectedButton{
            case "CategoryButton":
                let entry = self.categories[indexPath.row]
                self.editName = entry.categoryName
                self.entryID = entry.categoryID
                self.typeType = "Category"

            case "SourceButton":
                let entry = self.sources[indexPath.row]
                self.editName = entry.sourceName
                self.entryID = entry.sourceID
                self.typeType = "Source"
                
                
            default:
                print("ERRROR")
            }
            DispatchQueue.main.async(){
                self.performSegue(withIdentifier: "goToCategory", sender: self)
            }
        }
        edit.backgroundColor = UIColor(red: 0.13, green: 0.17, blue: 0.40, alpha: 1.00)
        
        //edit put back
        return [delete,edit]
    }
    
//            func editEntry(completion: ()){
//                let entries = self.db.collection("entries")
//                entries.whereField("entryID", isEqualTo: ID).getDocuments(completion: { querySnapshot, error in
//                    if let err = error {
//                        print(err.localizedDescription)
//                        return
//                    }
//                    guard let docs = querySnapshot?.documents else { return }
//
//
//                    for doc in docs {
//                        let docData = doc.data()
//                        print("Doc Data\(docData)")
//                        print(docData)
//                        let ref = doc.reference
//                        ref.updateData(["entryAmount": self.amountTextField.text])
//                        completion
//                    }
//                            switch senderController {
//                    case "Income":
//
//                        self.performSegue(withIdentifier: "unwindToADDENTRY", sender: self)
//
//
//                    case "Expense":
//                        DispatchQueue.main.async(){
//
//                            self.performSegue(withIdentifier: "unwindToADDEXPENSE", sender: self)
//                        }
//                    case "Edit":
//                        DispatchQueue.main.async(){
//
//                            self.performSegue(withIdentifier: "unwindToEDIT", sender: self)
//                        }
//
//
//                    default:
//                        print("Error")
//                    }
//
//
//
//                })
//            }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "goToCategory" {
            let vc = segue.destination as? AddCategoryViewController
            vc?.name = editName
            vc?.ID = self.entryID as! String
            vc?.senderController = "Edit"
            
            vc?.type = typeType
        }
    }
}
