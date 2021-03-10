//
//  UserPreferencesVC.swift
//  Budget Manager
//
//  Created by Cenk Donmez on 10.03.2021.
//  Copyright © 2021 CTIS. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class UserPreferencesVC: UIViewController,UITableViewDataSource,UITableViewDelegate  {
    
    
    
    @IBOutlet weak var budgetGoalOutlet: UITextField!
    @IBOutlet weak var salaryOutlet: UITextField!
    @IBOutlet weak var salaryAsIncomeOutlet: UISwitch!
    @IBOutlet weak var tableView: UITableView!
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser
    var lastSelectedIndexPath = NSIndexPath(row: -1, section: 0)
    var categories: [Category] = [Category(categoryID: "1", categoryName: "Home", categoryIcon: "", uid: "6"),Category(categoryID: "2", categoryName: "Car", categoryIcon: "", uid: "6"),Category(categoryID: "3", categoryName: "Health", categoryIcon: "", uid: "6"),Category(categoryID: "4", categoryName: "Self-Care", categoryIcon: "", uid: "6")]
    var selectedCategoryNames = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.hideKeyboardWhenTappedAround()
        self.tableView.allowsMultipleSelection = true
        self.tableView.allowsMultipleSelectionDuringEditing = true
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func finishPressed(_ sender: UIButton) {
        if budgetGoalOutlet.text!.isEmpty {
            displayAlert(message: "Please set a budget goal.", title: "Budget Goal")
        }else if salaryOutlet.text!.isEmpty {
            displayAlert(message: "Please enter your salary.", title: "Salary")
        }else if selectedCategoryNames.isEmpty {
            displayAlert(message: "Please select at least one category from the list.", title: "Categories")
        }else{
            if (salaryAsIncomeOutlet.isOn == true){
                DispatchQueue.main.async {
                    self.addSalaryAsIncome(completion: ())
                }
            }
                DispatchQueue.main.async {
                    self.addCategory(completion: ())
                }
                DispatchQueue.main.async {
                    self.addPreferences(completion: ())
                }
                DispatchQueue.main.async {
                    self.goToHomeVC()
                }
            

            //print("Success!!")
        }
    }
    
    func goToHomeVC() {
        let homeViewController = storyboard?.instantiateViewController(identifier: "HomeViewController") as? HomeViewController
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell",
                                                 for: indexPath) as? CheckableTableViewCell
        cell?.setCell(category: categories[indexPath.row])
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell",
                                                 for: indexPath) as? CheckableTableViewCell
        cell?.setCell(category: categories[indexPath.row])
        
        selectedCategoryNames.append(cell!.categoryNameOutlet.text!)
        print("Entry has been added Array is Now \(selectedCategoryNames)")
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell",
                                                 for: indexPath) as? CheckableTableViewCell
        cell?.setCell(category: categories[indexPath.row])
        
        selectedCategoryNames.removeAll { value in
            return value == cell!.categoryNameOutlet.text!
        }
        print("Entry has been removed Array is Now \(selectedCategoryNames)")
        
    }
    
    
    func displayAlert(message: String,title: String) {
        let dialogMessage = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
        })
        dialogMessage.addAction(ok)
        self.present(dialogMessage, animated: true, completion: nil)
        
    }
    
    func addCategory(completion: ()){
        for category in selectedCategoryNames {
            let category = Category(categoryID: String(Int.random(in: 10000000000 ..< 100000000000000000)), categoryName: category, categoryIcon: "", uid: user!.uid)
            let dictionary = category.getDictionary()
            do {
                try db.collection("categories").addDocument(data: dictionary)
                completion
            } catch let error {
                print("Error writing entry to Firestore: \(error)")
            }
        }
    }
    
    func addPreferences(completion: ()){
        let entries = self.db.collection("users")
        entries.whereField("uid", isEqualTo: user!.uid).getDocuments(completion: { querySnapshot, error in
            if let err = error {
                print(err.localizedDescription)
                return
            }
            guard let docs = querySnapshot?.documents else { return }
            for doc in docs {
                let docData = doc.data()
                let ref = doc.reference
                ref.updateData(["budgetGoal": self.budgetGoalOutlet.text])
                ref.updateData(["salary": self.salaryOutlet.text])
                completion
            }
        })
    }
    
    func addSalaryAsIncome(completion: ()){
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let entry = Entry(type: "Income", category: "Salary", source: "Salary", amount: self.salaryOutlet.text!, day: String(Calendar.current.component(.day, from: date)), dayInWeek: String(dateFormatter.string(from: date)), year: String(Calendar.current.component(.year, from: date)), month: String(Calendar.current.component(.month, from: date)), id: String(Int.random(in: 10000000000 ..< 100000000000000000)) , uid: user!.uid)
        let dictionary = entry.getDictionary()
            do {
                try db.collection("entries").addDocument(data: dictionary)
                completion
                
            } catch let error {
                print("Error writing entry to Firestore: \(error)")
            }
    }
    
    
    
}
