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
import Firebase
import FirebaseAuth
import EmailValidator

class TestLanding: UIViewController {
    var textField: MDCFilledTextField!
    var textField2: MDCFilledTextField!
    let password = NSPredicate(format: "SELF MATCHES %@ ", "^(?=.*[a-z])(?=.*[$@$#!%*?&]).{6,}$")
    
    override func viewWillAppear(_ animated: Bool) {
        view.backgroundColor = UIColor(hex: "#000000ff")
        let estimatedFrame = CGRect(x: 75, y: 400, width: (self.view.frame.width)/2+50, height: 50)
        let estimatedFrame2 = CGRect(x: 75, y: 500, width: (self.view.frame.width)/2+50, height: 50)
        textField = MDCFilledTextField(frame: estimatedFrame)
        textField2 = MDCFilledTextField(frame: estimatedFrame2)
        
        textField.label.text = "E-MAIL"
        textField.textColor = UIColor.red
        textField.placeholder = "Please enter your e-mail"
        textField.backgroundColor = .systemGray
        textField.sizeToFit()
        
        textField2.label.text = "PASSWORD"
        textField2.placeholder = "Please enter your password"
        textField2.backgroundColor = .systemGray
        textField2.sizeToFit()
        
        view.addSubview(textField)
        view.addSubview(textField2)
        
        let imageView1 = UIImageView(image: #imageLiteral(resourceName: "landingImage-1"))
        imageView1.frame = CGRect(x: 100, y: 150, width: 200, height: 200)
        view.addSubview(imageView1)
        
        let budgetManagerLabel = UILabel(frame: CGRect(x: 0, y: 50, width: 300, height: 50))
        budgetManagerLabel.text = "BUDGET MANAGER"
        budgetManagerLabel.textColor = .systemYellow
        budgetManagerLabel.center.x = self.view.center.x
        budgetManagerLabel.textAlignment = .center;
        budgetManagerLabel.font = UIFont.boldSystemFont(ofSize: 30)
        view.addSubview(budgetManagerLabel)
        
        let welcomeLabel = UILabel(frame: CGRect(x: 0, y: 350, width: 300, height: 50))
        welcomeLabel.text = "WELCOME"
        welcomeLabel.textColor = .systemYellow
        welcomeLabel.center.x = self.view.center.x
        welcomeLabel.textAlignment = .center;
        welcomeLabel.font = UIFont.boldSystemFont(ofSize: 20)
        view.addSubview(welcomeLabel)
        
        let forgotPasswordLabel = UILabel(frame: CGRect(x: 0, y: 637.5, width: 300, height: 50))
        forgotPasswordLabel.text = "Forgot password?"
        forgotPasswordLabel.textColor = .systemYellow
        forgotPasswordLabel.center.x = self.view.center.x
        forgotPasswordLabel.textAlignment = .center;
        view.addSubview(forgotPasswordLabel)
        
        let existingAccountLabel = UILabel(frame: CGRect(x: 0, y: 687.5, width: 300, height: 50))
        existingAccountLabel.text = "Don't have an account?"
        existingAccountLabel.textColor = .systemYellow
        existingAccountLabel.center.x = self.view.center.x
        existingAccountLabel.textAlignment = .center;
        view.addSubview(existingAccountLabel)
        
        let button = UIButton(frame: CGRect(x: (view.frame.size.width-220)/2, y: 600, width: 220, height: 50))
        button.setTitle("Log In", for: .normal)
        button.backgroundColor = .systemYellow
        button.addTarget(self, action: #selector(loginButton), for: .touchUpInside)
        button.setTitleColor(.black, for: .normal)
        view.addSubview(button)
        
        let button2 = UIButton(frame: CGRect(x: (view.frame.size.width-220)/2, y: 725, width: 220, height: 50))
        button2.setTitle("Sign Up", for: .normal)
        button2.backgroundColor = .systemYellow
        button2.setTitleColor(.black, for: .normal)
        button2.addTarget(self, action: #selector(signUpButton), for: .touchUpInside)
        
        
        view.addSubview(button2)
        hideKeyboardWhenTappedAround()
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
    
    func displayAlert(message: String,title: String) {
        let dialogMessage = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
        })
        dialogMessage.addAction(ok)
        self.present(dialogMessage, animated: true, completion: nil)
        
    }
    func goToHomeVC() {
         let homeViewController = storyboard?.instantiateViewController(identifier: "HomeVC") as? HomeVC
         view.window?.rootViewController = homeViewController
         view.window?.makeKeyAndVisible()
     }
    
    @objc func loginButton() {
        if (textField.text!.isEmpty) {
            displayAlert(message: "E-mail Missing", title: "Warning")
        }
        else if (textField2.text!.isEmpty){
            displayAlert(message: "Password Missing", title: "Warning")
        }
        else if !(EmailValidator.validate(email: textField.text!))  {
            displayAlert(message: "Wrong e-mail", title: "Warning")
        }
        else if !(password.evaluate(with: textField2.text)){
            displayAlert(message: "Wrong password", title: "Warning")
        }
        else {
            Auth.auth().signIn(withEmail: textField.text!, password: textField2.text!) { [weak self] user, error in
                guard let strongSelf = self else { return }
                if(error != nil) {
                    strongSelf.displayAlert(message: "Username or password wrong", title: "Warning")
                    print("ERRORRRRRRRRRR")
                }
                else if error == nil{
                    
                    print("SIGNED INNNNNNNNN")
                    self!.goToHomeVC()
                    
                }
            }
        }
    }
    
    @objc func signUpButton() {
          let homeViewController = storyboard?.instantiateViewController(identifier: "TestSignUp") as? TestSignUp
          view.window?.rootViewController = homeViewController
          view.window?.makeKeyAndVisible()
      }
    
    
    
    
}

extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat
        
        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])
            
            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255
                    
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        
        return nil
    }
}
