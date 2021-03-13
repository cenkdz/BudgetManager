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
    var type = ""
    var name = ""
    var wantToAddCategory = false
    var ID = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        if wantToAddCategory != true {
            segmentedControl.isUserInteractionEnabled = false
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if wantToAddCategory != true {
            segmentedControl.isUserInteractionEnabled = false
        }
        
        if type == "Add"{
            type = "Category"
        }
        
        switch type {
        case "Category":
            segmentedControl.selectedSegmentIndex = 0
            
        case "Source":
            segmentedControl.selectedSegmentIndex = 1
            
        default:
            segmentedControl.selectedSegmentIndex = 0
        }
        nameTextOutlet.text! = name
        
        
    }
    @IBAction func onChange(_ sender: UISegmentedControl) {
        type = segmentedControl.titleForSegment(at: segmentedControl.selectedSegmentIndex)!
        
        print(type)
    }
    
    
    @IBAction func addPressed(_ sender: UIButton) {
        print("TYPE OIS")
        print(type)
        if type == "Category" && wantToAddCategory == false{
            DispatchQueue.main.async {
                self.editCategory(completion: ())
            }
        } else if type == "Source" && wantToAddCategory == false{
            DispatchQueue.main.async {
                self.editSource(completion: ())
            }
        }
        else if wantToAddCategory == true {
            
            switch type {
            case "Category":
                DispatchQueue.main.async {
                self.addCategory()
                }
            case "Source":
                DispatchQueue.main.async {
                self.addSource()
                }
            default:
                print("Error adding categories/sources")
            }
            
        }
    }
    
    func displayAlert(message: String,title: String) {
        let dialogMessage = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
        })
        dialogMessage.addAction(ok)
        self.present(dialogMessage, animated: true, completion: nil)
        
    }
    
    
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
    
    func addCategory(){
        let user = Auth.auth().currentUser
        let category = Category(categoryID: String(Int.random(in: 10000000000 ..< 100000000000000000)), categoryName: nameTextOutlet.text!, categoryIcon: "", uid: user!.uid)
        let dictionary = category.getDictionary()
        if nameTextOutlet.text!.isEmpty {
            displayAlert(message: "Name field can't be empty.", title: "Warning")
        }
        else{
            do {
                try db.collection("categories").addDocument(data: dictionary)
                
            } catch let error {
                print("Error writing entry to Firestore: \(error)")
            }
            self.performSegue(withIdentifier: "unwindToAllEditingVC", sender: self)
        }
    }
    
    func addSource(){
        let user = Auth.auth().currentUser
        let source = Source(sourceID: String(Int.random(in: 10000000000 ..< 100000000000000000)), sourceName: nameTextOutlet.text!, sourceIcon: "", uid: user!.uid)
        let dictionary = source.getDictionary()
        if nameTextOutlet.text!.isEmpty {
            displayAlert(message: "Name field can't be empty.", title: "Warning")
        }
        else{
            do {
                try db.collection("sources").addDocument(data: dictionary)
                
            } catch let error {
                print("Error writing entry to Firestore: \(error)")
            }
            self.performSegue(withIdentifier: "unwindToAllEditingVC", sender: self)
        }
        
        
    }
    
}
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
