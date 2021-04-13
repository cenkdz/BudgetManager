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
    let helperMethods = HelperMethods()
    let user = Auth.auth().currentUser

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarOutlet.delegate = self
        tabBarOutlet.selectedItem = tabBarOutlet.items?[3]
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if(item.tag == 0) {
            helperMethods.goToHomeVC(senderController: self)
        } else if(item.tag == 1) {
            helperMethods.goToRecurringEntryVC(senderController: self)
        }else if(item.tag == 2) {
            helperMethods.goToGraphsVC(senderController: self)
        } else if(item.tag == 3) {
            helperMethods.goToSettingsVC(senderController: self)
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
                UserDefaults.standard.removeObject(forKey: "user_uid_key")
                            UserDefaults.standard.synchronize()
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
