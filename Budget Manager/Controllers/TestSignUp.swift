//
//  TestViewController.swift
//  Budget Manager
//
//  Created by CTIS Student on 23.12.2020.
//  Copyright © 2020 CTIS. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import EmailValidator
import MaterialComponents.MaterialButtons
import MaterialComponents.MaterialButtons_Theming
import MaterialComponents.MaterialTextControls_FilledTextAreas
import MaterialComponents.MaterialTextControls_FilledTextFields
import MaterialComponents.MaterialTextControls_OutlinedTextAreas
import MaterialComponents.MaterialTextControls_OutlinedTextFields

class TestSignUp: UIViewController {
    var textField: MDCFilledTextField!
    var textField2: MDCFilledTextField!
    var textField3: MDCFilledTextField!
    var textField4: MDCFilledTextField!
    let password = NSPredicate(format: "SELF MATCHES %@ ", "^(?=.*[a-z])(?=.*[$@$#!%*?&]).{6,}$")
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        view.backgroundColor = UIColor(hex: "#000000ff")
        let estimatedFrame = CGRect(x: 75, y: 100, width: (self.view.frame.width)/2+50, height: 50)
        textField = MDCFilledTextField(frame: estimatedFrame)
        textField.label.text = "Firstname"
        textField.label.textColor = .systemRed
        textField.placeholder = "Please enter your firstname"
        textField.setFilledBackgroundColor(UIColor(hex: "#FFFFFFff")!, for: .normal)
        textField.autocorrectionType = .no
        textField.sizeToFit()
        view.addSubview(textField)
        let estimatedFrame2 = CGRect(x: 75, y: 200, width: (self.view.frame.width)/2+50, height: 50)
        textField2 = MDCFilledTextField(frame: estimatedFrame2)
        textField2.label.text = "Lastname"
        textField2.placeholder = "Please enter your lastname"
        textField2.setFilledBackgroundColor(UIColor(hex: "#FFFFFFff")!, for: .normal)
        textField2.autocorrectionType = .no
        textField2.sizeToFit()
        view.addSubview(textField2)
        let estimatedFrame3 = CGRect(x: 75, y: 300, width: (self.view.frame.width)/2+50, height: 50)
        textField3 = MDCFilledTextField(frame: estimatedFrame3)
        textField3.label.text = "E-mail"
        textField3.placeholder = "Please enter your e-mail"
        textField3.setFilledBackgroundColor(UIColor(hex: "#FFFFFFff")!, for: .normal)
        textField3.autocapitalizationType = .none
        textField3.autocorrectionType = .no
        textField3.sizeToFit()
        view.addSubview(textField3)
        let estimatedFrame4 = CGRect(x: 75, y: 400, width: (self.view.frame.width)/2+50, height: 50)
        textField4 = MDCFilledTextField(frame: estimatedFrame4)
        textField4.label.text = "Password"
        textField4.placeholder = "Please enter your password"
        textField4.setFilledBackgroundColor(UIColor(hex: "#FFFFFFff")!, for: .normal)
        textField4.autocapitalizationType = .none
        textField4.autocorrectionType = .no
        textField4.sizeToFit()
        view.addSubview(textField4)
        
