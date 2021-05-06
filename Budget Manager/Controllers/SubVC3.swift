//
//  SubVC3.swift
//  Budget Manager
//
//  Created by Cenk Donmez on 6.05.2021.
//  Copyright © 2021 CTIS. All rights reserved.
//

import UIKit

class SubVC3: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    var entries: [[Entry]] = [[]]

    @IBOutlet weak var tableView: UITableView!
    var selectedSubCategory = ""
    @IBOutlet weak var subName: UILabel!
    @IBOutlet weak var subTotal: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        print(selectedSubCategory)
        dump(entries)
        // Do any additional setup after loading the view.
    }
    

    @IBAction func backPressed(_ sender: UIButton) {
        goToRecurringGraphVC(senderController: self)
    }
    
    func setTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.setContentOffset(tableView.contentOffset, animated: false)

    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "subCell3", for: indexPath) as! GraphCell3

        return cell
    }
    
    func goToRecurringGraphVC(senderController: UIViewController) {
        let homeViewController = senderController.storyboard?.instantiateViewController(identifier: "RecurringGraphVC") as? RecurringGraphVC
        senderController.view.window?.rootViewController = homeViewController
        senderController.view.window?.makeKeyAndVisible()
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
