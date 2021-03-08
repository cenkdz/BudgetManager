//
//  AddCategoryViewController.swift
//  Budget Manager
//
//  Created by Cenk Donmez on 8.03.2021.
//  Copyright © 2021 CTIS. All rights reserved.
//

import UIKit

class AddCategoryViewController: UIViewController {

    @IBOutlet weak var nameOutlet: UILabel!
    @IBOutlet weak var nameTextOutlet: UITextField!
    var selectedI = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func addPressed(_ sender: UIButton) {
        selectedI = nameTextOutlet.text!
        DispatchQueue.main.async(){
            self.performSegue(withIdentifier: "unwindToADDENTRY", sender: self)
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

}
