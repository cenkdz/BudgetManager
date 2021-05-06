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
    @IBOutlet weak var addButtonOutlet: UIButton!
    @IBOutlet var addView: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    @IBOutlet weak var incomeOutlet: UILabel!
    @IBOutlet weak var expenseOutlet: UILabel!
    @IBOutlet weak var totalOutlet: UILabel!
    @IBOutlet weak var tabBarOutlet: UITabBar!
    
    @IBOutlet weak var userDatePicker: UIDatePicker!
    @IBOutlet weak var userDatePlus: UIButton!
    @IBOutlet weak var userDateMinus: UIButton!
    var editCategory = ""
    var selectedMode = "Today"
    var SELECTEDCAT = ""
    
    var editAmount = ""
    let user = Auth.auth().currentUser
    let db = Firestore.firestore()
    var selectedEntryID: Any!
    var editSource = ""
    var effect: UIVisualEffect!
    var users: [User] = []
    var entries: [[Entry]] = []
    var selectedCategories: [Category] = []
    var editName = ""
    var sections: [Int] = []
    var count = 0
    var TYPE = ""
    var userAction = ""
    let helperMethods = HelperMethods()
    let firebaseMethods = FirebaseMethods()
    let calculator = Calculator()
    var income = ""
    var expense = ""
    var balance = ""
    var firebaseEntries = [Entry]()
    var thebestentries = [[Entry]]()
    var hehe = [Entry]()
    let monthSelection = MonthSelection(date: Date())
    let entryFiller = EntryFiller(desiredDate: Date())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBlurEffect()
        setUISettings()
        setTableView()
        setTabBar()
        entryFiller.setData()
        fillEntries()
    }
    
    @IBAction func minusPressed(_ sender: UIButton) {
        //DECREMENT MONTH
        print("MINUS PRESSED")
        
        monthSelection.decrement()
        userDatePicker.date = monthSelection.getDate()
        entryFiller.desiredDate = monthSelection.getDate()
        fillEntries()
        tableView.reloadData()
    }
    @IBAction func plusPressed(_ sender: UIButton) {
        //INCREMENT MONTH
        print("PLUS PRESSED")
        monthSelection.increment()
        userDatePicker.date = monthSelection.getDate()
        entryFiller.desiredDate = monthSelection.getDate()
        fillEntries()
        tableView.reloadData()
    }
    @IBAction func dateChanged(_ sender: UIDatePicker) {
        monthSelection.date = sender.date
        entryFiller.desiredDate = sender.date
        fillEntries()
        tableView.reloadData()
    }

    
    func fillEntries() {
        self.entryFiller.entries = []
        self.entryFiller.firebaseEntries = []
        db.collection("entries").whereField("uid", isEqualTo: user!.uid)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        let data = document.data()
                        self.entryFiller.firebaseEntries.append(Entry(type: data["type"] as! String, category: data["category"] as! String,mainCategory: data["mainCategory"] as! String, source: data["source"]as! String, amount: data["amount"] as! String, day: data["day"] as! String, dayInWeek: data["dayInWeek"] as! String, year: data["year"]as! String, month: data["month"]as! String, id: data["id"]as! String, uid: data["uid"]as! String, recurring: data["recurring"]as! String,weekOfMonth: data["weekOfMonth"]as! String))
                    }
                    
                    //Get STATUS
                    self.entryFiller.thebest()
                    self.setFinancialOutlets()
                    UserDefaults.standard.set(self.totalOutlet.text, forKey: "userStatus")
                    UserDefaults.standard.synchronize()
                    
                    switch self.selectedMode {
                    
                    case "Today":
                        self.entryFiller.thebest3()
                        self.setFinancialOutlets()
                        
                    case "Weekly":
                        self.entryFiller.thebest2()
                        self.setFinancialOutlets()
                    case "Daily":
                        self.entryFiller.thebest()
                        self.setFinancialOutlets()
                    case "Total":
                        self.entryFiller.thebest()
                        self.setFinancialOutlets()
                    default:
                        print("ERROR")
                    }
                    self.tableView.reloadData()

                    
                }
            }
    }

    
    func setBlurEffect(){
        effect = visualEffectView.effect
        visualEffectView.effect = nil
    }
    
    func setUISettings(){
        addView.layer.cornerRadius = 5
        addView.removeFromSuperview()
        self.hideKeyboardWhenTappedAround()
    }
    
    func setTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.setContentOffset(tableView.contentOffset, animated: false)

    }
    func setTabBar(){
        tabBarOutlet.delegate = self
        tabBarOutlet.selectedItem = tabBarOutlet.items?[0]
    }
    
    @IBAction func onChange(_ sender: UISegmentedControl) {
        selectedMode = segmentedControl.titleForSegment(at: segmentedControl.selectedSegmentIndex)!
        fillEntries()
        print(selectedMode)
        
    }

    @IBAction func unwindFromAllEditingVC(_ sender: UIStoryboardSegue) {
        self.fillEntries()
        tableView.reloadData()
        animateOut()
        print("Came from AllEditingVC")
    }
    
    func setFinancialOutlets() {
        let total = calculator.calculateTotal(entries: entryFiller.entries)
        
        let income = calculator.calculateIncome(entries: entryFiller.entries)
        let expenses = calculator.calculateExpenses(entries: entryFiller.entries)
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
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if(item.tag == 0) {
            print("Home Selected")
        } else if(item.tag == 1) {
            helperMethods.goToTableRecurringVC(senderController: self)
        } else if(item.tag == 2) {
            helperMethods.goToGraphsVC(senderController: self)
        } else if(item.tag == 3) {
            print("Settings Selected")
            helperMethods.goToSettingsVC(senderController: self)
        }
    }
    
    @IBAction func incomePressed(_ sender: UIButton) {
        userAction = "IncomeButton"
        TYPE = "Income"
        self.performSegue(withIdentifier: "goToAllEditingVC", sender: self)
    }
    
    @IBAction func expensePressed(_ sender: UIButton) {
        userAction = "ExpenseButton"
        TYPE = "Expense"
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return entryFiller.entries.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return entryFiller.entries[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if selectedMode == "Weekly"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "weekCell", for: indexPath) as! WeekCell
            let entry = entryFiller.entries[indexPath.section][indexPath.row]
            
            print(entry.category)
            cell.setEntry(entries: [entry])
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HomeTableViewCell
            let entry = entryFiller.entries[indexPath.section][indexPath.row]
            print(entry.category)
            cell.setEntry(entry: entry)
            return cell
        }
        
        var cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! HeaderTableViewCell
        
        let entry = entryFiller.entries[section]
        if entry.count != 0 {
            cell.setMode(mode: selectedMode)
            cell.setEntry(entries: entry)
            cell.setTotal(entries: entry)
            return cell
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (contextualAction, view, boolValue) in
            let entry = self.entryFiller.entries[indexPath.section][indexPath.row]
            //deleteUserCategory(selectedEntryID: entry.categoryID)
            var changedEntries = self.entryFiller.entries
            changedEntries[indexPath.section].remove(at: indexPath.row)
            //changedEntries.remove(at: indexPath.section)
            self.firebaseMethods.deleteUserEntry(selectedEntryID: entry.id)
            self.entryFiller.entries = changedEntries
            tableView.reloadData()
        }
        delete.backgroundColor = UIColor.red
        let edit = UIContextualAction(style: .destructive, title: "Edit") { (contextualAction, view, boolValue) in
            let entry = self.entryFiller.entries[indexPath.section][indexPath.row]
            self.editAmount = entry.amount
            self.editCategory = entry.category
            self.SELECTEDCAT = entry.mainCategory
            
            self.selectedEntryID = entry.id
            self.editSource = entry.source
            self.userAction = "EditEntry"
            self.TYPE = entry.type
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
            vc?.TYPE = TYPE
            vc?.SELECTEDCAT = SELECTEDCAT
        }
    }
    
}
