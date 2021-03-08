//
//  HomeViewController.swift
//  Budget Manager
//
//  Created by Cenk Donmez on 5.03.2021.
//  Copyright © 2021 CTIS. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
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
    
    var editCategory = ""
    var editAmount = ""
    var selectedEntryID: Any!
    var editSource = ""
    var effect: UIVisualEffect!
    var entries: [[Entry]] = [[Entry(type: "Expense", category: "Car", source: "Card", amount: "-1100", day: 4, dayInWeek: "Wednesday", year: "2021", month: "3", id: "1"),Entry(type: "Income", category: "Car", source: "Card", amount: "1200", day: 4, dayInWeek: "Wednesday", year: "2021", month: "3", id: "12")],[Entry(type: "Income", category: "Salary", source: "Cash", amount: "1000", day: 7, dayInWeek: "Sunday", year: "2021", month: "3", id: "2")
                                                                                                                                                                                                                                                                                                                        ,Entry(type: "Income", category: "Tip", source: "Cash", amount: "900", day: 7, dayInWeek: "Sunday", year: "2021", month: "3", id: "3")],[Entry(type: "Income", category: "Mother", source: "Cash", amount: "800", day: 28, dayInWeek: "Sunday", year: "2021", month: "3", id: "4"),
                                                                                                                                                                                                                                                                                                                                                                                                                                                                 Entry(type: "Income", category: "Mother", source: "Cash", amount: "700", day: 28, dayInWeek: "Sunday", year: "2021", month: "3", id: "5"),
                                                                                                                                                                                                                                                                                                                                                                                                                                                                 Entry(type: "Income", category: "Mother", source: "Cash", amount: "600", day: 28, dayInWeek: "Sunday", year: "2021", month: "3", id: "6"),
                                                                                                                                                                                                                                                                                                                                                                                                                                                                 Entry(type: "Income", category: "Mother", source: "Cash", amount: "500", day: 28, dayInWeek: "Sunday", year: "2021", month: "3", id: "7")],[Entry(type: "Income", category: "Mother", source: "Cash", amount: "400", day: 29, dayInWeek: "Sunday", year: "2021", month: "3", id: "8"),
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             Entry(type: "Income", category: "Mother", source: "Cash", amount: "300", day: 29, dayInWeek: "Sunday", year: "2021", month: "3", id: "9")],[Entry(type: "Income", category: "Mother", source: "Cash", amount: "200", day: 30, dayInWeek: "Sunday", year: "2021", month: "3", id: "10"),
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         Entry(type: "Income", category: "Mother", source: "Cash", amount: "100", day: 30, dayInWeek: "Sunday", year: "2021", month: "3", id: "11")]]
    var sections: [Int] = []
    var count = 0
    
    
    
    func setData(){
        let sortedArray = entries.sorted(by: {$0[0].day > $1[0].day })
        entries.removeAll()
        entries.append(contentsOf: sortedArray)
    }
    
    @IBAction func unwindFromAddToHome(_ sender: UIStoryboardSegue){
        
        self.tableView.reloadData()
        animateOut()
        print("Came from ADDVC")
        
    }
    @IBAction func unwindFromEditToHome(_ sender: UIStoryboardSegue){
        
        self.tableView.reloadData()
        animateOut()
        print("Came from EditVC")
        
    }
    @IBAction func unwindFromExpenseToHome(_ sender: UIStoryboardSegue){
        
        self.tableView.reloadData()
        animateOut()
        print("Came from ExpenseVC")
        
    }
    
    func calculateTotal() -> String{
        var total = 0
        
        for array in entries {
            for value in array {
                total = total + Int(value.amount)!
            }
            print(" ")
        }
        return String(total)
    }
    
    func calculateExpenses() -> String{
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
    
    func calculateIncome() -> String{
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
        if Int(total)!<0 {
            totalOutlet.textColor = UIColor(red: 0.98, green: 0.39, blue: 0.00, alpha: 1.00)
        }
        else if Int(total)! >= 0 {
            totalOutlet.textColor = UIColor(red: 0.24, green: 0.48, blue: 0.94, alpha: 1.00)
            
        }
        
        totalOutlet.text = total
        incomeOutlet.text = income
        expenseOutlet.text = expenses
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setData()
        setFinancialOutlets()
        calculateTotal()
        effect = visualEffectView.effect
        visualEffectView.effect = nil
        addView.layer.cornerRadius = 5
        addView.removeFromSuperview()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func animateIn(){
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
        } completion: { (success:Bool) in
            self.addView.removeFromSuperview()
            self.addButtonOutlet.setAttributedTitle(NSAttributedString(string: "+"), for: .normal)
            self.view.sendSubviewToBack(self.visualEffectView)
        }
        
    }
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        
        if(addButtonOutlet.attributedTitle(for: .normal) == NSAttributedString(string: "x")){
            animateOut()
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
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .default, title: "Delete") { (action, indexPath) in
            let entry = self.entries[indexPath.section][indexPath.row]
            //deleteUserCategory(selectedEntryID: entry.categoryID)
            var changedEntries = self.entries
            changedEntries[indexPath.section].remove(at: indexPath.row)
            if changedEntries[indexPath.section].count == 0 {
                
                changedEntries.remove(at: indexPath.section)
            }
            
            self.entries = changedEntries
            tableView.reloadData()
            
        }
        delete.backgroundColor = UIColor.red
        
        let edit = UITableViewRowAction(style: .default, title: "Edit") { (action, indexPath) in
            let entry = self.entries[indexPath.section][indexPath.row]
            self.editAmount = entry.amount as! String
            self.editCategory = entry.category
            self.selectedEntryID = entry.id
            self.editSource = entry.source
            self.performSegue(withIdentifier: "goToEdit", sender: self)
        }
        edit.backgroundColor = UIColor(red: 0.13, green: 0.17, blue: 0.40, alpha: 1.00)
        
        return [delete, edit]
    }
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "goToEdit" {
            let vc = segue.destination as? EditViewController
            print("DATA ON PREPARE\(editAmount),\(editCategory)")
            vc?.amount = editAmount
            vc?.category = editCategory
            vc?.entryID = selectedEntryID
            vc?.source = editSource
        }
    }
    
}