        let button = UIButton(frame: CGRect(x: (view.frame.size.width-220)/2, y: 500, width: 220, height: 50))
        button.setTitle("Let's Get Started", for: .normal)
        button.backgroundColor = .systemYellow
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(signUpButton), for: .touchUpInside)
        view.addSubview(button)
        
        let button2 = UIButton(frame: CGRect(x: (view.frame.size.width-220)/2, y: 700, width: 220, height: 50))
        button2.setTitle("Log In", for: .normal)
        button2.backgroundColor = .systemYellow
        button2.setTitleColor(.black, for: .normal)

        button2.addTarget(self, action: #selector(goToLandingVC), for: .touchUpInside)
        
        view.addSubview(button2)
        
        let alreadyUserLabel = UILabel(frame: CGRect(x: 30, y: 600, width: 300, height: 50))
        alreadyUserLabel.text = "Already have an account?"
        alreadyUserLabel.textColor = UIColor(hex: "#FFFFFFFF")
        view.addSubview(alreadyUserLabel)
        hideKeyboardWhenTappedAround()
    }
    
    @objc func signUpButton() {
        if (textField.text!.isEmpty){
            displayAlert(message: "Firstname Missing", title: "Warning")
        }
        else if (textField2.text!.isEmpty){
            displayAlert(message: "Lastname Missing", title: "Warning")
        }
        else if (textField3.text!.isEmpty) {
            displayAlert(message: "E-mail Missing", title: "Warning")
        }
        else if !(EmailValidator.validate(email: textField3.text!))  {
            displayAlert(message: "E-mail is not valid", title: "Warning")
        }
        else if (textField4.text!.isEmpty){
            displayAlert(message: "Password Missing", title: "Warning")
        }
        else if !(password.evaluate(with: textField4.text)){
            displayAlert(message: "Your password must contain at least one special character and must be minimum six characters long.", title: "Warning")
        }
        else {
            Auth.auth().createUser(withEmail: textField3.text!, password: textField4.text!) { authResult, errorUser in
                if(errorUser == nil) {
                    let db = Firestore.firestore()
                    db.collection("users").addDocument(data: ["firstname":self.textField.text!,"lastname":self.textField2.text!,"uid":authResult!.user.uid]) { (errorDatabase) in
                        if errorDatabase == nil{
                            self.displayDisappearingAlert(message: "Success", title: "Signup Successful")
                            self.goToHomeVC()
                        }
                        else if errorDatabase != nil {
                            self.displayAlert(message: "SignUp Completed!Check credentials in the settings.", title: "Error in Saving User Data")
                        }
                    }
                }
                else if (errorUser != nil){
                    self.displayDisappearingAlert(message: "Check Credentials", title:"Signup Failed")
                }
                
            }
            
        }
    }
    
    @objc func goToHomeVC() {
        let homeViewController = storyboard?.instantiateViewController(identifier: "HomeVC") as? HomeVC
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
    @objc func goToLandingVC() {
        let homeViewController = storyboard?.instantiateViewController(identifier: "TestLanding") as? TestLanding
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
    
    func displayAlert(message: String,title: String) {
        let dialogMessage = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
        })
        dialogMessage.addAction(ok)
        self.present(dialogMessage, animated: true, completion: nil)
        
    }
    func displayDisappearingAlert(message: String,title: String) {
        let dialogMessage = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        self.present(dialogMessage, animated: true, completion: nil)
        //Makes alert disappear after 2 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            
            dialogMessage.dismiss(animated: true, completion: nil)
        }
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
    @objc private func didTapActionSheet() -> String {
        let actionSheet = MDCActionSheetController(title: "Action Sheet",
                                                   message: "Secondary line text")
        actionSheet.backgroundColor = .systemBackground
        actionSheet.titleTextColor = .label
        actionSheet.messageTextColor = .secondaryLabel
        actionSheet.actionTintColor = .label
        actionSheet.actionTextColor = .label
        
        let actionOne = MDCActionSheetAction(title: "Food",
                                             image: UIImage(systemName: "house"),
                                             handler: {_ in print("Home action") })
        let actionTwo = MDCActionSheetAction(title: "car",
                                             image: UIImage(systemName: "gear"),
                                             handler: {_ in print("Email action") })
        let actionTwo1 = MDCActionSheetAction(title: "entertaintment",
                                              image: UIImage(systemName: "gear"),
                                              handler: {_ in print("Email action") })
        let actionTwo2 = MDCActionSheetAction(title: "health",
                                              image: UIImage(systemName: "gear"),
                                              handler: {_ in print("Email action") })
        let actionTwo3 = MDCActionSheetAction(title: "electronics",
                                              image: UIImage(systemName: "gear"),
                                              handler: {_ in print("Email action") })
        let actionTwo4 = MDCActionSheetAction(title: "clothes",
                                              image: UIImage(systemName: "gear"),
                                              handler: {_ in print("Email action") })
        let actionTwo5 = MDCActionSheetAction(title: "travel",
                                              image: UIImage(systemName: "gear"),
                                              handler: {_ in print("Email action") })
        let actionTwo6 = MDCActionSheetAction(title: "accessories",
                                              image: UIImage(systemName: "gear"),
                                              handler: {_ in print("Email action") })
        let actionTwo7 = MDCActionSheetAction(title: "home",
                                              image: UIImage(systemName: "gear"),
                                              handler: {_ in print() })
        actionSheet.addAction(actionOne)
        actionSheet.addAction(actionTwo)
        actionSheet.addAction(actionTwo1)
        actionSheet.addAction(actionTwo2)
        actionSheet.addAction(actionTwo3)
        actionSheet.addAction(actionTwo4)
        actionSheet.addAction(actionTwo5)
        actionSheet.addAction(actionTwo6)
        actionSheet.addAction(actionTwo7)
        
        present(actionSheet, animated: true, completion: nil)
        
        print(actionTwo1.title)
        return actionTwo1.title
        
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

