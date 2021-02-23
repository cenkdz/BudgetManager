//
//  AddCategoryVC.swift
//  Budget Manager
//
//  Created by CTIS Student on 23.02.2021.
//  Copyright © 2021 CTIS. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class AddCategoryVC: UIViewController {
    var selectedIcon = "Please Select an Icon"
        let db = Firestore.firestore()

    @IBOutlet weak var categoryName: UITextField!
    @IBOutlet weak var iconName: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func donePressed(_ sender: UIButton) {
        
                let user = Auth.auth().currentUser
            let category = Category(categoryID: String(Int.random(in: 10000000000 ..< 100000000000000000)) , categoryName: categoryName.text!, categoryIcon: selectedIcon, uid: user!.uid)
                let dictionary = category.getDictionary()
                if categoryName.text!.isEmpty {
                    displayAlert(message: "Name field can't be empty.", title: "Warning")
                }
        //        else if categoryButtonOutlet.title(for: .normal) == "SELECT CATEGORY"{
        //            displayAlert(message: "Please select a category from the predefined list", title: "Warning")
        //        }
                else{
                do {
                    
                    try db.collection("categories").addDocument(data: dictionary)
                    
                } catch let error {
                    print("Error writing entry to Firestore: \(error)")
                }
                self.performSegue(withIdentifier: "unwindFromAddCategoryVCToTableVC", sender: self)
                }

    }
    
    @IBAction func unwindFromIconListVCToAddCategoryVC(_ sender: UIStoryboardSegue){
        if sender.source is IconListVC {
            if let senderVC = sender.source as? IconListVC{
                selectedIcon = senderVC.seledtedIcon
                iconName.setTitle(selectedIcon, for: .normal)
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
    
    func displayAlert(message: String,title: String) {
        let dialogMessage = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
        })
        dialogMessage.addAction(ok)
        self.present(dialogMessage, animated: true, completion: nil)
        
    }

}
