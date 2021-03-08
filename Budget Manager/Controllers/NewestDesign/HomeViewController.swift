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
    let db = Firestore.firestore()
    var selectedEntryID: Any!
    var editSource = ""
    var effect: UIVisualEffect!
    var users: [User] = []
    var entries: [[Entry]] = [[]]
    var selectedCategories: [Category] = []
    var editName = ""


//    var entries: [[Entry]] = [[Entry(type: "Expense", category: "Car", source: "Card", amount: "-1100", day: 4, dayInWeek: "Wednesday", year: "2021", month: "3", id: "1", uid: "4444"),Entry(type: "Income", category: "Car", source: "Card", amount: "1200", day: 4, dayInWeek: "Wednesday", year: "2021", month: "3", id: "12", uid: "33")],[Entry(type: "Income", category: "Salary", source: "Cash", amount: "1000", day: 7, dayInWeek: "Sunday", year: "2021", month: "3", id: "2", uid: "1312")
//                                                                                                                                                                                                                                                                                                                                                      ,Entry(type: "Income", category: "Tip", source: "Cash", amount: "900", day: 7, dayInWeek: "Sunday", year: "2021", month: "3", id: "3", uid: "33333")],[Entry(type: "Income", category: "Mother", source: "Cash", amount: "800", day: 28, dayInWeek: "Sunday", year: "2021", month: "3", id: "4", uid: "12312312"),
//                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   Entry(type: "Income", category: "Mother", source: "Cash", amount: "700", day: 28, dayInWeek: "Sunday", year: "2021", month: "3", id: "5", uid: "22"),
//                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   Entry(type: "Income", category: "Mother", source: "Cash", amount: "600", day: 28, dayInWeek: "Sunday", year: "2021", month: "3", id: "6", uid: "111"),
//                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   Entry(type: "Income", category: "Mother", source: "Cash", amount: "500", day: 28, dayInWeek: "Sunday", year: "2021", month: "3", id: "7", uid: "11")],[Entry(type: "Income", category: "Mother", source: "Cash", amount: "400", day: 29, dayInWeek: "Sunday", year: "2021", month: "3", id: "8", uid: "123123123123"),
//                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          Entry(type: "Income", category: "Mother", source: "Cash", amount: "300", day: 29, dayInWeek: "Sunday", year: "2021", month: "3", id: "9", uid: "2")],[Entry(type: "Income", category: "Mother", source: "Cash", amount: "200", day: 30, dayInWeek: "Sunday", year: "2021", month: "3", id: "10", uid: "123123218128"),
//                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             Entry(type: "Income", category: "Mother", source: "Cash", amount: "100", day: 30, dayInWeek: "Sunday", year: "2021", month: "3", id: "11", uid: "1")]]
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
        DispatchQueue.main.async {
            self.getAll(completion: ())
    
}
        self.tableView.reloadData()
        animateOut()

        
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
        getAll(completion: ())
        // Should print: a, b, c, d, e, f
   
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
                
                self.deleteUserEntry(selectedEntryID: entry.id)

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
    
    func getUserDetails(completionHandler:@escaping(String, String, String)->(),uid: String){
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
                                completionHandler ((data["firstname"] as? String)!, (data["lastname"]as? String)!, (data["uid"]as? String)!)
                            }
                        }
                    }
            }
        }
    }
    func getUserEntries(completionHandler:@escaping(String, String, String,String,Int,String,String,String,String,String)->(),uid: String){
        entries = []
        db.collection("entries").whereField("uid", isEqualTo: uid)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    print(uid)
                    for document in querySnapshot!.documents {
                        let data = document.data()
                        completionHandler (data["type"] as! String, data["category"] as! String, data["source"]as! String, data["amount"] as! String, Int(data["day"] as! String)! as! Int, data["dayInWeek"] as! String, data["year"]as! String,data["month"]as! String,data["id"]as! String,data["uid"]as! String)
                        self.tableView.reloadData()
                        
                    }
                }
            }
    }
    
    func deleteUserEntry(selectedEntryID: Any){
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
    func goToLandingVC() {
        let homeViewController = storyboard?.instantiateViewController(identifier: "TestLanding") as? TestLanding
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
    
    func getAll(completion: ()){
        if Auth.auth().currentUser != nil {
            // User is signed in.
            let user = Auth.auth().currentUser
            getUserDetails(completionHandler: { (firstname, lastname, uid) in
                let user = User(firstname: firstname, lastname: lastname, uid: uid)
                self.users.append(user)
            }, uid: user!.uid)

                self.getUserEntries(completionHandler: { (type, category,source, amount, day,dayInWeek, year,month,id,uid) in
                let entry = Entry(type: type, category: category, source: source, amount: amount, day: day, dayInWeek: dayInWeek, year: year, month: month, id: id, uid: uid)
                self.entries.append([entry])
            }, uid: user!.uid)
            
            completion
            tableView.reloadData()
            
        } else {
            // No user is signed in.
            goToLandingVC()
        }

    }
    
}

fileprivate extension Array where Element : Collection, Element.Index == Int {

    typealias InnerCollection = Element
    typealias InnerElement = InnerCollection.Iterator.Element

    func matrixIterator() -> AnyIterator<InnerElement> {
        var outerIndex = self.startIndex
        var innerIndex: Int?

        return AnyIterator({
            guard !self.isEmpty else { return nil }

            var innerArray = self[outerIndex]
            if !innerArray.isEmpty && innerIndex == nil {
                innerIndex = innerArray.startIndex
            }

            // This loop makes sure to skip empty internal arrays
            while innerArray.isEmpty || (innerIndex != nil && innerIndex! == innerArray.endIndex) {
                outerIndex = self.index(after: outerIndex)
                if outerIndex == self.endIndex { return nil }
                innerArray = self[outerIndex]
                innerIndex = innerArray.startIndex
            }

            let result = self[outerIndex][innerIndex!]
            innerIndex = innerArray.index(after: innerIndex!)

            return result
        })
    }

}
    

