//
//  SettingsVC.swift
//  Budget Manager
//
//  Created by Cenk Donmez on 10.03.2021.
//  Copyright © 2021 CTIS. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController,UITabBarDelegate {
    @IBOutlet weak var tabBarOutlet: UITabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarOutlet.delegate = self

        tabBarOutlet.selectedItem = tabBarOutlet.items?[2]


        // Do any additional setup after loading the view.
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if(item.tag == 0) {
            goToHomeVC()
        } else if(item.tag == 1) {
            print("Statistics Selected")
        } else if(item.tag == 2) {
            print("Settings Selected")
        }
    }
    func goToHomeVC() {
        let homeViewController = storyboard?.instantiateViewController(identifier: "HomeViewController") as? HomeViewController
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
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
