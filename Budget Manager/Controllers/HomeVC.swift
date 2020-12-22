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
    let db = Firestore.firestore()
    var users: [User] = []
    @IBOutlet weak var welcomeLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        for user in users {
            user.printAll()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if Auth.auth().currentUser != nil {
            // User is signed in.
            // ...
            let user = Auth.auth().currentUser
            getUserDetails(completionHandler: { (firstname, lastname, uid) in
                let user = User(firstname: firstname, lastname: lastname, uid: uid)
                self.users.append(user)
                self.welcomeLabel.text = "Welcome \(firstname)!"
            }, uid: user!.uid)

            
        } else {
            // No user is signed in.
            // ...
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
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
