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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categories = createArray()
        
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
        print(123123)
        let selectedCategory = categories[indexPath.row]
        if let viewController = storyboard?.instantiateViewController(identifier: "AddIncomeExpenseVC") as? AddIncomeExpenseVC {
            goToAddIncomeExpenseVC(catName: selectedCategory.categoryName)
//            viewController.catName = selectedCategory.categoryName
//            self.present(viewController, animated: true) {
//                viewController.catName = selectedCategory.categoryName
//
//            }
        }
    }
    
    func goToAddIncomeExpenseVC(catName: String) {
        let homeViewController = storyboard?.instantiateViewController(identifier: "AddIncomeExpenseVC") as? AddIncomeExpenseVC
        homeViewController?.catName = catName
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
