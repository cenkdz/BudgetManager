//
//  EditVC.swift
//  Budget Manager
//
//  Created by Cenk Donmez on 25.12.2020.
//  Copyright © 2020 CTIS. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class EditVC: UIViewController {
    let db = Firestore.firestore()

    var name:String = ""
    var amount:String = ""
    var category:String = ""
    var entryID: Any!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var amountTextField: UITextField!
    
    @IBOutlet weak var categorySelectButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func unwindFromTableVCToEditVC(_ sender: UIStoryboardSegue){
        if sender.source is TableVC {
            if let senderVC = sender.source as? TableVC{
                category = senderVC.selectedC
                print(category)
                categorySelectButton.setTitle(category, for: .normal)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("Name is : \(name)")
        
        nameTextField.text = name
        amountTextField.text = amount
         print("Entry ID is \(entryID)")
    }
    
    
    @IBAction func newCatPressed(_ sender: UIButton) {
    }
    
    @IBAction func donePressed(_ sender: UIButton) {
        let homevcRef = HomeVC()
        DispatchQueue.main.async {
            self.editEntry(completion: ())
        }

    }
    
    func editEntry(completion: ()){
        let entries = self.db.collection("entries") //self.db points to *my* firestore
        entries.whereField("entryID", isEqualTo: entryID).getDocuments(completion: { querySnapshot, error in
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
                ref.updateData(["entryName": self.nameTextField.text])
                ref.updateData(["entryAmount": self.amountTextField.text])
                completion
            }
            self.performSegue(withIdentifier: "goToHomeAfterEdit", sender: self)

                    
            
        })
    }
    }
