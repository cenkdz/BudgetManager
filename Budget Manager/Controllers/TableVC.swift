//
//  TableVC.swift
//  Budget Manager
//
//  Created by Cenk Donmez on 22.12.2020.
//  Copyright © 2020 CTIS. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase


class TableVC: UITableViewController {
    
    var categories: [Category] = []
    var selectedCategoryName = ""
    var selectedC: String!
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserCategories(completionHandler: { (category_id, category_name, category_icon,uid) in
            let category = Category(categoryID: category_id, categoryName: category_name, categoryIcon: category_icon, uid: uid)
            self.categories.append(category)
        }, uid: user!.uid)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categories.count
    }
    @IBAction func editButtonPressed(_ sender: UIButton) {
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let entry = categories[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as! CategoryCellVC
        cell.setEntry(entry: entry)
        return cell
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
         if (editingStyle == .delete) {
             let entry = categories[indexPath.row]
             deleteUserCategory(selectedEntryID: entry.categoryID)
             categories.remove(at: indexPath.row)
             tableView.reloadData()
         }
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
    
    func getUserCategories(completionHandler:@escaping(String, String, String,String)->(),uid: String){
        categories = []
        db.collection("categories").whereField("uid", isEqualTo: uid)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        let data = document.data()
                        completionHandler (data["category_id"] as! String, data["category_name"] as! String, data["category_icon"] as! String,data["uid"] as! String)
                        self.tableView.reloadData()
                    }
                }
            }
    }
    func deleteUserCategory(selectedEntryID: Any){
        db.collection("categories").whereField("category_id", isEqualTo: selectedEntryID).getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    document.reference.delete()
                }
            }
        }
    }
    
}
