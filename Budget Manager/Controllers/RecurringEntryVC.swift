//
//  AllEditingViewController.swift
//  Budget Manager
//
//  Created by CTIS Student on 9.03.2021.
//  Copyright © 2021 CTIS. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class RecurringEntryVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var selectCategoryButtonOutlet: UIButton!
    @IBOutlet weak var selectSourceButtonOutlet: UIButton!
    @IBOutlet weak var amountTextFieldOutlet: UITextField!
    @IBOutlet weak var tableViewOutlet: UITableView!
    @IBOutlet weak var doneButtonOutlet: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser
    var amount = ""
    var category = "Source"
    var selectedButton = ""
    var entryID: Any!
    var source = "Category"
    var categories: [Category] = []
    var sources: [Source] = []
    var typeType = ""
    var editName = ""
    var addedText = ""
    var userAction = ""
    var selectedType = ""

    var selectedDate = Date()
    var selectedEndDate = Date()

    var selectedYear = ""
    var selectedMonth = ""
    var selectedDay = ""
    var selectedHour = ""
    var selectedMinute = ""
    var selectedDayInWeek = ""

    var selectedEndYear = ""
    var selectedEndMonth = ""
    var selectedEndDay = ""
    var selectedEndHour = ""
    var selectedEndMinute = ""
    var selectedEndDayInWeek = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Selected User Action Is \(userAction)")
        self.hideKeyboardWhenTappedAround()

        tableViewOutlet.isHidden = true
        tableViewOutlet.delegate = self
        tableViewOutlet.dataSource = self
        selectedType = "Expense"
        print("Id is\(entryID)")

    }
    @IBAction func onChange(_ sender: UISegmentedControl) {
        selectedType = segmentedControl.titleForSegment(at: segmentedControl.selectedSegmentIndex)!
    }
    
    @IBAction func unwindToAllEditingVC(_ sender: UIStoryboardSegue) {
        if sender.source is AddCategoryViewController {
            if let senderVC = sender.source as? AddCategoryViewController {
                addedText = senderVC.selectedI
                switch senderVC.type {
                case "Source":
                    source = senderVC.type
                    DispatchQueue.main.async {
                        self.getUserSources(completionHandler: { (sourceID, sourceIcon, sourceName, uid) in
                            let source = Source(sourceID: sourceID, sourceName: sourceName, sourceIcon: sourceIcon, uid: uid)
                            self.sources.append(source)
                        }, uid: self.user!.uid)

                    }
                    tableViewOutlet.reloadData()


                case "Category":
                    source = senderVC.type
                    DispatchQueue.main.async {
                        self.getUserCategories(completionHandler: { (categoryID, categoryIcon, categoryName, uid) in
                            let category = Category(categoryID: categoryID, categoryName: categoryName, categoryIcon: categoryIcon, uid: uid)
                            self.categories.append(category)
                        }, uid: self.user!.uid)
                    }
                    tableViewOutlet.reloadData()


                default:
                    source = senderVC.type
                    DispatchQueue.main.async {
                        self.getUserSources(completionHandler: { (sourceID, sourceIcon, sourceName, uid) in
                            let source = Source(sourceID: sourceID, sourceName: sourceName, sourceIcon: sourceIcon, uid: uid)
                            self.sources.append(source)
                        }, uid: self.user!.uid)

                    }
                    tableViewOutlet.reloadData()

                }
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        selectCategoryButtonOutlet.setAttributedTitle(NSAttributedString(string: category), for: .normal)
        selectSourceButtonOutlet.setAttributedTitle(NSAttributedString(string: source), for: .normal)
        amountTextFieldOutlet.text = amount
        print("Selected User Action Is \(userAction)")

    }
    @IBAction func datePickerSelected(_ sender: UIDatePicker) {
        selectedDate = sender.date
        let comp = datePicker.calendar.dateComponents([.day, .month, .year, .hour, .minute], from: datePicker.date)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        selectedDay = String(comp.day!)
        selectedYear = String(comp.year!)
        selectedMonth = String(comp.month!)
        selectedHour = String(comp.hour!)
        selectedMinute = String(comp.minute!)
        selectedDayInWeek = String(dateFormatter.string(from: selectedDate))
    }
    @IBAction func endDateSelected(_ sender: UIDatePicker) {
        selectedEndDate = sender.date
        let comp = datePicker.calendar.dateComponents([.day, .month, .year, .hour, .minute], from: sender.date)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        selectedEndDay = String(comp.day!)
        selectedEndYear = String(comp.year!)
        selectedEndMonth = String(comp.month!)
        selectedEndHour = String(comp.hour!)
        selectedEndMinute = String(comp.minute!)
        selectedEndDayInWeek = String(dateFormatter.string(from: selectedDate))
    }
    @IBAction func selectCategoryPressed(_ sender: UIButton) {
        print("Select Category Pressed!")
        selectedButton = "CategoryButton"
        self.getUserCategories(completionHandler: { (categoryID, categoryIcon, categoryName, uid) in
            let category = Category(categoryID: categoryID, categoryName: categoryName, categoryIcon: categoryIcon, uid: uid)
            self.categories.append(category)
        }, uid: self.user!.uid)
        self.tableViewOutlet.isHidden = false
        self.tableViewOutlet.reloadData()
    }
    @IBAction func selectSourcePressed(_ sender: UIButton) {
        print("Select Source Pressed!")
        selectedButton = "SourceButton"
        self.getUserSources(completionHandler: { (sourceID, sourceIcon, sourceName, uid) in
            let source = Source(sourceID: sourceID, sourceName: sourceName, sourceIcon: sourceIcon, uid: uid)
            self.sources.append(source)
        }, uid: self.user!.uid)
        self.tableViewOutlet.isHidden = false
        self.tableViewOutlet.reloadData()
    }
    func goToHomeVC() {
        let homeViewController = storyboard?.instantiateViewController(identifier: "HomeViewController") as? HomeViewController
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
    func displayAlert(message: String,title: String) {
        let dialogMessage = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
        })
        dialogMessage.addAction(ok)
        self.present(dialogMessage, animated: true, completion: nil)
        
    }
    @IBAction func donePressed(_ sender: UIButton) {
        let change = selectedEndDate - selectedDate
        let monthDiff = change.month!
        if amountTextFieldOutlet.text!.isEmpty{
            displayAlert(message: "Amount cannot be empty!", title: "Warning")
        }else if selectedDay == ""{
            displayAlert(message: "Please select a start date", title: "Warning")
        }else if selectedEndDay == ""{
            displayAlert(message: "Please select a end date", title: "Warning")
        }
        else{
        DispatchQueue.main.async {
            self.addRecurringEntry(monthDiff: monthDiff)
        }
        DispatchQueue.main.async {
            self.goToHomeVC()
        }
        }


    }
    func getUserCategories(completionHandler: @escaping(String, String, String, String) -> (), uid: String) {
        categories = []
        db.collection("categories").whereField("uid", isEqualTo: uid)
            .getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    completionHandler (data["categoryID"] as! String, data["categoryIcon"] as! String, data["categoryName"] as! String, data["uid"] as! String)
                    self.tableViewOutlet.reloadData()
                }
            }
        }
    }

    func getUserSources(completionHandler: @escaping(String, String, String, String) -> (), uid: String) {
        sources = []
        db.collection("sources").whereField("uid", isEqualTo: uid)
            .getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    completionHandler (data["sourceID"] as! String, data["sourceIcon"] as! String, data["sourceName"] as! String, data["uid"] as! String)
                    self.tableViewOutlet.reloadData()
                }
            }
        }
    }

    func deleteUserCategory(selectedEntryID: Any) {
        db.collection("categories").whereField("categoryID", isEqualTo: selectedEntryID).getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    document.reference.delete()
                }
            }
        }
    }

    func deleteUserSource(selectedEntryID: Any) {
        db.collection("sources").whereField("sourceID", isEqualTo: selectedEntryID).getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    document.reference.delete()
                }
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        switch selectedButton {
        case "CategoryButton":
            return categories.count
        case "SourceButton":
            return sources.count
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch selectedButton {
        case "CategoryButton":
            return "Categories"
        case "SourceButton":
            return "Sources"
        default:
            return ""
        }

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        var cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CategoryCellVC
        if selectedButton == "CategoryButton" {
            cell.setCategories(category: categories[indexPath.row])
        }
        else if selectedButton == "SourceButton" {
            cell.setSources(source: sources[indexPath.row])

        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NSLog("You selected cell number: \(indexPath.row)!")
        if selectedButton == "CategoryButton" {
            let title = categories[indexPath.row].categoryName
            selectCategoryButtonOutlet.setAttributedTitle((NSAttributedString(string: title)), for: .normal)
        }
        else if selectedButton == "SourceButton" {
            let title = sources[indexPath.row].sourceName
            selectSourceButtonOutlet.setAttributedTitle((NSAttributedString(string: title)), for: .normal)
        }
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {

        let delete = UITableViewRowAction(style: .default, title: "Delete") { (action, indexPath) in
            switch self.selectedButton {
            case "CategoryButton":
                let entry = self.categories[indexPath.row]
                self.entryID = entry.categoryID

                print("BUTTON\(self.selectedButton)")
                self.deleteUserCategory(selectedEntryID: entry.categoryID)

                var changedEntries = self.categories
                changedEntries.remove(at: indexPath.row)
                self.categories = changedEntries
                tableView.reloadData()
            case "SourceButton":
                let entry = self.sources[indexPath.row]
                self.entryID = entry.sourceID
                self.deleteUserSource(selectedEntryID: entry.sourceID)

                var changedEntries = self.sources
                changedEntries.remove(at: indexPath.row)
                self.sources = changedEntries
            default:
                print("error")
            }

            tableView.reloadData()

        }
        delete.backgroundColor = UIColor.red

        let edit = UITableViewRowAction(style: .default, title: "Edit") { (action, indexPath) in
            switch self.selectedButton {
            case "CategoryButton":
                let entry = self.categories[indexPath.row]
                self.editName = entry.categoryName
                self.entryID = entry.categoryID
                self.typeType = "Category"

            case "SourceButton":
                let entry = self.sources[indexPath.row]
                self.editName = entry.sourceName
                self.entryID = entry.sourceID
                self.typeType = "Source"


            default:
                print("ERRROR")
            }
            DispatchQueue.main.async() {
                self.performSegue(withIdentifier: "goToCategory", sender: self)
            }
        }
        edit.backgroundColor = UIColor(red: 0.13, green: 0.17, blue: 0.40, alpha: 1.00)

        //edit put back
        return [delete, edit]
    }

    func editEntry(completion: ()) {
        let entries = self.db.collection("entries")
        entries.whereField("id", isEqualTo: entryID!).getDocuments(completion: { querySnapshot, error in
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
                ref.updateData(["amount": self.amountTextFieldOutlet.text])
                ref.updateData(["category": String(self.selectCategoryButtonOutlet.currentAttributedTitle!.string)])
                ref.updateData(["source": String(self.selectSourceButtonOutlet.currentAttributedTitle!.string)])
                completion
            }
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "unwindFromAllEditingVC", sender: self)
            }

        })
    }

    @objc func addRecurringEntry(monthDiff: Int) {
        var monthDifference = 1
        let user = Auth.auth().currentUser
        var type = ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"

        let firstRecurringEntry = Entry(type: selectedType, category: String(self.selectCategoryButtonOutlet.currentAttributedTitle!.string), source: String(self.selectSourceButtonOutlet.currentAttributedTitle!.string), amount: amountTextFieldOutlet.text!, day: selectedDay, dayInWeek: String(dateFormatter.string(from: selectedDate)), year: selectedYear, month: selectedMonth, id: String(Int.random(in: 10000000000 ..< 100000000000000000)), uid: user!.uid, recurring: "true", weekOfMonth: String(Calendar.current.component(.weekOfMonth, from: selectedDate)))
        let firstDictionary = firstRecurringEntry.getDictionary()
        do {
            try db.collection("entries").addDocument(data: firstDictionary)

        } catch let error {
            print("Error writing entry to Firestore: \(error)")
        }

        if ((selectedDay != selectedEndDay && selectedMonth == selectedEndMonth && selectedYear == selectedEndYear) || (selectedYear != selectedEndYear || (selectedMonth != selectedMonth)) || (selectedYear == selectedEndYear)){
            let lastRecurringEntry = Entry(type: selectedType, category: String(self.selectCategoryButtonOutlet.currentAttributedTitle!.string), source: String(self.selectSourceButtonOutlet.currentAttributedTitle!.string), amount: amountTextFieldOutlet.text!, day: selectedEndDay, dayInWeek: String(dateFormatter.string(from: selectedEndDate)), year: selectedEndYear, month: selectedEndMonth, id: String(Int.random(in: 10000000000 ..< 100000000000000000)), uid: user!.uid, recurring: "true", weekOfMonth: String(Calendar.current.component(.weekOfMonth, from: selectedEndDate)))
            let lastDictionary = lastRecurringEntry.getDictionary()
            do {
                try db.collection("entries").addDocument(data: lastDictionary)

            } catch let error {
                print("Error writing entry to Firestore: \(error)")
            }
        }

        while monthDifference != monthDiff + 1 {
            var dateComponent = DateComponents()
            dateComponent.month = monthDifference
            let futureDate = Calendar.current.date(byAdding: dateComponent, to: selectedDate)
            let incrementedDate = Calendar.current.dateComponents([.day, .year, .month], from: futureDate!)
            print("\(monthDifference)IncDay is \(incrementedDate.day)")
            print("\(monthDifference)IncMonth is \(incrementedDate.month)")
            print("\(monthDifference)IncYear is \(incrementedDate.year)")
            print("\(monthDifference)IncDayInWeek is \(String(dateFormatter.string(from: futureDate!)))")
            if (Int(selectedEndMonth) != incrementedDate.month || Int(selectedEndYear) != incrementedDate.year) {
                let incRecurringEntry = Entry(type: selectedType, category: String(self.selectCategoryButtonOutlet.currentAttributedTitle!.string), source: String(self.selectSourceButtonOutlet.currentAttributedTitle!.string), amount: amountTextFieldOutlet.text!, day: String(incrementedDate.day!), dayInWeek: String(dateFormatter.string(from: futureDate!)), year: String(incrementedDate.year!), month: String(incrementedDate.month!), id: String(Int.random(in: 10000000000 ..< 100000000000000000)), uid: user!.uid, recurring: "true", weekOfMonth: String(Calendar.current.component(.weekOfMonth, from: futureDate!)))
                let incDictionary = incRecurringEntry.getDictionary()
                do {
                    try db.collection("entries").addDocument(data: incDictionary)
                } catch let error {
                    print("Error writing entry to Firestore: \(error)")
                }
            }
            monthDifference = monthDifference + 1
        }
        monthDifference = monthDifference + 1
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToCategory" {
            let vc = segue.destination as? AddCategoryViewController

            switch typeType {
            case "Category":
                vc?.type = typeType
                vc?.name = editName
                vc?.ID = self.entryID as! String

            case "Source":
                vc?.type = typeType
                vc?.name = editName
                vc?.ID = self.entryID as! String

            default:
                print("User wants to add a category")
                vc?.type = typeType
                vc?.wantToAddCategory = true

            }

        }
    }
}

extension Date {

    static func - (recent: Date, previous: Date) -> (month: Int?, day: Int?, hour: Int?, minute: Int?, second: Int?) {
        let day = Calendar.current.dateComponents([.day], from: previous, to: recent).day
        let month = Calendar.current.dateComponents([.month], from: previous, to: recent).month
        let hour = Calendar.current.dateComponents([.hour], from: previous, to: recent).hour
        let minute = Calendar.current.dateComponents([.minute], from: previous, to: recent).minute
        let second = Calendar.current.dateComponents([.second], from: previous, to: recent).second

        return (month: month, day: day, hour: hour, minute: minute, second: second)
    }

}

extension Date {
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }

    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
}
