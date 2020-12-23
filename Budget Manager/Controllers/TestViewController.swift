//
//  TestViewController.swift
//  Budget Manager
//
//  Created by CTIS Student on 23.12.2020.
//  Copyright © 2020 CTIS. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialButtons
import MaterialComponents.MaterialButtons_Theming
import MaterialComponents.MaterialTextControls_FilledTextAreas
import MaterialComponents.MaterialTextControls_FilledTextFields
import MaterialComponents.MaterialTextControls_OutlinedTextAreas
import MaterialComponents.MaterialTextControls_OutlinedTextFields

class TestViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let estimatedFrame = CGRect(x: 0, y: 100, width: (view.frame.size.width), height: 10)
        let textField = MDCFilledTextField(frame: estimatedFrame)
        textField.label.text = "Firstname"
        textField.placeholder = "Please enter your firstname"
        textField.sizeToFit()
        view.addSubview(textField)
        let estimatedFrame2 = CGRect(x: 0, y: 200, width: (view.frame.size.width), height: 10)
        let textField2 = MDCFilledTextField(frame: estimatedFrame2)
        textField2.label.text = "Lastname"
        textField2.placeholder = "Please enter your lastname"
        textField2.sizeToFit()
        view.addSubview(textField2)
        let estimatedFrame3 = CGRect(x: 0, y: 300, width: (view.frame.size.width), height: 10)
        let textField3 = MDCFilledTextField(frame: estimatedFrame3)
        textField3.label.text = "E-mail"
        textField3.placeholder = "Please enter your e-mail"
        textField3.sizeToFit()
        view.addSubview(textField3)
        let estimatedFrame4 = CGRect(x: 0, y: 400, width: (view.frame.size.width), height: 10)
        let textField4 = MDCFilledTextField(frame: estimatedFrame4)
        textField4.label.text = "Password"
        textField4.placeholder = "Please enter your password"
        textField4.sizeToFit()
        view.addSubview(textField4)
        
        let button = UIButton(frame: CGRect(x: (view.frame.size.width-220)/2, y: 500, width: 220, height: 50))
        button.setTitle("Let's Get Started", for: .normal)
        button.backgroundColor = .systemRed
        button.addTarget(self, action: #selector(didTapAlert), for: .touchUpInside)
        view.addSubview(button)
        
        let button2 = UIButton(frame: CGRect(x: 250, y: 600, width: 110, height: 50))
        button2.setTitle("Log In", for: .normal)
        button2.backgroundColor = .systemYellow
        button2.addTarget(self, action: #selector(didTapActionSheet), for: .touchUpInside)
        
        
        view.addSubview(button2)
        
        let alreadyUserLabel = UILabel(frame: CGRect(x: 30, y: 600, width: 300, height: 50))
        alreadyUserLabel.text = "Already have an account?"
        view.addSubview(alreadyUserLabel)
        
    }
    
    @objc private func didTapAlert() {
        // Present a modal alert
        let alertController = MDCAlertController(title: "Log Out", message: "Would you like to log out?")
        let action = MDCAlertAction(title:"Cancel") { (action) in
            print("OK")
            
        }
        let action2 = MDCAlertAction(title:"Log Out", emphasis: .high) { (action) in
            print("OK")
            
        }
        alertController.addAction(action2)
        alertController.addAction(action)
        
        present(alertController, animated:true, completion: nil)
        
    }
    @objc private func didTapActionSheet() {
        let actionSheet = MDCActionSheetController(title: "Action Sheet",
                                                   message: "Secondary line text")
        actionSheet.backgroundColor = .systemBackground
        actionSheet.titleTextColor = .label
        actionSheet.messageTextColor = .secondaryLabel
        actionSheet.actionTintColor = .label
        actionSheet.actionTextColor = .label
        
        let actionOne = MDCActionSheetAction(title: "Home",
                                             image: UIImage(systemName: "house"),
                                             handler: {_ in print("Home action") })
        let actionTwo = MDCActionSheetAction(title: "Settings",
                                             image: UIImage(systemName: "gear"),
                                             handler: {_ in print("Email action") })
        actionSheet.addAction(actionOne)
        actionSheet.addAction(actionTwo)
        
        present(actionSheet, animated: true, completion: nil)
        
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
