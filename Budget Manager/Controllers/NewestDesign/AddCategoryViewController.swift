//
//  AddCategoryViewController.swift
//  Budget Manager
//
//  Created by Cenk Donmez on 8.03.2021.
//  Copyright © 2021 CTIS. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class AddCategoryViewController: UIViewController {
    
    @IBOutlet weak var nameOutlet: UILabel!
    @IBOutlet weak var nameTextOutlet: UITextField!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    let db = Firestore.firestore()
    
    var selectedI = ""
    var type = "Category"
    var name = ""
    var ID = ""
    var senderController = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        switch type {
        case "Category":
            segmentedControl.selectedSegmentIndex = 0
            
        case "Source":
            segmentedControl.selectedSegmentIndex = 1
            
        default:
            print("Error")
        }
        nameTextOutlet.text! = name
        
        
    }
    @IBAction func onChange(_ sender: UISegmentedControl) {
        type = segmentedControl.titleForSegment(at: segmentedControl.selectedSegmentIndex)!
        
        print(type)
    }
    
    
    @IBAction func addPressed(_ sender: UIButton) {
        selectedI = nameTextOutlet.text!
        
        
        switch type {
        case "Category":
            DispatchQueue.main.async {
                self.editCategory(completion: ())
            }
        case "Source":
            DispatchQueue.main.async {
                self.editSource(completion: ())
            }
        default:
            print("Error editing!")
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
    func editCategory(completion: ()){
        let entries = self.db.collection("categories")
        entries.whereField("categoryID", isEqualTo: ID).getDocuments(completion: { querySnapshot, error in
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
                ref.updateData(["categoryName": self.nameTextOutlet.text!])
                completion
            }

            self.performSegue(withIdentifier: "unwindToAllEditingVC", sender: self)

            
            
        })
    }
    func editSource(completion: ()){
        let entries = self.db.collection("sources")
        entries.whereField("sourceID", isEqualTo: ID).getDocuments(completion: { querySnapshot, error in
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
                ref.updateData(["sourceName": self.nameTextOutlet.text!])
                completion
            }
               self.performSegue(withIdentifier: "unwindToAllEditingVC", sender: self)
            
            
        })
    }
    
}
