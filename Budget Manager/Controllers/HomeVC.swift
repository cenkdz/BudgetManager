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


    
    //var ref: DatabaseReference!

    //var ref = Database.database().reference()
    override func viewDidLoad() {
        super.viewDidLoad()
        let ref = Database.database().reference(withPath: "user-info")
        var dataDictionary: [String: Any] = [:]
        dataDictionary["First Name"] = "Cenk"
        dataDictionary["Last name"] =  "Donmez"
        ref.setValue(dataDictionary)

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {

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
