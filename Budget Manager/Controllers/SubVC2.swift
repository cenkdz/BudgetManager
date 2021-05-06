//
//  SubVC.swift
//  Budget Manager
//
//  Created by Cenk Donmez on 6.05.2021.
//  Copyright © 2021 CTIS. All rights reserved.
//

import UIKit

class SubVC2: UIViewController,UITableViewDelegate, UITableViewDataSource{

    var entries: [Entry] = []
    var selectedSubCategory = ""
    var categories: [String] = []
    
    var fixedEntries: [Entry] = []
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        fixEntries(entries: entries)
        getCategories()
        setTableView()
        print("Sub is\(selectedSubCategory)")
        dump(entries)
        tableView.reloadData()
        // Do any additional setup after loading the view.
    }
    
    func fixEntries(entries: [Entry]){
        for entry in entries {
            if entry.mainCategory == selectedSubCategory {
                fixedEntries.append(entry)
            }
        }
    }
    
    func calculateTotal(cat: String) -> String{
        var total = 0
        for entry in fixedEntries {
            if entry.category == cat {
                total = total + abs(Int(entry.amount)!)
            }
        }
        
        return String(total)
    }
    
    func getCategories(){
        categories = []
        for entry in fixedEntries{
            let category = entry.category
            if entry.mainCategory == selectedSubCategory {
            
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
    }
    
    @IBAction func backPressed(_ sender: UIButton) {
        goToIncomeGraphVC(senderController: self)
    }
    func setTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.setContentOffset(tableView.contentOffset, animated: false)

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "subCell2", for: indexPath) as! GraphSubCell2
        cell.setEntry(cSubName: categories[indexPath.row], cSubTotal: calculateTotal(cat: categories[indexPath.row]))

        return cell
    }
    
    func goToIncomeGraphVC(senderController: UIViewController) {
        let homeViewController = senderController.storyboard?.instantiateViewController(identifier: "IncomeGraphVC") as? IncomeGraphVC
        senderController.view.window?.rootViewController = homeViewController
        senderController.view.window?.makeKeyAndVisible()
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
