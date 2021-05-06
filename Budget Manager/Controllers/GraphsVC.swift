//
//  GraphsVC.swift
//  Budget Manager
//
//  Created by Cenk Donmez on 13.04.2021.
//  Copyright © 2021 CTIS. All rights reserved.
//

import UIKit
import Charts
import Firebase
import FirebaseAuth
class GraphsVC: UIViewController, UITabBarDelegate,UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tabBarOutlet: UITabBar!
    let firebaseMethods = FirebaseMethods()
    var entries: [[Entry]] = [[]]
    var categories: [String] = []
    var incomeCategories: [String] = []
    var recurringCategories: [String] = []
    var grapDic:[Int:String] = [:]
    var dataSets:[IChartDataSet] = []
    var pieDataSets:[ChartDataSet] = []
    var colors: [UIColor] = []
    var total = 0.0
    var type = ""
    var specialTotal: [Double] = []

    let db = Firestore.firestore()
    let user = Auth.auth().currentUser
    let helperMethods = HelperMethods()

    override func viewDidLoad() {
        super.viewDidLoad()
        type = "Expense"
        setTableView()
        segmentedControl.selectedSegmentIndex = 0
        setTabBar()
        fillEntries()
    }
    @IBAction func onChange(_ sender: UISegmentedControl) {
        type = segmentedControl.titleForSegment(at: segmentedControl.selectedSegmentIndex)!
        
        switch type {
        case "Recurring":
            print("Nothing!")
            helperMethods.goToRecurringGraphVC(senderController: self)
            
        case "Income":
            helperMethods.goToIncomeGraphVC(senderController: self)

//            DispatchQueue.main.async {
//                self.createExpenseBarChart()
//            }
        case "Expense":
            
            helperMethods.goToGraphsVC(senderController: self)
//            DispatchQueue.main.async {
//                self.createExpenseBarChart()
//            }
        default:
            print("ERROR!")
        }
        
        print(type)
    }
    
    func setTabBar(){
        tabBarOutlet.delegate = self
        tabBarOutlet.selectedItem = tabBarOutlet.items?[2]
    }
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if(item.tag == 0) {
            print("Home Selected")
            helperMethods.goToHomeVC(senderController: self)
        } else if(item.tag == 1) {
            helperMethods.goToTableRecurringVC(senderController: self)
        } else if(item.tag == 2) {
        }else if(item.tag == 3) {
            print("Settings Selected")
            helperMethods.goToSettingsVC(senderController: self)        }
    }
    
    func createExpenseBarChart(){
        dataSets.removeAll()
        //Create bar chart
        let barChart = BarChartView(frame: CGRect(x: 0, y: 100, width: view.frame.width, height: 300))
        barChart.tag = 0
        
        var i = 0
        if type == "Expense" {
            for category in categories {
                for entry in entries.matrixIterator() {
                    if entry.mainCategory == category {
                        total = total + Double(entry.amount)!
                    }
                }
                dataSets.append(BarChartDataSet(entries: [BarChartDataEntry(x: Double(i), y: total)], label: String(category)))
                barChart.notifyDataSetChanged()
                i = i+1
                specialTotal.append(total)
                total = 0.0

            }
        }
        else if type == "Income" {
            for category in incomeCategories {
                for entry in entries.matrixIterator() {
                    if entry.mainCategory == category {
                        total = total + Double(entry.amount)!
                    }
                }
                dataSets.append(BarChartDataSet(entries: [BarChartDataEntry(x: Double(i), y: total)], label: String(category)))
                barChart.notifyDataSetChanged()
                i = i+1
                total = 0.0

            }
        }
        barChart.notifyDataSetChanged()
       
        

        //COlor change
        for set in dataSets {
            set.setColor(.random)
        }
        let data = BarChartData(dataSets: dataSets)
        barChart.data = data
        barChart.drawGridBackgroundEnabled = false
        barChart.drawBarShadowEnabled = false
        barChart.leftAxis.enabled = false
        barChart.rightAxis.enabled = false
        barChart.xAxis.enabled = false
        
        
        barChart.invalidateIntrinsicContentSize()
       
            view.addSubview(barChart)
        
        //barChart.center = view.center
        
    }
    
    func fillEntries() {
        self.entries = []
        db.collection("entries").whereField("uid", isEqualTo: user!.uid)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        let data = document.data()
                        if data["recurring"] as! String == "false" {
                            self.entries.append([Entry(type: data["type"] as! String, category: data["category"] as! String,mainCategory: data["mainCategory"] as! String, source: data["source"]as! String, amount: String((data["amount"] as! String).dropFirst()), day: data["day"] as! String, dayInWeek: data["dayInWeek"] as! String, year: data["year"]as! String, month: data["month"]as! String, id: data["id"]as! String, uid: data["uid"]as! String, recurring: data["recurring"]as! String, weekOfMonth: data["weekOfMonth"] as! String)])
                        }
                     
                    }
                }
                self.getExpenseCategories()
                self.getIncomeCategories()
                self.getRecurringCategories()
                self.createExpenseBarChart()
                self.tableView.reloadData()
            }
    }
    
    func getExpenseCategories(){
        categories = []
        for entry in entries.matrixIterator() {
            let category = entry.mainCategory
            if entry.type == "Expense" {
                
            if categories.isEmpty {
                categories.append(category)
            }
            else{
                for category1 in categories {
                    if category1 != category {
                        categories.append(category)
                    }
                }
            }
        }
        }
        categories = categories.uniqued()
        dump(categories)
    }

    
    func getIncomeCategories(){
        incomeCategories = []
        for entry in entries.matrixIterator() {
            let category = entry.category
            if entry.type == "Income" {
                
            if incomeCategories.isEmpty {
                incomeCategories.append(category)
            }
            else{
                for category1 in incomeCategories {
                    if category1 != category {
                        incomeCategories.append(category)
                    }
                }
            }
        }
        }
        incomeCategories = incomeCategories.uniqued()
        dump(incomeCategories)
    }
    
    func getRecurringCategories(){
        recurringCategories = []
        for entry in entries.matrixIterator() {
            let category = entry.category
            if entry.recurring == "true" {
                
            if recurringCategories.isEmpty {
                recurringCategories.append(category)
            }
            else{
                for category1 in recurringCategories {
                    if category1 != category {
                        recurringCategories.append(category)
                    }
                }
            }
        }
        }
        recurringCategories = recurringCategories.uniqued()
        dump(recurringCategories)
    }
    
    func removeSubview(tag: Int){
        
        if let viewWithTag = self.view.viewWithTag(tag) {
            viewWithTag.removeFromSuperview()
        }else{
            
        }
    }
    
    //COPY START
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "expenseCell", for: indexPath) as! GraphCell
        cell.setExpenseTable(mainCat: categories[indexPath.row], total: String(specialTotal[indexPath.row]))
        return cell
    }
    
    //COPY END
    func setTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.setContentOffset(tableView.contentOffset, animated: false)

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

extension Sequence where Element: Hashable {
    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}

extension UIColor {
    static var random: UIColor {
        return UIColor(red: .random(in: 0...1),
                       green: .random(in: 0...1),
                       blue: .random(in: 0...1),
                       alpha: 1.0)
    }
}
