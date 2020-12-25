//
//  TableVC.swift
//  Budget Manager
//
//  Created by Cenk Donmez on 22.12.2020.
//  Copyright © 2020 CTIS. All rights reserved.
//

import UIKit

class TableVC: UITableViewController {
    
    var categories: [Category] = []
    var selectedCategoryName = ""
    var selectedC: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categories = createArray()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        print(selectedC)
    }
    
    func createArray() -> [Category] {
        
        var tempEntries: [Category] = []
        let category1 = Category(categoryIcon: #imageLiteral(resourceName: "coins-512"), categoryName: "Car")
        let category2 = Category(categoryIcon: #imageLiteral(resourceName: "coins-512"), categoryName: "Health")
        let category3 = Category(categoryIcon: #imageLiteral(resourceName: "coins-512"), categoryName: "Clothes")
        let category4 = Category(categoryIcon: #imageLiteral(resourceName: "coins-512"), categoryName: "Entertaintment")
        
        
        tempEntries.append(category1)
        tempEntries.append(category2)
        tempEntries.append(category3)
        tempEntries.append(category4)
        
        return tempEntries
        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categories.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let entry = categories[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as! CategoryCellVC
        cell.setEntry(entry: entry)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCategory = categories[indexPath.row]
        selectedC = selectedCategory.categoryName
        print(selectedC)
        self.performSegue(withIdentifier: "unwindFromTVC", sender: self)
        self.performSegue(withIdentifier: "unwindFromTVCToEdit", sender: self)


    }
    
    func goToAddIncomeExpenseVC(catName: String) {
        let homeViewController = storyboard?.instantiateViewController(identifier: "AddIncomeExpenseVC") as? AddIncomeExpenseVC
        homeViewController?.catName = catName
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
    
}
