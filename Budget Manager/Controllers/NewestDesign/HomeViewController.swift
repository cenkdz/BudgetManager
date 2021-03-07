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
    @IBOutlet weak var balanceOutlet: UILabel!
    @IBOutlet weak var yearMonthOutlet: UILabel!
    @IBOutlet weak var dayNameOutlet: UILabel!
    @IBOutlet weak var dayOutlet: UILabel!
    
    var effect: UIVisualEffect!
    var tableData: [String] = ["Row 1","Row 2","Row 3"]
    var entries: [Entry] = []
    func setData(){
        
        
let data = Entry(type: "Expense", category: "Car", source: "Card", amount: "200", day: String(4), dayInWeek: "Wednesday", year: "2021", month: "3")
        let data2 = Entry(type: "Income", category: "Salary", source: "Cash", amount: "1000", day: "7", dayInWeek: "Sunday", year: "2021", month: "3")
        
        entries.append(data)
        entries.append(data2)
    }
    
    func calculateTotal(entry: [Entry]) -> String{
        var total = 0
        
        for entry in entries {
            if entry.type == "Expense" {
                total = total - Int(entry.amount)!
            }
            else{
                total = total + Int(entry.amount)!
            }
        }

        return String(total)
    }
    
    func calculateExpenses(entry: [Entry]) -> String{
        var expenses = 0
        
        for entry in entries {
            if entry.type == "Expense" {
                expenses = expenses + Int(entry.amount)!
            }
        }
        return String(expenses)
    }
    
    func calculateIncome(entry: [Entry]) -> String{
        var income = 0
        
        for entry in entries {
            if entry.type == "Income" {
                income = income + Int(entry.amount)!
            }
        }
        return String(income)
    }
    
    func getDays(entry: [Entry]) -> [String] {
        var days: [String] = []
        
        for entry in entries {
            var dayData = entry.day
            
            if !days.contains(dayData){
                days.append(dayData)
            }
            
        }
        
        return days
    }
    
    func getTodayEntries() -> [Entry] {
        
        let date = Date()

        let dateFormatter = DateFormatter()

        func getCurrentYear() -> String{
            
            return String(Calendar.current.component(.year, from: date))
        }

        func getCurrentMonth()-> String{
            return String(Calendar.current.component(.month, from: date))
        }

        func getCurrentDay()-> String{
            return String(Calendar.current.component(.day, from: date))
        }

        func getCurrentDayInWeek()-> String{
            dateFormatter.dateFormat = "EEEE"

            return String(dateFormatter.string(from: date))

        }
        
        let todayDay = getCurrentDay()
        let todayMonth = getCurrentMonth()
        let todayYear = getCurrentYear()
        let todayDayInWeek = getCurrentDayInWeek()
        
        let todayEntries = entries.filter({
            $0.day == todayDay && $0.month == todayMonth && $0.year == todayYear
        })
        return todayEntries
    }
    
    func setFinancialOutlets() {
        let income = calculateIncome(entry: entries)
        let expenses = calculateExpenses(entry: entries)
        let total = calculateTotal(entry: entries)
                
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
        effect = visualEffectView.effect
        visualEffectView.effect = nil
        addView.layer.cornerRadius = 5
        addView.removeFromSuperview()

        tableView.delegate = self
        tableView.dataSource = self
        //tableView.tableHeaderView = customHeaderView
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

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! HomeTableViewCell
        let data = getTodayEntries()
        let entry = entries[indexPath.row]
        cell.setEntry(entry: entry)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell")
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 96
        }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 20
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
    
}
