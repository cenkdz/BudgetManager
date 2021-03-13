//
//  EditViewController.swift
//  Budget Manager
//
//  Created by Cenk Donmez on 8.03.2021.
//  Copyright © 2021 CTIS. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class EditViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {



    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var saveButtonOutlet: UIButton!
    @IBOutlet weak var amountFieldOutlet: UITextField!
    @IBOutlet weak var sourceButtonOutlet: UIButton!
    @IBOutlet weak var categoryButtonOutlet: UIButton!
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser


    var amount: String = ""
    var category: String = ""
    var entryID: Any!
    var selectedButton = ""
    var selectedType = ""
    var id = ""
    var source = ""
    var editName = ""
    var typeType = ""
    var addedText = ""
    let group = DispatchGroup()



    var categories: [Category] = []
    var sources: [Source] = []

    @IBAction func selectCategoryPressed(_ sender: UIButton) {
        selectedButton = "CategoryButton"
        self.getUserCategories(completionHandler: { (categoryID, categoryIcon, categoryName, uid) in
            let category = Category(categoryID: categoryID, categoryName: categoryName, categoryIcon: categoryIcon, uid: uid)
            self.categories.append(category)
        }, uid: self.user!.uid)
        self.tableView.isHidden = false
        self.tableView.reloadData()
    }

    @IBAction func selectSourcePressed(_ sender: UIButton) {

        selectedButton = "SourceButton"
        self.getUserSources(completionHandler: { (sourceID, sourceIcon, sourceName, uid) in
            let source = Source(sourceID: sourceID, sourceName: sourceName, sourceIcon: sourceIcon, uid: uid)
            self.sources.append(source)
        }, uid: self.user!.uid)
        self.tableView.isHidden = false
        self.tableView.reloadData()



    }
    @IBAction func savePressed(_ sender: UIButton) {
        DispatchQueue.main.async {
            self.editEntry(completion: ())
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.isHidden = true
        tableView.delegate = self
        tableView.dataSource = self

    }

    override func viewWillAppear(_ animated: Bool) {
        categoryButtonOutlet.setAttributedTitle(NSAttributedString(string: category), for: .normal)
        amountFieldOutlet.text = amount
        sourceButtonOutlet.setAttributedTitle(NSAttributedString(string: source), for: .normal)

        print("Entry ID is \(entryID)")
    }

    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    @IBAction func unwindToEDIT(_ sender: UIStoryboardSegue) {
        if sender.source is AddCategoryViewController {
            if let senderVC = sender.source as? AddCategoryViewController {

                addedText = senderVC.selectedI
                selectedType = senderVC.type
                switch selectedType {
                case "Category":
                    categories.append(Category(categoryID: "113", categoryName: addedText, categoryIcon: "", uid: "5"))
                case "Source":
                    sources.append(Source(sourceID: "113", sourceName: addedText, sourceIcon: "", uid: "123321"))
                default:
                    print("Error")
                }

                tableView.reloadData()
            }
        }
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {

        let delete = UITableViewRowAction(style: .default, title: "Delete") { (action, indexPath) in
            switch self.selectedButton {
            case "CategoryButton":
                let entry = self.categories[indexPath.row]
                self.id = entry.categoryID
                self.deleteUserCategory(selectedEntryID: entry.categoryID)

                var changedEntries = self.categories
                changedEntries.remove(at: indexPath.row)
                self.categories = changedEntries
                tableView.reloadData()
            case "SourceButton":
                let entry = self.sources[indexPath.row]
                self.id = entry.sourceID
                var changedEntries = self.sources
                changedEntries.remove(at: indexPath.row)
                self.sources = changedEntries
            default:
                print("error")
            }

            tableView.reloadData()

        }
        delete.backgroundColor = UIColor.red

        let edit = UITableViewRowAction(style: .default, title: "Edit") { (action, indexPath) in
            switch self.selectedButton {
            case "CategoryButton":
                let entry = self.categories[indexPath.row]
                self.editName = entry.categoryName

                self.typeType = "Category"



            case "SourceButton":
                let entry = self.sources[indexPath.row]
                self.editName = entry.sourceName

                self.typeType = "Source"


            default:
                print("ERRROR")
            }
            DispatchQueue.main.async() {
                self.performSegue(withIdentifier: "goAndEdEdit", sender: self)
            }
        }
        edit.backgroundColor = UIColor(red: 0.13, green: 0.17, blue: 0.40, alpha: 1.00)

        //edit put back
        return [delete, edit]
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "goAndEdEdit" {
            let vc = segue.destination as? AddCategoryViewController
            vc?.name = editName
            vc?.ID = id
            vc?.type = typeType

        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        switch selectedButton {
        case "CategoryButton":
            return categories.count
        case "SourceButton":
            return sources.count
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch selectedButton {
        case "CategoryButton":
            return "Categories"
        case "SourceButton":
            return "Sources"
        default:
            return ""
        }

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        var cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CategoryCellVC
        if selectedButton == "CategoryButton" {
            cell.setCategories(category: categories[indexPath.row])
        }
        else if selectedButton == "SourceButton" {
            cell.setSources(source: sources[indexPath.row])

        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NSLog("You selected cell number: \(indexPath.row)!")
        if selectedButton == "CategoryButton" {
            let title = categories[indexPath.row].categoryName
            categoryButtonOutlet.setAttributedTitle((NSAttributedString(string: title)), for: .normal)
        }
        else if selectedButton == "SourceButton" {
            let title = sources[indexPath.row].sourceName
            sourceButtonOutlet.setAttributedTitle((NSAttributedString(string: title)), for: .normal)
        }
    }

    func editEntry(completion: ()) {
        let entries = self.db.collection("entries")
        entries.whereField("id", isEqualTo: entryID).getDocuments(completion: { querySnapshot, error in
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
                ref.updateData(["amount": self.amountFieldOutlet.text])
                ref.updateData(["category": String(self.categoryButtonOutlet.currentAttributedTitle!.string)])
                ref.updateData(["source": String(self.sourceButtonOutlet.currentAttributedTitle!.string)])

                completion
            }
            self.performSegue(withIdentifier: "unwindFromEditToHome", sender: self)


        })
    }

    func getUserCategories(completionHandler: @escaping(String, String, String, String) -> (), uid: String) {
        categories = []
        db.collection("categories").whereField("uid", isEqualTo: uid)
            .getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    completionHandler (data["categoryID"] as! String, data["categoryIcon"] as! String, data["categoryName"] as! String, data["uid"] as! String)
                    self.tableView.reloadData()
                }
            }
        }
    }
    func getUserSources(completionHandler: @escaping(String, String, String, String) -> (), uid: String) {
        sources = []
        db.collection("sources").whereField("uid", isEqualTo: uid)
            .getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    completionHandler (data["sourceID"] as! String, data["sourceIcon"] as! String, data["sourceName"] as! String, data["uid"] as! String)
                    self.tableView.reloadData()
                }
            }
        }
    }
    func deleteUserCategory(selectedEntryID: Any) {
        db.collection("categories").whereField("categoryID", isEqualTo: selectedEntryID).getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    document.reference.delete()
                }
            }
        }
    }
}
