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

class SettingsVC: UIViewController,UITabBarDelegate {
    @IBOutlet weak var tabBarOutlet: UITabBar!
    
    let user = Auth.auth().currentUser

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarOutlet.delegate = self
        tabBarOutlet.selectedItem = tabBarOutlet.items?[3]
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if(item.tag == 0) {
            goToHomeVC()
        } else if(item.tag == 1) {
            goToTableRecurringVC()
        }else if(item.tag == 2) {
            print("Statistics Selected")
        } else if(item.tag == 3) {
            print("Settings Selected")
        }
    }
    func goToLandingVC() {
        let homeViewController = storyboard?.instantiateViewController(identifier: "LandingVC") as? LandingVC
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
    func goToTableRecurringVC() {
        let homeViewController = storyboard?.instantiateViewController(identifier: "TableRecurringVC") as? TableRecurringVC
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
    func goToHomeVC() {
        let homeViewController = storyboard?.instantiateViewController(identifier: "HomeViewController") as? HomeViewController
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
    @IBAction func logOutButtonPressed(_ sender: UIButton) {
        let firebaseAuth = Auth.auth()
             do {
               try firebaseAuth.signOut()
                 goToLandingVC()
             } catch let signOutError as NSError {
               print ("Error signing out: %@", signOutError)
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
