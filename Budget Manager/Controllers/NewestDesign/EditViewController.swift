//
//  EditViewController.swift
//  Budget Manager
//
//  Created by Cenk Donmez on 8.03.2021.
//  Copyright © 2021 CTIS. All rights reserved.
//

import UIKit

class EditViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var saveButtonOutlet: UIButton!
    @IBOutlet weak var amountFieldOutlet: UITextField!
    @IBOutlet weak var sourceButtonOutlet: UIButton!
    @IBOutlet weak var categoryButtonOutlet: UIButton!
    var name:String = ""
    var amount:String = ""
    var category:String = ""
    var entryID: Any!
    var selectedButton = ""
    var source = ""
    var categories: [Category] = [Category(categoryID: "1", categoryName: "Home", categoryIcon: "", uid: "6"),Category(categoryID: "2", categoryName: "Car", categoryIcon: "", uid: "6"),Category(categoryID: "3", categoryName: "Health", categoryIcon: "", uid: "6"),Category(categoryID: "3", categoryName: "Self-Care", categoryIcon: "", uid: "6")]
    var sources: [Source] = [Source(sourceID: "1", sourceName: "Salary", sourceIcon: "", uid: "6"),Source(sourceID: "2", sourceName: "Stock Market", sourceIcon: "", uid: "6"),Source(sourceID: "3", sourceName: "Borrowed Money", sourceIcon: "", uid: "6"),Source(sourceID: "3", sourceName: "Cryptocurrency", sourceIcon: "", uid: "6")]

    @IBAction func selectCategoryPressed(_ sender: UIButton) {
        selectedButton = "CategoryButton"
        self.tableView.isHidden = false
        self.tableView.reloadData()
    }
    @IBAction func selectSourcePressed(_ sender: UIButton) {
        selectedButton = "SourceButton"
        self.tableView.isHidden = false
        self.tableView.reloadData()


    }
    @IBAction func savePressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        self.performSegue(withIdentifier: "unwindFromEditToHome", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.isHidden = true
        tableView.delegate = self
        tableView.dataSource = self

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("Name is : \(name)")
        categoryButtonOutlet.setAttributedTitle(NSAttributedString(string: category), for: .normal)
        amountFieldOutlet.text = amount
        sourceButtonOutlet.setAttributedTitle(NSAttributedString(string: source), for: .normal)

         print("Entry ID is \(entryID)")
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! HeaderCellVC
        switch selectedButton {
        case "CategoryButton":
            cell.setEntry(selected: "Categories")
        case "SourceButton":
            cell.setEntry(selected: "Sources")
        default:
            cell.setEntry(selected: "")
 
        }
        
        return cell
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
        cell.setEntry(category: categories[indexPath.row], source: sources[indexPath.row], selectedButton: selectedButton)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NSLog("You selected cell number: \(indexPath.row)!")
        if selectedButton == "CategoryButton" {
            let title = categories[indexPath.row].categoryName
            categoryButtonOutlet.setAttributedTitle((NSAttributedString(string: title)), for: .normal)
        }
        else if selectedButton == "SourceButton" {
            let title = sources[indexPath.row].sourceName
            sourceButtonOutlet.setAttributedTitle((NSAttributedString(string: title)), for: .normal)
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
