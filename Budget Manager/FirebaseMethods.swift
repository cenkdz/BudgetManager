//
//  FirebaseMethods.swift
//  Budget Manager
//
//  Created by Cenk Dönmez on 31.03.2021.
//  Copyright © 2021 CTIS. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth


class FirebaseMethods: UIViewController{
    
    let helperMethods = HelperMethods()
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser

    func signIn(email: String, password: String, senderController: UIViewController){
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] user, error in
            guard let strongSelf = self else { return }
            if(error != nil) {
                strongSelf.helperMethods.displayAlert(message: "Username or password wrong", title: "Warning",receiverController: senderController)
            }
            else if error == nil{
                UserDefaults.standard.set(Auth.auth().currentUser!.uid, forKey: "user_uid_key")
                UserDefaults.standard.synchronize()
                self?.helperMethods.goToHomeVC(senderController: senderController)
            }
        }
        
    }
    
    func signUp(email: String,password: String,firstName:String,senderController: UIViewController){
        Auth.auth().createUser(withEmail: email, password: password) { authResult, errorUser in
            if(errorUser == nil) {
                let db = Firestore.firestore()
             db.collection("users").addDocument(data: ["firstname": firstName,"uid":authResult!.user.uid,"salary": "","budgetGoal":""]) { (errorDatabase) in
                    if errorDatabase == nil{
                        UserDefaults.standard.set(Auth.auth().currentUser!.uid, forKey: "user_uid_key")
                        UserDefaults.standard.synchronize()
                        self.helperMethods.displayDisappearingAlert(message: "Success", title: "Signup Successful",receiverController: senderController)
                        self.helperMethods.goToUserPreferences(senderController: senderController)
                    }
                    else if errorDatabase != nil {
                        self.helperMethods.displayAlert(message: "Signup completed but an error occurred in saving your firstname. Please check credentials in the settings.", title: "Error in saving credentials",receiverController: senderController)
                    }
                }
            }
            else if (errorUser != nil){
                self.helperMethods.displayDisappearingAlert(message: "Check Credentials", title:"Signup Failed",receiverController: senderController)
            }

        }
    }
    //UserPreferencesVC
    func addSelectedMainCategory(completion: (),selectedCategoryNames:[String]) {
        for category in selectedCategoryNames {
            let category = Category(categoryID: String(Int.random(in: 10000000000 ..< 100000000000000000)), categoryName: category, categoryIcon: "", uid: user!.uid)
            let dictionary = category.getDictionary()
            do {
                try db.collection("categories").addDocument(data: dictionary)
                completion
            } catch let error {
                print("Error writing entry to Firestore: \(error)")
            }
        }
    }
    
    func addPreferences(completion: (),budgetGoal: String,salary: String) {
        let entries = self.db.collection("users")
        entries.whereField("uid", isEqualTo: user!.uid).getDocuments(completion: { querySnapshot, error in
            if let err = error {
                print(err.localizedDescription)
                return
            }
            guard let docs = querySnapshot?.documents else { return }
            for doc in docs {
                let ref = doc.reference
                if Int(budgetGoal)!>0 {
                    ref.updateData(["budgetGoal": budgetGoal])
                }
                ref.updateData(["salary": salary])
                completion
            }
        })
    }
    
    func addSalaryAsIncome(completion: (), salary: String) {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let entry = Entry(type: "Income", category: "Salary", source: "Salary", amount: salary, day: String(Calendar.current.component(.day, from: date)), dayInWeek: String(dateFormatter.string(from: date)), year: String(Calendar.current.component(.year, from: date)), month: String(Calendar.current.component(.month, from: date)), id: String(Int.random(in: 10000000000 ..< 100000000000000000)), uid: user!.uid, recurring: "false",weekOfMonth: String(Calendar.current.component(.weekOfMonth, from: date)))
        let dictionary = entry.getDictionary()
        do {
            try db.collection("entries").addDocument(data: dictionary)
            completion
        } catch let error {
            print("Error writing entry to Firestore: \(error)")
        }
    }
    
    //HomeVC
    
    func getUserEntries(completionHandler: @escaping(String, String, String, String, String, String, String, String, String, String,String) -> (), uid: String,entries: [[Entry]],senderController: UIViewController) {
       // entries = []

        db.collection("entries").whereField("uid", isEqualTo: uid)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    print(uid)
                    for document in querySnapshot!.documents {
                        let data = document.data()
                        completionHandler (data["type"] as! String, data["category"] as! String, data["source"]as! String, data["amount"] as! String, data["day"] as! String, data["dayInWeek"] as! String, data["year"]as! String, data["month"]as! String, data["id"]as! String, data["uid"]as! String, data["recurring"]as! String)                        
                    }
                }
            }
    }
    
    func deleteUserEntry(selectedEntryID: Any) {
        db.collection("entries").whereField("id", isEqualTo: selectedEntryID).getDocuments { (querySnapshot, err) in
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
