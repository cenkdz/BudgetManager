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
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    var selectedI = ""
    var type = "Category"
    var name = ""
    var senderController = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        type = "Category"
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
        
        
        
        switch senderController {
        case "Income":
            
            self.performSegue(withIdentifier: "unwindToADDENTRY", sender: self)
            
            
        case "Expense":
            DispatchQueue.main.async(){
                
                self.performSegue(withIdentifier: "unwindToADDEXPENSE", sender: self)
            }
        case "Edit":
            DispatchQueue.main.async(){
                
                self.performSegue(withIdentifier: "unwindToEDIT", sender: self)
            }
            
            
        default:
            print("Error")
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
