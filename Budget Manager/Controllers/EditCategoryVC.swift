//
//  EditCategoryVC.swift
//  Budget Manager
//
//  Created by Cenk Donmez on 23.02.2021.
//  Copyright © 2021 CTIS. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class EditCategoryVC: UIViewController {
    
    let db = Firestore.firestore()

    @IBOutlet weak var newIconButton: UIButton!
    @IBOutlet weak var catName: UITextField!
    var name:String = ""
    var icon:String = ""
    var categoryID: Any!

    @IBOutlet weak var newIconBPressed: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    
    override func viewWillAppear(_ animated: Bool) {
        print("Name is : \(name)")
        catName.text = name
    }
    
    @IBAction func donePressed(_ sender: UIButton) {
        let homevcRef = HomeVC()
        DispatchQueue.main.async {
            self.editCategory(completion: ())
        }
    }
    
    func editCategory(completion: ()){
        let entries = self.db.collection("categories")
        entries.whereField("category_id", isEqualTo: categoryID).getDocuments(completion: { querySnapshot, error in
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
                ref.updateData(["category_name": self.catName.text!])
                ref.updateData(["category_icon": self.icon])
                completion
            }
            self.performSegue(withIdentifier: "goToTableVCAfterEdit", sender: self)

                    
            
        })
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
