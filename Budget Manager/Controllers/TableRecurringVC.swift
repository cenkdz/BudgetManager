//
//  TableRecurringVC.swift
//  Budget Manager
//
//  Created by Cenk Donmez on 11.03.2021.
//  Copyright © 2021 CTIS. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class TableRecurringVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UITabBarDelegate {

    @IBOutlet weak var tabBarOutlet: UITabBar!
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser
    var entries: [[Entry]] = [[]]

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getUserRecurringEntries(completionHandler: { (type, category, source, amount, day, dayInWeek, year, month, id, uid, recurring) in
            let entry = Entry(type: type, category: category, source: source, amount: amount, day: String(day), dayInWeek: dayInWeek, year: year, month: month, id: id, uid: uid, recurring: recurring)
            self.entries.append([entry])
        }, uid: self.user!.uid)
        tableView.delegate = self
        tableView.dataSource = self
        tabBarOutlet.delegate = self
        tabBarOutlet.selectedItem = tabBarOutlet.items?[1]
        tableView.reloadData()
    }
    func goToHomeVC() {
        let homeViewController = storyboard?.instantiateViewController(identifier: "HomeViewController") as? HomeViewController
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
    func goToSettingsVC() {
        let homeViewController = storyboard?.instantiateViewController(identifier: "SettingsVC") as? SettingsVC
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if(item.tag == 0) {
            goToHomeVC()
        } else if(item.tag == 1) {
            print("Recurring Selected")
        } else if(item.tag == 2) {
            print("Statistics Selected")
        }
        else if(item.tag == 3) {
            goToSettingsVC()
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableRecurringCellVC
        cell.categorySourceOutlet.text = "Section \(indexPath.section) Row \(indexPath.row)"
        let entry = entries[indexPath.row]
        cell.setEntry(entries: entry)
        return cell
    }

    func getUserRecurringEntries(completionHandler: @escaping(String, String, String, String, String, String, String, String, String, String, String) -> (), uid: String) {
        entries = []
        db.collection("entries").whereField("uid", isEqualTo: uid).whereField("recurring", isEqualTo: "true")
            .getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                print(uid)
                for document in querySnapshot!.documents {
                    let data = document.data()
                    dump(data)
                    completionHandler (data["type"] as! String, data["category"] as! String, data["source"]as! String, data["amount"] as! String, data["day"] as! String, data["dayInWeek"] as! String, data["year"]as! String, data["month"]as! String, data["id"]as! String, data["uid"]as! String, data["recurring"]as! String)
                    self.tableView.reloadData()
                }
            }
        }
    }
}

extension UITableView {

    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
        messageLabel.sizeToFit()

        self.backgroundView = messageLabel
        self.separatorStyle = .none
    }

    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}
