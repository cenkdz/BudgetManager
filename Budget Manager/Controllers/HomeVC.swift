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
    
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if Auth.auth().currentUser != nil {
            // User is signed in.
            let user = Auth.auth().currentUser
            getUserDetails(completionHandler: { (firstname, lastname, uid) in
                let user = User(firstname: firstname, lastname: lastname, uid: uid)
                self.users.append(user)
                self.welcomeLabel.text = "Welcome \(firstname)!"
            }, uid: user!.uid)

            getUserEntries(completionHandler: { (category, entryName, entryAmount, uid, entryDate, entryType,entryID) in
                let entry = UserEntry(category: category, entryName: entryName, entryAmount: entryAmount, uid: uid, entryDate: entryDate, entryType: entryType, entryID: entryID)
                self.userEntries.append(entry)
                for entry in self.userEntries {
                    print(entry.entryName)
                }
            }, uid: user!.uid)

        } else {
            // No user is signed in.
            goToLandingVC()
        }
        
    }
    
    func goToLandingVC() {
        let homeViewController = storyboard?.instantiateViewController(identifier: "LandingVC") as? LandingVC
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
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
    
}

extension HomeVC: UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return userEntries.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let entry = userEntries[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "entryCell", for: indexPath) as! EntryCellVC
        
        cell.setEntry(entry: entry)
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if (editingStyle == .delete) {
                let entry = userEntries[indexPath.row]
                deleteUserEntry(selectedEntryID: entry.entryID)
                userEntries.remove(at: indexPath.row)
                tableView.reloadData()

            }
            
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
}
