//
//  SettingsVC.swift
//  Budget Manager
//
//  Created by Cenk Donmez on 10.03.2021.
//  Copyright © 2021 CTIS. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import MBCircularProgressBar

class SettingsVC: UIViewController,UITabBarDelegate {
    @IBOutlet weak var tabBarOutlet: UITabBar!
    @IBOutlet weak var progressBar: MBCircularProgressBarView!
    @IBOutlet weak var nameOutlet: UILabel!
    @IBOutlet weak var salaryOutlet: UILabel!
    @IBOutlet weak var budgetGoalOutlet: UILabel!
    @IBOutlet weak var newInputOutlet: UITextField!
    @IBOutlet weak var changeSalaryBOutlet: UIButton!
    @IBOutlet weak var changeSalaryBGOutlet: UIButton!
    @IBOutlet weak var doneButtonOutlet: UIButton!
    let helperMethods = HelperMethods()
    let user = Auth.auth().currentUser
    var userStatus = ""
    
    var newSalary = ""
    var newBudgetGoal = ""
    let db = Firestore.firestore()
    var hunderedPercent = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        getBudgetGoal()
        getSalary()
        tabBarOutlet.delegate = self
        tabBarOutlet.selectedItem = tabBarOutlet.items?[3]
    }
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 5.0) {
            self.progressBar.value = CGFloat(self.hunderedPercent)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        hideNewInput()
    }
    
    func setProgress(){
        
    }
    
    func showNewInput(){
        newInputOutlet.isHidden = false
        doneButtonOutlet.isHidden = false
    }
    
    func hideNewInput(){
        newInputOutlet.isHidden = true
        doneButtonOutlet.isHidden = true
    }
    
    func setDefaultView(){
        hideNewInput()
        changeSalaryBOutlet.isHidden = false
        changeSalaryBGOutlet.isHidden = false
        changeSalaryBOutlet.setTitle("Change", for: .normal)
        changeSalaryBGOutlet.setTitle("Change", for: .normal)
        newInputOutlet.text = ""
    }

    @IBAction func changeSalaryButtonPressed(_ sender: UIButton) {
        changeSalaryBGOutlet.isHidden = true
        newInputOutlet.text = salaryOutlet.text
        switch changeSalaryBOutlet.title(for: .normal) {
        case "Change":
        changeSalaryBOutlet.setTitle("Cancel", for: .normal)
        showNewInput()
        case "Cancel":
        changeSalaryBOutlet.setTitle("Change", for: .normal)
        hideNewInput()
        changeSalaryBGOutlet.isHidden = false
        default:
            print("Error")
        }

    }
    
    @IBAction func changeBudgetGoalButtonPressed(_ sender: UIButton) {
        changeSalaryBOutlet.isHidden = true
        newInputOutlet.text = budgetGoalOutlet.text
        switch changeSalaryBGOutlet.title(for: .normal) {
        case "Change":
        changeSalaryBGOutlet.setTitle("Cancel", for: .normal)
        showNewInput()
        case "Cancel":
        changeSalaryBGOutlet.setTitle("Change", for: .normal)
        hideNewInput()
        changeSalaryBOutlet.isHidden = false
        default:
            print("Error")
        }
    }
    @IBAction func donePressed(_ sender: UIButton) {
        
        if changeSalaryBOutlet.isHidden {
            newBudgetGoal = newInputOutlet.text!
            editBudgetGoal(completion: ())
            setDefaultView()
                getSalary()
            budgetGoalOutlet.text = newBudgetGoal

        }
        else if changeSalaryBGOutlet.isHidden{
            newSalary = newInputOutlet.text!
            editSalary(completion: ())
            setDefaultView()
            getBudgetGoal()
            salaryOutlet.text = newSalary

        }
    }

    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if(item.tag == 0) {
            helperMethods.goToHomeVC(senderController: self)
        } else if(item.tag == 1) {
            helperMethods.goToTableRecurringVC(senderController: self)
        }else if(item.tag == 2) {
            helperMethods.goToGraphsVC(senderController: self)
        } else if(item.tag == 3) {
            helperMethods.goToSettingsVC(senderController: self)
        }
    }
    
    @IBAction func logOutButtonPressed(_ sender: UIButton) {
        let firebaseAuth = Auth.auth()
             do {
               try firebaseAuth.signOut()
                UserDefaults.standard.removeObject(forKey: "user_uid_key")
                            UserDefaults.standard.synchronize()
                helperMethods.goToLandingVC(senderController: self)
             } catch let signOutError as NSError {
               print ("Error signing out: %@", signOutError)
             }
    }
    func editSalary(completion: ()) {
        
        let users = self.db.collection("users")
        users.whereField("uid", isEqualTo: user!.uid).getDocuments(completion: { querySnapshot, error in
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

                ref.updateData(["salary": self.newSalary])
                completion
            }
//            DispatchQueue.main.async {
//                self.performSegue(withIdentifier: "unwindFromAllEditingVC", sender: self)
//            }
            
        })
    }
    
    func editBudgetGoal(completion: ()) {
        
        let users = self.db.collection("users")
        users.whereField("uid", isEqualTo: user!.uid).getDocuments(completion: { querySnapshot, error in
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

                ref.updateData(["budgetGoal": self.newBudgetGoal])
                completion
            }
//            DispatchQueue.main.async {
//                self.performSegue(withIdentifier: "unwindFromAllEditingVC", sender: self)
//            }
            
        })
    }
    
    func getBudgetGoal(){
        db.collection("users").whereField("uid", isEqualTo: user!.uid)
            .getDocuments() { [self] (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        let data = document.data()
                        self.budgetGoalOutlet.text = data["budgetGoal"] as! String
                    }
                    self.hunderedPercent = Int(self.budgetGoalOutlet.text!)!
                    self.userStatus = UserDefaults.standard.string(forKey: "userStatus")!
                    
                    progressBar.value = CGFloat((Int(userStatus)!*100)/Int(self.budgetGoalOutlet.text!)!)
                    
                    print(Int(userStatus)!*100)
                    
                    print(hunderedPercent)
                    
                    print(CGFloat((Int(userStatus)!*100)/Int(budgetGoalOutlet.text!)!))
                }
            }
    }
    
    func getSalary(){
        db.collection("users").whereField("uid", isEqualTo: user!.uid)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        let data = document.data()
                        self.salaryOutlet.text = data["salary"] as! String
                    }
                }
            }
    }
    

}
