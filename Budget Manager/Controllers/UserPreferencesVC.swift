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

class UserPreferencesVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var budgetGoalOutlet: UITextField!
    @IBOutlet weak var salaryOutlet: UITextField!
    @IBOutlet weak var salaryAsIncomeOutlet: UISwitch!
    @IBOutlet weak var tableView: UITableView!
    let helperMethods = HelperMethods()
    let firebaseMethods = FirebaseMethods()
    var lastSelectedIndexPath = NSIndexPath(row: -1, section: 0)
    var categories: [Category] = [Category(categoryID: "1", categoryMainName: "Home",categorySubName: "", categoryIcon: "", categoryType: "Expense", uid: "6"), Category(categoryID: "2", categoryMainName: "Vehicle",categorySubName: "", categoryIcon: "", categoryType: "Expense", uid: "6"), Category(categoryID: "3", categoryMainName: "Health",categorySubName:"", categoryIcon: "", categoryType: "Expense", uid: "6"), Category(categoryID: "4", categoryMainName: "Cosmetics",categorySubName: "", categoryIcon: "", categoryType: "Expense", uid: "6"),Category(categoryID: "5", categoryMainName: "Clothing",categorySubName: "", categoryIcon: "", categoryType: "Expense", uid: "6"),Category(categoryID: "6", categoryMainName: "Accessories",categorySubName: "", categoryIcon: "", categoryType: "Expense", uid: "6"),Category(categoryID: "7", categoryMainName: "Market",categorySubName: "", categoryIcon: "", categoryType: "Expense", uid: "6"),Category(categoryID: "8", categoryMainName: "Taxes",categorySubName: "", categoryIcon: "", categoryType: "Expense", uid: "6"),Category(categoryID: "9", categoryMainName: "Restaurants",categorySubName: "", categoryIcon: "", categoryType: "Expense", uid: "6"),Category(categoryID: "10", categoryMainName: "Entertaintment",categorySubName: "", categoryIcon: "", categoryType: "Expense", uid: "6"),Category(categoryID: "11", categoryMainName: "Bills",categorySubName: "", categoryIcon: "", categoryType: "Expense", uid: "6"),Category(categoryID: "12", categoryMainName: "Electronics",categorySubName: "", categoryIcon: "", categoryType: "Expense", uid: "6"),Category(categoryID: "13", categoryMainName: "Insurance",categorySubName: "", categoryIcon: "", categoryType: "Expense", uid: "6")]

    var selectedCategoryNames = [String]()
    var budgetGoal = ""
    var salary = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        setUISettings()
    }
    
    @IBAction func finishPressed(_ sender: UIButton) {
         budgetGoal = budgetGoalOutlet.text!.trimmingCharacters(in: .whitespaces)
         salary = salaryOutlet.text!.trimmingCharacters(in: .whitespaces)
        if budgetGoal.isEmpty {
            helperMethods.displayAlert(message: "Please set a budget goal.", title: "Budget Goal",receiverController: self)
        } else if budgetGoal.containsOnlyDigits == false {
            helperMethods.displayAlert(message: "Please enter only numbers for your budget goal.", title: "Salary",receiverController: self)
        }else if Int(budgetGoal)!<0 {
            helperMethods.displayAlert(message: "Please use positive numbers.", title: "Salary",receiverController: self)
        } else if salary.containsOnlyDigits == false {
            helperMethods.displayAlert(message: "Please enter only numbers for your salary.", title: "Salary",receiverController: self)
        } else if salary.isEmpty {
            helperMethods.displayAlert(message: "Please enter your salary.", title: "Salary",receiverController: self)
        } else if Int(salary)!<0 {
            helperMethods.displayAlert(message: "Please use positive numbers.", title: "Salary",receiverController: self)
        }else if selectedCategoryNames.isEmpty {
            helperMethods.displayAlert(message: "Please select at least one category from the list.", title: "Categories",receiverController: self)
        } else {
            if (salaryAsIncomeOutlet.isOn == true && Int(salary) != 0) {
                DispatchQueue.main.async {
                    self.firebaseMethods.addSalaryAsIncome(completion: (), salary: self.salary)
                }
            }
            DispatchQueue.main.async {
                self.firebaseMethods.addSelectedMainCategory(completion: (), selectedCategoryNames: self.selectedCategoryNames)
            }
            DispatchQueue.main.async {
                self.firebaseMethods.addPreferences(completion: (), budgetGoal: self.budgetGoal, salary: self.salary)
            }
            DispatchQueue.main.async {
                self.helperMethods.goToHomeVC(senderController: self)
            }
        }
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
    
    func setTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.allowsMultipleSelection = true
        self.tableView.allowsMultipleSelectionDuringEditing = true
    }
    
    func  setUISettings(){
        self.hideKeyboardWhenTappedAround()
    }
}
extension String {
    var containsOnlyDigits: Bool {
        let notDigits = NSCharacterSet.decimalDigits.inverted
        return rangeOfCharacter(from: notDigits, options: String.CompareOptions.literal, range: nil) == nil
    }
}
