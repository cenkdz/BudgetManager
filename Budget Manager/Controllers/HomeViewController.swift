//
//  HomeViewController.swift
//  Budget Manager
//
//  Created by Cenk Donmez on 5.03.2021.
//  Copyright © 2021 CTIS. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITabBarDelegate {
    @IBOutlet weak var customHeaderView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dailyButton: UIButton!
    @IBOutlet weak var weeklyButton: UIButton!
    @IBOutlet weak var monthlyButton: UIButton!
    @IBOutlet weak var totalButton: UIButton!
    @IBOutlet weak var addButtonOutlet: UIButton!
    @IBOutlet var addView: UIView!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    @IBOutlet weak var incomeOutlet: UILabel!
    @IBOutlet weak var expenseOutlet: UILabel!
    @IBOutlet weak var totalOutlet: UILabel!
    @IBOutlet weak var tabBarOutlet: UITabBar!

    var editCategory = ""
    var editAmount = ""
    let db = Firestore.firestore()
    var selectedEntryID: Any!
    var editSource = ""
    var effect: UIVisualEffect!
    var users: [User] = []
    var entries: [[Entry]] = [[]]
    var selectedCategories: [Category] = []
    var editName = ""
    var sections: [Int] = []
    var count = 0
    var userAction = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarOutlet.selectedItem = tabBarOutlet.items?[0]
        setData()
        getAll(completion: ())
        setFinancialOutlets()
        effect = visualEffectView.effect
        visualEffectView.effect = nil
        addView.layer.cornerRadius = 5
        addView.removeFromSuperview()
        tableView.delegate = self
        tabBarOutlet.delegate = self
        tableView.dataSource = self
        self.hideKeyboardWhenTappedAround()
    }
    
    func goToSettingsVC() {
        let homeViewController = storyboard?.instantiateViewController(identifier: "SettingsVC") as? SettingsVC
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
    func goToRecurringEntryVC() {
        let homeViewController = storyboard?.instantiateViewController(identifier: "RecurringEntryVC") as? RecurringEntryVC
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
    //    func goToStatisticsVC() {
    //        let homeViewController = storyboard?.instantiateViewController(identifier: "HomeViewController") as? HomeViewController
    //        view.window?.rootViewController = homeViewController
    //        view.window?.makeKeyAndVisible()
    //    }
    func goToLandingVC() {
        let homeViewController = storyboard?.instantiateViewController(identifier: "LandingVC") as? LandingVC
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
    
    func setData() {
        let sortedArray = entries.sorted(by: { $0[0].day > $1[0].day })
        entries.removeAll()
        entries.append(contentsOf: sortedArray)
    }
    @IBAction func unwindFromAllEditingVC(_ sender: UIStoryboardSegue) {
        DispatchQueue.main.async {
            self.getAll(completion: ())
        }

        self.tableView.reloadData()
        animateOut()
        print("Came from AllEditingVC")
    }

    func calculateTotal() -> String {
        var total = 0

        for array in entries {
            for value in array {
                total = total + Int(value.amount)!
            }
            print(" ")
        }
        return String(total)
    }

    func calculateExpenses() -> String {
        var expenses = 0

        for array in entries {
            for value in array {
                if value.type == "Expense" {
                    expenses = expenses + Int(value.amount)!
                }
            }
        }
        return String(expenses)
    }

    func calculateIncome() -> String {
        var income = 0

        for array in entries {
            for value in array {
                if value.type == "Income" {
                    income = income + Int(value.amount)!
                }
            }
        }
        return String(income)
    }
    //
    //    func getTodayEntries() -> [Entry] {
    //
    //        let date = Date()
    //
    //        let dateFormatter = DateFormatter()
    //
    //        func getCurrentYear() -> String{
    //
    //            return String(Calendar.current.component(.year, from: date))
    //        }
    //
    //        func getCurrentMonth()-> String{
    //            return String(Calendar.current.component(.month, from: date))
    //        }
    //
    //        func getCurrentDay()-> String{
    //            return String(Calendar.current.component(.day, from: date))
    //        }
    //
    //        func getCurrentDayInWeek()-> String{
    //            dateFormatter.dateFormat = "EEEE"
    //
    //            return String(dateFormatter.string(from: date))
    //
    //        }
    //
    //        let todayDay = getCurrentDay()
    //        let todayMonth = getCurrentMonth()
    //        let todayYear = getCurrentYear()
    //        let todayDayInWeek = getCurrentDayInWeek()
    //
    //        let todayEntries = entries.filter({
    //            $0.day == Int(todayDay)! && $0.month == todayMonth && $0.year == todayYear
    //        })
    //        return todayEntries
    //    }

    func setFinancialOutlets() {
        let total = calculateTotal()
        let income = calculateIncome()
        let expenses = calculateExpenses()
        if Int(total)! < 0 {
            totalOutlet.textColor = UIColor(red: 0.98, green: 0.39, blue: 0.00, alpha: 1.00)
        }
        else if Int(total)! >= 0 {
            totalOutlet.textColor = UIColor(red: 0.24, green: 0.48, blue: 0.94, alpha: 1.00)
        }
        totalOutlet.text = total
        incomeOutlet.text = income
        expenseOutlet.text = expenses
    }

    @IBAction func recurringEntryPressed(_ sender: UIButton) {
        goToRecurringEntryVC()
    }

    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if(item.tag == 0) {
            print("Home Selected")
        } else if(item.tag == 1) {
            print("Statistics Selected")
        } else if(item.tag == 2) {
            print("Settings Selected")
            goToSettingsVC()
        }
    }

    @IBAction func incomePressed(_ sender: UIButton) {
        userAction = "IncomeButton"
        self.performSegue(withIdentifier: "goToAllEditingVC", sender: self)
    }

    @IBAction func expensePressed(_ sender: UIButton) {
        userAction = "ExpenseButton"
        self.performSegue(withIdentifier: "goToAllEditingVC", sender: self)

    }
    func animateIn() {
        self.view.addSubview(addView)
        addView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        addView.alpha = 0
        UIView.animate(withDuration: 0.4) {
            self.visualEffectView.effect = self.effect
            self.addView.alpha = 1
            self.addView.transform = CGAffineTransform.identity
        }
    }

    func animateOut() {
        UIView.animate(withDuration: 0.1) {
            self.addView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.addView.alpha = 0
            self.visualEffectView.effect = nil
        }
        self.addView.removeFromSuperview()
        self.addButtonOutlet.setAttributedTitle(NSAttributedString(string: "+"), for: .normal)
        self.view.sendSubviewToBack(self.visualEffectView)
    }

    @IBAction func addButtonPressed(_ sender: UIButton) {

        if(addButtonOutlet.attributedTitle(for: .normal) == NSAttributedString(string: "x")) {
            DispatchQueue.main.async {
                self.animateOut()
            }
        }
        self.view.bringSubviewToFront(visualEffectView)
        addButtonOutlet.setAttributedTitle(NSAttributedString(string: "x"), for: .normal)
        addButtonOutlet.setTitleColor(.white, for: .normal)
        self.view.bringSubviewToFront(addButtonOutlet)
        animateIn()

    }

    @IBAction func dailyPressed(_ sender: UIButton) {
        dailyButton.backgroundColor = UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1.00)
        weeklyButton.backgroundColor = UIColor(red: 0.40, green: 0.40, blue: 0.40, alpha: 1.00)
        monthlyButton.backgroundColor = UIColor(red: 0.40, green: 0.40, blue: 0.40, alpha: 1.00)
        totalButton.backgroundColor = UIColor(red: 0.40, green: 0.40, blue: 0.40, alpha: 1.00)

    }

    @IBAction func weeklyPressed(_ sender: UIButton) {
        weeklyButton.backgroundColor = UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1.00)
        dailyButton.backgroundColor = UIColor(red: 0.40, green: 0.40, blue: 0.40, alpha: 1.00)
        monthlyButton.backgroundColor = UIColor(red: 0.40, green: 0.40, blue: 0.40, alpha: 1.00)
        totalButton.backgroundColor = UIColor(red: 0.40, green: 0.40, blue: 0.40, alpha: 1.00)
    }

    @IBAction func monthlyPressed(_ sender: UIButton) {
        monthlyButton.backgroundColor = UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1.00)
        dailyButton.backgroundColor = UIColor(red: 0.40, green: 0.40, blue: 0.40, alpha: 1.00)
        weeklyButton.backgroundColor = UIColor(red: 0.40, green: 0.40, blue: 0.40, alpha: 1.00)
        totalButton.backgroundColor = UIColor(red: 0.40, green: 0.40, blue: 0.40, alpha: 1.00)
    }

    @IBAction func totalPressed(_ sender: UIButton) {
        totalButton.backgroundColor = UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1.00)
        dailyButton.backgroundColor = UIColor(red: 0.40, green: 0.40, blue: 0.40, alpha: 1.00)
        monthlyButton.backgroundColor = UIColor(red: 0.40, green: 0.40, blue: 0.40, alpha: 1.00)
        weeklyButton.backgroundColor = UIColor(red: 0.40, green: 0.40, blue: 0.40, alpha: 1.00)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return entries.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HomeTableViewCell
        cell.categorySourceOutlet.text = "Section \(indexPath.section) Row \(indexPath.row)"
        let entry = entries[indexPath.section][indexPath.row]
        cell.setEntry(entry: entry)
        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! HeaderTableViewCell
        let entry = entries[section]
        if entry.count != 0 {
            cell.setEntry(entries: entry)
            cell.setTotal()
            return cell
        }
        return nil
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 96
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (contextualAction, view, boolValue) in
            let entry = self.entries[indexPath.section][indexPath.row]
            //deleteUserCategory(selectedEntryID: entry.categoryID)
            var changedEntries = self.entries
            changedEntries[indexPath.section].remove(at: indexPath.row)
            if changedEntries[indexPath.section].count == 0 {

                changedEntries.remove(at: indexPath.section)

                self.deleteUserEntry(selectedEntryID: entry.id)
            }
            self.entries = changedEntries
            tableView.reloadData()
        }
        delete.backgroundColor = UIColor.red
        let edit = UIContextualAction(style: .destructive, title: "Edit") { (contextualAction, view, boolValue) in
            let entry = self.entries[indexPath.section][indexPath.row]
            self.editAmount = entry.amount
            self.editCategory = entry.category
            self.selectedEntryID = entry.id
            self.editSource = entry.source
            self.userAction = "EditEntry"
            self.performSegue(withIdentifier: "goToAllEditingVC", sender: self)
        }
        edit.backgroundColor = UIColor(red: 0.13, green: 0.17, blue: 0.40, alpha: 1.00)


        let swipeActions = UISwipeActionsConfiguration(actions: [delete, edit])

        return swipeActions
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "goToAllEditingVC" {
            let vc = segue.destination as? AllEditingViewController
            print("DATA ON PREPARE\(editAmount),\(editCategory)")
            vc?.amount = editAmount
            vc?.category = editCategory
            vc?.entryID = selectedEntryID
            vc?.source = editSource
            vc?.userAction = userAction
        }
    }

    func getUserDetails(completionHandler: @escaping(String, String) -> (), uid: String) {
        db.collection("users").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                //get name of the user
                self.db.collection("users").whereField("uid", isEqualTo: uid)
                    .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            let data = document.data()
                            completionHandler ((data["firstname"] as? String)!, (data["uid"]as? String)!)
                        }
                    }
                }
            }
        }
    }

    func getUserEntries(completionHandler: @escaping(String, String, String, String, String, String, String, String, String, String) -> (), uid: String) {
        entries = []
        db.collection("entries").whereField("uid", isEqualTo: uid)
            .getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                print(uid)
                for document in querySnapshot!.documents {
                    let data = document.data()
                    completionHandler (data["type"] as! String, data["category"] as! String, data["source"]as! String, data["amount"] as! String, data["day"] as! String, data["dayInWeek"] as! String, data["year"]as! String, data["month"]as! String, data["id"]as! String, data["uid"]as! String)
                    self.tableView.reloadData()

                }
            }
        }
    }

    func deleteUserEntry(selectedEntryID: Any) {
        db.collection("entries").whereField("id", isEqualTo: selectedEntryID).getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    document.reference.delete()
                }
            }
        }
    }

    func getAll(completion: ()) {
        if Auth.auth().currentUser != nil {
            let user = Auth.auth().currentUser
            getUserDetails(completionHandler: { (firstname, uid) in
                let user = User(firstname: firstname, uid: uid)
                self.users.append(user)
            }, uid: user!.uid)
            self.getUserEntries(completionHandler: { (type, category, source, amount, day, dayInWeek, year, month, id, uid) in
                let entry = Entry(type: type, category: category, source: source, amount: amount, day: String(day), dayInWeek: dayInWeek, year: year, month: month, id: id, uid: uid)
                self.entries.append([entry])
            }, uid: user!.uid)
            completion
            tableView.reloadData()
        } else {
            goToLandingVC()
        }
    }
}




