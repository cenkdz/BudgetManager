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

class Test2: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let estimatedFrame = CGRect(x: 100, y: 400, width: (self.view.frame.width)/2, height: 50)
        let estimatedFrame2 = CGRect(x: 100, y: 500, width: (self.view.frame.width)/2, height: 50)
        let textField = MDCFilledTextField(frame: estimatedFrame)
        let textField2 = MDCFilledTextField(frame: estimatedFrame2)
        
        textField.label.text = "E-MAIL"
        textField.textColor = UIColor.red
        textField.backgroundColor = .systemGray
        textField.sizeToFit()

        textField2.label.text = "PASSWORD"
        textField2.sizeToFit()
        
        view.addSubview(textField)
        view.addSubview(textField2)
        
        let button = UIButton(frame: CGRect(x: (view.frame.size.width-220)/2, y: 600, width: 220, height: 50))
        button.setTitle("Log In", for: .normal)
        button.backgroundColor = .systemYellow
        button.addTarget(self, action: #selector(didTapAlert), for: .touchUpInside)
        button.setTitleColor(.black, for: .normal)
        view.addSubview(button)
        
        let button2 = UIButton(frame: CGRect(x: (view.frame.size.width-220)/2, y: 725, width: 220, height: 50))
        button2.setTitle("Sign Up", for: .normal)
        button2.backgroundColor = .systemYellow
        button2.setTitleColor(.black, for: .normal)
        button2.addTarget(self, action: #selector(didTapActionSheet), for: .touchUpInside)

        
        view.addSubview(button2)

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
