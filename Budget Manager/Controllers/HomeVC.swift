//
//  HomeVC.swift
//  Budget Manager
//
//  Created by CTIS Student on 18.12.2020.
//  Copyright © 2020 CTIS. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class HomeVC: UIViewController {
    var entries: [Entry] = []
    let db = Firestore.firestore()
    var users: [User] = []
    var userEntries: [UserEntry] = []
    var selectedCategories: [Category] = []
    var editName = ""
    var editCategory = ""
    var editAmount = ""
    var selectedEntryID: Any!
    
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAll(completion: ())

    }
    @IBAction func unwindFromTestAddVC(_ sender: UIStoryboardSegue){
        if sender.source is TestAddEntry {
            if let senderVC = sender.source as? TestAddEntry{
                print("Came from AddVC")
            }
                    DispatchQueue.main.async {
                        self.getAll(completion: ())
                
            }
            tableView.reloadData()
            
        }
    }
    
    @IBAction func unwindFromEditVC(_ sender: UIStoryboardSegue){
        if sender.source is EditVC {
            if let senderVC = sender.source as? EditVC{
                print("Came from EditVC")
            }
                    DispatchQueue.main.async {
                        self.getAll(completion: ())
                
            }
            tableView.reloadData()
        }
    }
    @objc func editButtonPressed(_ sender: UIButton) {
      
            let indexPathRow = sender.tag
            self.editName = self.userEntries[indexPathRow].entryName
            self.editAmount = self.userEntries[indexPathRow].entryAmount as! String
            self.editCategory = self.userEntries[indexPathRow].category
            self.selectedEntryID = self.userEntries[indexPathRow].entryID

            self.performSegue(withIdentifier: "goToEditVC", sender: self)
        
    }
    
    
    func goToLandingVC() {
        let homeViewController = storyboard?.instantiateViewController(identifier: "TestLanding") as? TestLanding
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
    
    @IBAction func signOutButtonPressed(_ sender: UIButton) {
        
            let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
            goToLandingVC()
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
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
    func getUserEntries(completionHandler:@escaping(String, String, Any,String,Any,String,Any)->(),uid: String){
        userEntries = []
        db.collection("entries").whereField("uid", isEqualTo: uid)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        let data = document.data()
                        completionHandler (data["category"] as! String, data["entryName"] as! String, data["entryAmount"], data["uid"] as! String, data["entryDate"], data["entryType"] as! String, data["entryID"])
                        self.tableView.reloadData()
                        
                    }
                }
            }
    }
    
    func deleteUserEntry(selectedEntryID: Any){
        db.collection("entries").whereField("entryID", isEqualTo: selectedEntryID).getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    document.reference.delete()
                }
            }
        }
    }
    
    func getAll(completion: ()){
        if Auth.auth().currentUser != nil {
            // User is signed in.
            let user = Auth.auth().currentUser
            getUserDetails(completionHandler: { (firstname, lastname, uid) in
                let user = User(firstname: firstname, lastname: lastname, uid: uid)
                self.users.append(user)
                self.welcomeLabel.text = "Welcome \(firstname)!"
            }, uid: user!.uid)

                self.getUserEntries(completionHandler: { (category, entryName, entryAmount, uid, entryDate, entryType,entryID) in
                let entry = UserEntry(category: category, entryName: entryName, entryAmount: entryAmount, uid: uid, entryDate: entryDate, entryType: entryType, entryID: entryID)
                self.userEntries.append(entry)
            }, uid: user!.uid)
            
            completion
            tableView.reloadData()
            
        } else {
            // No user is signed in.
            goToLandingVC()
        }
    }
    
}

extension HomeVC: UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return userEntries.count
        }
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let entry = userEntries[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "entryCell", for: indexPath) as! EntryCellVC
        cell.editButtonOutlet.addTarget(self, action: #selector(self.editButtonPressed(_:)), for: .touchUpInside)
        cell.editButtonOutlet.tag = indexPath.row
        cell.setEntry(entry: entry)

        if entry.entryType == "Expense" {
            cell.backgroundColor = UIColor(hex: "#B00020ff")
            cell.categoryIcon.image = #imageLiteral(resourceName: "cost-reduction-computer-icons-finance-money-others-1")
        }
        else{
            cell.backgroundColor = UIColor(hex: "#3c8c3fff")
            cell.categoryIcon.image = #imageLiteral(resourceName: "22-220911_coin-clipart-expense-save-money-flat-icon-png.png-1")
        }
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            let entry = userEntries[indexPath.row]
            deleteUserEntry(selectedEntryID: entry.entryID)
            userEntries.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "goToEditVC" {
            let vc = segue.destination as? EditVC
            print("DATA ON PREPARE\(editName),\(editAmount),\(editCategory)")
            vc?.name = editName
            vc?.amount = editAmount
            vc?.category = editCategory
            print("ID COMING FROM HOMEVC\(self.selectedEntryID)")
            vc?.entryID = selectedEntryID
        }
    }
}
