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
    var SELECTEDCAT = ""

    var mainUserCategories: [String] = []
    var sources: [Category] = []
    var TYPE = ""
    var typeType = ""
    var editName = ""
    var addedText = ""
    var userAction = ""
    
    var categories: [[Category]] = []
    var hehe = [Category]()
    var firebaseCategories = [Category]()
    var thebestcategories = [[Category]]()
    
    var USERSELECTEDCATEGORY: Category!


    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Selected User Action Is \(userAction)")
        self.hideKeyboardWhenTappedAround()

        print("asd1\(TYPE)")
        print("asd2\(typeType)")
        print("asd3\(category)")
        print("asd4\(source)")
        print("asd5\(userAction)")
        
        if TYPE == "Income" {
            selectSourceButtonOutlet.isHidden = true
            selectCategoryButtonOutlet.setTitle("Select a Source", for: .normal)
        }else{
            selectSourceButtonOutlet.isHidden = false
        }

        tableViewOutlet.isHidden = true
        tableViewOutlet.delegate = self
        tableViewOutlet.dataSource = self
        print("Type is \(typeType)")
        print("TYPE is \(TYPE)")
        print("Id is\(entryID)")

    }
    
    override func viewWillAppear(_ animated: Bool) {
        selectCategoryButtonOutlet.setAttributedTitle(NSAttributedString(string: category), for: .normal)
        selectSourceButtonOutlet.setAttributedTitle(NSAttributedString(string: source), for: .normal)
        if TYPE == "Expense" {
            amountTextFieldOutlet.text = String(amount.dropFirst())
//            addCustomCategorySourceOutlet.setTitle("Add Custom Category", for: .normal)
        }
        else if TYPE == "Income" {
            amountTextFieldOutlet.text = amount
        }
        print("Selected User Action Is \(userAction)")
        
    }
    
    func getMainCategories(categories: [Category]) -> [String]{
        var mainCategories: [String] = []
        
        for category in categories {
            let mainCategory = category.categoryMainName
            
            if !mainCategories.contains(mainCategory){
                mainCategories.append(mainCategory)
            }
            
            
        }
        
//        let sortedDays = days.sorted {
//            Int($0)! > Int($1)!
//        }
        
        mainUserCategories = mainCategories
        
        return mainUserCategories
    }
    
    func thebest(){
        self.categories = []
        self.thebestcategories = []
        self.hehe = []
        
        for main in getMainCategories(categories: firebaseCategories) {
            if !hehe.isEmpty {
                hehe.removeAll()
            }
            let main = main
            
            for cat in firebaseCategories {
                let mainCat = cat.categoryMainName
                
                if cat.categoryMainName == main {
                            hehe.append(cat)
                }
            }
            thebestcategories.append(hehe)
        }
        //let sortedArray = thebestentries.sorted(by: {$0[0].day > $1[0].day })
        // entries.removeAll()
        categories = thebestcategories
        
    }
    
    
    
    @IBAction func unwindToAllEditingVC(_ sender: UIStoryboardSegue) {
        if sender.source is AddCategoryViewController {
            if let senderVC = sender.source as? AddCategoryViewController {
                switch senderVC.type {
                case "Source":
                    source = senderVC.type
                    self.getUserCategories(completionHandler: { (categoryID, categoryIcon, categoryMainName,categorySubName,categoryType, uid) in
                        let category = Category(categoryID: categoryID, categoryMainName: categoryMainName,categorySubName:categorySubName, categoryIcon: categoryIcon, categoryType: categoryType, uid: uid)
                        if category.categoryType == "Income"{
                        self.sources.append(category)
                        }
                        self.tableViewOutlet.isHidden = false
                        self.tableViewOutlet.reloadData()
                    }, uid: self.user!.uid)
                    tableViewOutlet.reloadData()
                case "Category":
                    category = senderVC.type
                    self.getUserCategories(completionHandler: { (categoryID, categoryIcon, categoryMainName,categorySubName,categoryType, uid) in
                        let category = Category(categoryID: categoryID, categoryMainName: categoryMainName,categorySubName:categorySubName, categoryIcon: categoryIcon, categoryType: categoryType, uid: uid)
                        self.firebaseCategories.append(category)
                        self.thebest()
                        self.tableViewOutlet.reloadData()
                    }, uid: self.user!.uid)
                    tableViewOutlet.reloadData()
                    
                default:
                    print("DEFAULT")
                    
                }
            }
        }
    }
    @IBAction func selectCategoryPressed(_ sender: UIButton) {
        print("Select Category Pressed!")
        categories.removeAll()
        thebestcategories.removeAll()
        hehe.removeAll()
        firebaseCategories.removeAll()
        selectedButton = "CategoryButton"
        if categories.isEmpty {
        self.getUserCategories(completionHandler: { (categoryID, categoryIcon, categoryMainName,categorySubName,categoryType, uid) in
            let category = Category(categoryID: categoryID, categoryMainName: categoryMainName,categorySubName:categorySubName, categoryIcon: categoryIcon, categoryType: categoryType, uid: uid)
            self.categories = []
            self.thebestcategories = []
            self.hehe = []
            if self.TYPE == "Expense"{
            if category.categoryType == "Expense"{
            self.firebaseCategories.append(category)
            }
            }else if self.TYPE == "Income"{
                if category.categoryType == "Income"{
                self.firebaseCategories.append(category)
                }
                }
            self.thebest()
            self.tableViewOutlet.reloadData()
        }, uid: self.user!.uid)
        }else{
            categories.removeAll()
            thebestcategories.removeAll()
            hehe.removeAll()
            firebaseCategories.removeAll()
            self.getUserCategories(completionHandler: { (categoryID, categoryIcon, categoryMainName,categorySubName,categoryType, uid) in
                let category = Category(categoryID: categoryID, categoryMainName: categoryMainName,categorySubName:categorySubName, categoryIcon: categoryIcon, categoryType: categoryType, uid: uid)
                self.categories = []
                self.thebestcategories = []
                self.hehe = []
                if category.categoryType == "Expense"{
                self.firebaseCategories.append(category)
                }
                self.thebest()
                self.tableViewOutlet.reloadData()
            }, uid: self.user!.uid)
        }
        self.tableViewOutlet.isHidden = false
    }
    @IBAction func selectSourcePressed(_ sender: UIButton) {
        print("Select Source Pressed!")
        selectedButton = "SourceButton"
        sources = []
        self.getUserCategories(completionHandler: { (categoryID, categoryIcon, categoryMainName,categorySubName,categoryType, uid) in
            let category = Category(categoryID: categoryID, categoryMainName: categoryMainName,categorySubName:categorySubName, categoryIcon: categoryIcon, categoryType: categoryType, uid: uid)
            if category.categoryType == "Income"{
            self.sources.append(category)
            }
            self.tableViewOutlet.isHidden = false
            self.tableViewOutlet.reloadData()
        }, uid: self.user!.uid)


    }
    @IBAction func addCustomCategorySourcePressed(_ sender: UIButton) {
        print("AddCustomCategorySource Pressed!")
        typeType = "Add"
        
        self.performSegue(withIdentifier: "goToCategory", sender: self)
    }
    @IBAction func savePressed(_ sender: UIButton) {
        
        switch userAction {
        case "IncomeButton":
            DispatchQueue.main.async {
                self.addUserEntry()
            }
        case "ExpenseButton":
            DispatchQueue.main.async {
                self.addUserEntry() }
        default:
            DispatchQueue.main.async {
                self.editEntry(completion: ())
            }
        }
        
        
    }
    
    func getUserCategories(completionHandler: @escaping(String,String, String, String, String,String) -> (), uid: String) {
        self.categories = []
        self.thebestcategories = []
        self.hehe = []
        db.collection("categories").whereField("uid", isEqualTo: uid)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        let data = document.data()
                        completionHandler (data["categoryID"] as! String, data["categoryIcon"] as! String, data["categoryMainName"] as! String,data["categorySubName"] as! String,data["categoryType"] as! String, data["uid"] as! String)
                        self.tableViewOutlet.reloadData()
                    }
                }
            }
    }
    
    func getUserSources(completionHandler: @escaping(String, String, String, String) -> (), uid: String) {
        sources = []
        db.collection("sources").whereField("uid", isEqualTo: uid)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        let data = document.data()
                        completionHandler (data["sourceID"] as! String, data["sourceIcon"] as! String, data["sourceName"] as! String, data["uid"] as! String)
                        self.tableViewOutlet.reloadData()
                    }
                }
            }
    }
    
    func deleteUserCategory(selectedEntryID: Any) {
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
    
    func deleteUserSource(selectedEntryID: Any) {
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
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    func getCountOfMainCategory(categoryName:String) -> Int{
        var count = 0
        for category in firebaseCategories {
            if category.categoryMainName == categoryName {
                count = count + 1
            }
        }
        return count

    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        switch selectedButton {
        case "CategoryButton":
            return categories.count
        case "SourceButton":
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch selectedButton {
        case "CategoryButton":
            return categories[section].count
        case "SourceButton":
            return sources.count
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch selectedButton {
        case "CategoryButton":
            
            return getMainCategories(categories: firebaseCategories)[section]
        case "SourceButton":
            return "Sources"
        default:
            return "ERROR"
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CategoryCellVC
        
        if selectedButton == "CategoryButton" {
            
            print("tHIS IS\(categories[indexPath.section][indexPath.row])")
            cell.setCategories(category: categories[indexPath.section][indexPath.row])
        }
        else if selectedButton == "SourceButton" {
            
            cell.setSources(source: sources[indexPath.row])
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NSLog("You selected cell number: \(indexPath.row)!")
        if selectedButton == "CategoryButton" {
            let title = categories[indexPath.section][indexPath.row].categorySubName
            USERSELECTEDCATEGORY = categories[indexPath.section][indexPath.row]
            selectCategoryButtonOutlet.setAttributedTitle((NSAttributedString(string: title)), for: .normal)
        }
        else if selectedButton == "SourceButton" {
            let title = sources[indexPath.row].categorySubName
            selectSourceButtonOutlet.setAttributedTitle((NSAttributedString(string: title)), for: .normal)
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .default, title: "Delete") { (action, indexPath) in
            switch self.selectedButton {
            case "CategoryButton":
                let entry = self.categories[indexPath.section][indexPath.row]
                self.entryID = entry.categoryID
                
                print("BUTTON\(self.selectedButton)")
                self.deleteUserCategory(selectedEntryID: entry.categoryID)
                
                var changedEntries = self.categories
                changedEntries[indexPath.section].remove(at: indexPath.row)
                self.categories = changedEntries
                tableView.reloadData()
            case "SourceButton":
                let entry = self.sources[indexPath.row]
                self.entryID = entry.categoryID
                
                self.deleteUserSource(selectedEntryID: entry.categoryID)
                
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
            switch self.selectedButton {
            case "CategoryButton":
                let entry = self.categories[indexPath.section][indexPath.row]
                self.editName = entry.categorySubName
                self.entryID = entry.categoryID
                print("Type is \(self.typeType)")
                
                self.typeType = "Category"
                
            case "SourceButton":
                let entry = self.sources[indexPath.row]
                self.editName = entry.categorySubName
                self.entryID = entry.categoryID
                self.typeType = "Source"
                print("Type is \(self.typeType)")
                
                
            default:
                print("ERRROR")
                print("Type is \(self.typeType)")
                
            }
            DispatchQueue.main.async() {
                self.performSegue(withIdentifier: "goToCategory", sender: self)
            }
        }
        edit.backgroundColor = UIColor(red: 0.13, green: 0.17, blue: 0.40, alpha: 1.00)
        
        //edit put back
        return [delete, edit]
    }
    
    func editEntry(completion: ()) {
        
        var willBeNewAmount = amountTextFieldOutlet.text
        let entries = self.db.collection("entries")
        entries.whereField("id", isEqualTo: entryID!).getDocuments(completion: { querySnapshot, error in
            if let err = error {
                print(err.localizedDescription)
                return
            }
            guard let docs = querySnapshot?.documents else { return }
            
            
            for doc in docs {
                let docData = doc.data()
                print("Doc Data\(docData)")
                print(docData)
                let ref = doc.reference
                if self.TYPE == "Expense" {
                    willBeNewAmount = "-" + willBeNewAmount!
                }

                ref.updateData(["amount": willBeNewAmount])
                ref.updateData(["category": String(self.selectCategoryButtonOutlet.currentAttributedTitle!.string)])
                ref.updateData(["source": String(self.selectSourceButtonOutlet.currentAttributedTitle!.string)])
                if self.USERSELECTEDCATEGORY != nil {
                    ref.updateData(["mainCategory": self.USERSELECTEDCATEGORY.categoryMainName])
                }else{
                    ref.updateData(["mainCategory": self.SELECTEDCAT])
                }
                
                completion
            }
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "unwindFromAllEditingVC", sender: self)
            }
            
        })
    }
    
    func addUserEntry() {
        let user = Auth.auth().currentUser
        var type = ""
        var amount = amountTextFieldOutlet.text!
        let date = Date()

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        switch userAction {
        case "IncomeButton":
            type = "Income"
        case "ExpenseButton":
            type = "Expense"
        default:
            print("Error")
        }
        if type == "Expense" {
            amount = "-"+amountTextFieldOutlet.text!
        }
        let userEntry = Entry(type: type, category: String(self.selectCategoryButtonOutlet.currentAttributedTitle!.string), mainCategory: USERSELECTEDCATEGORY.categoryMainName, source: String(self.selectSourceButtonOutlet.currentAttributedTitle!.string), amount: amount, day: String(Calendar.current.component(.day, from: date)), dayInWeek: String(dateFormatter.string(from: date)), year: String(Calendar.current.component(.year, from: date)), month: String(Calendar.current.component(.month, from: date)), id: String(Int.random(in: 10000000000 ..< 100000000000000000)), uid: user!.uid, recurring: "false",weekOfMonth: String(Calendar.current.component(.weekOfMonth, from: date)))
        let dictionary = userEntry.getDictionary()
        //        if noteField.text!.isEmpty {
        //            displayAlert(message: "Name field can't be empty.", title: "Warning")
        //        }
        if amountTextFieldOutlet.text!.isEmpty {
            displayAlert(message: "Amount field can't be empty.", title: "Warning")
        }
        //        else if categoryButtonOutlet.title(for: .normal) == "SELECT CATEGORY"{
        //            displayAlert(message: "Please select a category from the predefined list", title: "Warning")
        //        }
        else {
            do {
                try db.collection("entries").addDocument(data: dictionary)
            } catch let error {
                print("Error writing entry to Firestore: \(error)")
            }
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "unwindFromAllEditingVC", sender: self)
            }
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToCategory" {
            let vc = segue.destination as? AddCategoryViewController
            
            switch typeType {
            case "Category":
                vc?.type = typeType
                vc?.name = editName
                vc?.ID = self.entryID as! String
                print("Type is \(self.typeType)")
                
            case "Source":
                vc?.type = typeType
                vc?.name = editName
                vc?.ID = self.entryID as! String
                print("Type is \(self.typeType)")
                
            default:
                print("User wants to add a category")
                vc?.type = typeType
                vc?.wantToAddCategory = true
                print("Type is \(self.typeType)")
                
            }
            
        }
    }
    func displayAlert(message: String, title: String) {
        let dialogMessage = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
        })
        dialogMessage.addAction(ok)
        self.present(dialogMessage, animated: true, completion: nil)
        
    }
}
