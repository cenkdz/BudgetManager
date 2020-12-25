//
//  EditVC.swift
//  Budget Manager
//
//  Created by Cenk Donmez on 25.12.2020.
//  Copyright © 2020 CTIS. All rights reserved.
//

import UIKit

class EditVC: UIViewController {
    
    var name:String = ""
    var amount:String = ""
    var category:String = ""
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var amountTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("Name is : \(name)")
        
        nameTextField.text = name
        amountTextField.text = amount
        self.view.reloadInputViews()
    }
    
    
    @IBAction func newCatPressed(_ sender: UIButton) {
    }
    
    @IBAction func donePressed(_ sender: UIButton) {
    }
    
}
