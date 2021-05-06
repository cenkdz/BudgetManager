//
//  AddCategoryViewController.swift
//  Budget Manager
//
//  Created by Cenk Donmez on 8.03.2021.
//  Copyright © 2021 CTIS. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class AddCategoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var nameOutlet: UILabel!
    @IBOutlet weak var nameTextOutlet: UITextField!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mainCategorySwitch: UISwitch!
    @IBOutlet weak var mainCategoryLabel: UITextField!
    @IBOutlet weak var subCategoryLabel: UITextField!
    @IBOutlet weak var mCL: UILabel!
    @IBOutlet weak var sC: UILabel!
    @IBOutlet weak var switchOUTLET: UISwitch!
    @IBOutlet weak var customQuestionLabel: UILabel!
    let user = Auth.auth().currentUser

    let db = Firestore.firestore()
    var mainUserExpenseCategories: [String] = []
    var firebaseCategories = [Category]()
    var selectedI = ""
    var selectedMain = ""
    var type = ""
    var name = ""
    var wantToAddCategory = false
    var ID = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        print("T123ype is \(selectedI)")
        print("T123ype is \(selectedMain)")
        print("T123ype is \(type)")
        self.hideKeyboardWhenTappedAround()
        if wantToAddCategory != true {
            segmentedControl.isUserInteractionEnabled = false
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        switchOUTLET.isOn = false
        sC.isHidden = true
        mCL.isHidden = true
        subCategoryLabel.isHidden = true
        mainCategoryLabel.isHidden = true
        
        self.getUserCategories(completionHandler: { [self] (categoryID, categoryIcon, categoryMainName,categorySubName,categoryType, uid) in
            let category = Category(categoryID: categoryID, categoryMainName: categoryMainName,categorySubName:categorySubName, categoryIcon: categoryIcon, categoryType: categoryType, uid: uid)
            self.firebaseCategories.append(category)
            if wantToAddCategory != true {
                segmentedControl.isUserInteractionEnabled = false
            }
            
            if type == "Add"{
                type = "Category"
            }
            
            switch type {
            case "Category":
                segmentedControl.selectedSegmentIndex = 0
                getMainCategories(categories: firebaseCategories)

            case "Source":
                segmentedControl.selectedSegmentIndex = 1
                customQuestionLabel.isHidden = true
                switchOUTLET.isHidden = true
                tableView.isHidden = true
            
            default:
                segmentedControl.selectedSegmentIndex = 0
            }
            nameTextOutlet.text! = name
            self.tableView.reloadData()
        }, uid: self.user!.uid)
        
        
        
    }
    @IBAction func onChange(_ sender: UISegmentedControl) {
        type = segmentedControl.titleForSegment(at: segmentedControl.selectedSegmentIndex)!
        
        switch type {
        case "Category":
            tableView.isHidden = false
            customQuestionLabel.isHidden = false
            switchOUTLET.isHidden = false
        case "Source":
            tableView.isHidden = true
            customQuestionLabel.isHidden = true
            switchOUTLET.isHidden = true

        default:
            print("Error")
        }
        
        print(type)
    }
    
    @IBAction func switchChange(_ sender: UISwitch) {
        
        switch sender.isOn {
        case true:
            sC.isHidden = false
            mCL.isHidden = false
            subCategoryLabel.isHidden = false
            mainCategoryLabel.isHidden = false
            tableView.isHidden = true
            nameOutlet.isHidden = true
            nameTextOutlet.isHidden = true
            segmentedControl.isHidden = true
        case false:
            sC.isHidden = true
            mCL.isHidden = true
            subCategoryLabel.isHidden = true
            mainCategoryLabel.isHidden = true
            tableView.isHidden = false
            nameOutlet.isHidden = false
            nameTextOutlet.isHidden = false
            segmentedControl.isHidden = false
        default:
            print("Error")
        }
    }
    
    @IBAction func addPressed(_ sender: UIButton) {
        print("TYPE OIS")
        print(type)
        if switchOUTLET.isOn {
            var mainCat = mainCategoryLabel.text!
            var subCat = subCategoryLabel.text!
            
            let user = Auth.auth().currentUser
            let category = Category(categoryID: String(Int.random(in: 10000000000 ..< 100000000000000000)), categoryMainName: mainCat ,categorySubName:subCat, categoryIcon: "", categoryType: "Expense", uid: user!.uid)
            let dictionary = category.getDictionary()
            if mainCategoryLabel.text!.isEmpty {
                displayAlert(message: "Main category field can't be empty.", title: "Warning")
            }else if subCategoryLabel.text!.isEmpty {
                displayAlert(message: "Sub category field can't be empty.", title: "Warning")
            }
            else{
                do {
                    try db.collection("categories").addDocument(data: dictionary)
                    
                } catch let error {
                    print("Error writing entry to Firestore: \(error)")
                }
                self.performSegue(withIdentifier: "unwindToAllEditingVC", sender: self)
            }
        }else{
        if type == "Category" && wantToAddCategory == false{
            DispatchQueue.main.async {
                self.editCategory(completion: ())
            }
        } else if type == "Source" && wantToAddCategory == false{
            
            DispatchQueue.main.async {
                self.editSource(completion: ())
            }
        }
        else if wantToAddCategory == true {
            
            switch type {
            case "Category":
                DispatchQueue.main.async {
                self.addCategory()
                }
            case "Source":
                DispatchQueue.main.async {
                self.addSource()
                }
            default:
                print("Error adding categories/sources")
            }
            
        }
    }
    }
    
    func displayAlert(message: String,title: String) {
        let dialogMessage = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
        })
        dialogMessage.addAction(ok)
        self.present(dialogMessage, animated: true, completion: nil)
        
    }
    
    
    func editCategory(completion: ()){
        let entries = self.db.collection("categories")
        entries.whereField("categoryID", isEqualTo: ID).getDocuments(completion: { querySnapshot, error in
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
                ref.updateData(["categoryMainName": self.selectedMain])
                ref.updateData(["categorySubName": self.nameTextOutlet.text!])
                completion
            }
            
            self.performSegue(withIdentifier: "unwindToAllEditingVC", sender: self)
            
            
            
        })
    }
    func editSource(completion: ()){
        print(ID)
        
        let entries = self.db.collection("categories")
        entries.whereField("categoryID", isEqualTo: ID).getDocuments(completion: { querySnapshot, error in
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
                ref.updateData(["categorySubName": self.nameTextOutlet.text!])
                completion
            }
            self.performSegue(withIdentifier: "unwindToAllEditingVC", sender: self)
            
            
        })
    }
    
    func addCategory(){
        let user = Auth.auth().currentUser
        let category = Category(categoryID: String(Int.random(in: 10000000000 ..< 100000000000000000)), categoryMainName: selectedMain ,categorySubName:nameTextOutlet.text!, categoryIcon: "", categoryType: "Expense", uid: user!.uid)
        let dictionary = category.getDictionary()
        if nameTextOutlet.text!.isEmpty {
            displayAlert(message: "Name field can't be empty.", title: "Warning")
        }
        else{
            do {
                try db.collection("categories").addDocument(data: dictionary)
                
            } catch let error {
                print("Error writing entry to Firestore: \(error)")
            }
            self.performSegue(withIdentifier: "unwindToAllEditingVC", sender: self)
        }
    }
    
    func addSource(){
        let user = Auth.auth().currentUser
        let category = Category(categoryID: String(Int.random(in: 10000000000 ..< 100000000000000000)), categoryMainName: "Source" ,categorySubName:nameTextOutlet.text!, categoryIcon: "", categoryType: "Income", uid: user!.uid)
        let dictionary = category.getDictionary()
        if nameTextOutlet.text!.isEmpty {
            displayAlert(message: "Name field can't be empty.", title: "Warning")
        }
        else{
            do {
                try db.collection("categories").addDocument(data: dictionary)
                
            } catch let error {
                print("Error writing entry to Firestore: \(error)")
            }
            self.performSegue(withIdentifier: "unwindToAllEditingVC", sender: self)
        }
        
        
    }
    
    func setTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.setContentOffset(tableView.contentOffset, animated: false)

    }
    
    func getMainCategories(categories: [Category]){
        var mainCategories: [String] = []
        
        for category in categories {
            let mainCategory = category.categoryMainName
            
            if !mainCategories.contains(mainCategory){
                if category.categoryType == "Expense" {
                    mainCategories.append(mainCategory)
                }
            }
            
            
        }
        
//        let sortedDays = days.sorted {
//            Int($0)! > Int($1)!
//        }
        
        mainUserExpenseCategories = mainCategories
        }
    
    func getUserCategories(completionHandler: @escaping(String,String, String, String, String,String) -> (), uid: String) {
        db.collection("categories").whereField("uid", isEqualTo: uid)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        let data = document.data()
                        completionHandler (data["categoryID"] as! String, data["categoryIcon"] as! String, data["categoryMainName"] as! String,data["categorySubName"] as! String,data["categoryType"] as! String, data["uid"] as! String)
                        self.tableView.reloadData()
                    }
                }
            }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        mainUserExpenseCategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "addCell", for: indexPath) as! AddCategoryCell
        
        cell.setEntry(name: mainUserExpenseCategories[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! AddCategoryCell
        print(cell.getLabel())
        selectedMain = cell.getLabel()
    }
    
}
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
