//
//  IncomeGraphVC.swift
//  Budget Manager
//
//  Created by Cenk Donmez on 26.04.2021.
//  Copyright © 2021 CTIS. All rights reserved.
//


import UIKit
import Charts
import Firebase
import FirebaseAuth
class IncomeGraphVC: UIViewController, UITabBarDelegate,UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var titleOutlet: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tabBarOutlet: UITabBar!
    let firebaseMethods = FirebaseMethods()
    var entries: [[Entry]] = [[]]
    var incomes: [Entry] = []
    var categories: [String] = []
    var incomeCategories: [String] = []
    var recurringCategories: [String] = []
    var grapDic:[Int:String] = [:]
    var dataSets:[IChartDataSet] = []
    var pieDataSets:[ChartDataSet] = []
    var colors: [UIColor] = []
    var total = 0.0
    var type = ""
    var selSub = ""

    let db = Firestore.firestore()
    let user = Auth.auth().currentUser
    let helperMethods = HelperMethods()
    var specialTotal: [Int] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        type = "Income"
        setTableView()
        segmentedControl.selectedSegmentIndex = 1
        setTabBar()
        fillEntries()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        let nameOfMonth = dateFormatter.string(from: now)
        titleOutlet.text = (nameOfMonth + "'s Incomes")
    }
    @IBAction func onChange(_ sender: UISegmentedControl) {
        type = segmentedControl.titleForSegment(at: segmentedControl.selectedSegmentIndex)!
        
        switch type {
        case "Recurring":
            helperMethods.goToRecurringGraphVC(senderController: self)
        case "Income":
            helperMethods.goToIncomeGraphVC(senderController: self)
        case "Expense":
            helperMethods.goToGraphsVC(senderController: self)
        default:
            print("ERROR!")
        }
        
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
    
    func createIncomeBarChart(){
        //Create bar chart
        let barChart = BarChartView(frame: CGRect(x: 0, y: 100, width: view.frame.width, height: 300))
        barChart.tag = 1
        
        var i = 0
        
        for category in categories {
            for entry in entries.matrixIterator() {
                if entry.mainCategory == category && entry.type == "Income" {
                    total = total + Double(entry.amount)!
                }
            }
            dataSets.append(BarChartDataSet(entries: [BarChartDataEntry(x: Double(i), y: total)], label: String(category)))
            i = i+1
            specialTotal.append(Int(total))
            total = 0.0

        }

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
        
        view.addSubview(barChart)
        
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
                            if data["type"] as! String == "Income" {
                                if data["month"] as! String == String(Calendar.current.component(.month, from: Date())){
                                self.incomes.append(Entry(type: data["type"] as! String, category: data["category"] as! String,mainCategory: data["mainCategory"] as! String, source: data["source"]as! String, amount: data["amount"] as! String, day: data["day"] as! String, dayInWeek: data["dayInWeek"] as! String, year: data["year"]as! String, month: data["month"]as! String, id: data["id"]as! String, uid: data["uid"]as! String, recurring: data["recurring"]as! String, weekOfMonth: data["weekOfMonth"] as! String))
                                }
                            }
                            if data["month"] as! String == String(Calendar.current.component(.month, from: Date())){
                        self.entries.append([Entry(type: data["type"] as! String, category: data["category"] as! String,mainCategory: data["mainCategory"] as! String, source: data["source"]as! String, amount: data["amount"] as! String, day: data["day"] as! String, dayInWeek: data["dayInWeek"] as! String, year: data["year"]as! String, month: data["month"]as! String, id: data["id"]as! String, uid: data["uid"]as! String, recurring: data["recurring"]as! String, weekOfMonth: data["weekOfMonth"] as! String)])
                        }
                        }
                    }
                }
                self.getIncomeCategories()
                self.createIncomeBarChart()
                self.tableView.reloadData()

            }
    }

    func getIncomeCategories(){
        categories = []
        for entry in entries.matrixIterator() {
            let category = entry.mainCategory
            if entry.type == "Income" {
                
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
    
    func removeSubview(tag: Int){
        
        if let viewWithTag = self.view.viewWithTag(tag) {
            viewWithTag.removeFromSuperview()
        }else{
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "incomeCell", for: indexPath) as! GraphCell2
        cell.setIncomeTable(mainCategory: categories[indexPath.row], totalIncome: String(specialTotal[indexPath.row]))
        return cell
    }
    
    func setTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.setContentOffset(tableView.contentOffset, animated: false)

    }

    func goToSubVC2(senderController: UIViewController) {
        let homeViewController = senderController.storyboard?.instantiateViewController(identifier: "SubVC2") as? SubVC2
        homeViewController?.selectedSubCategory = selSub
        homeViewController?.entries = self.incomes

        senderController.view.window?.rootViewController = homeViewController
        senderController.view.window?.makeKeyAndVisible()
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
