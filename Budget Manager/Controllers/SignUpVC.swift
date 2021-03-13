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

class SignUpVC: UIViewController {

    @IBOutlet weak var emailFieldOutlet: UITextField!
    @IBOutlet weak var passwordFieldOutlet: UITextField!
    @IBOutlet weak var passwordConfirmationFieldOutlet: UITextField!
    @IBOutlet weak var firstNameFieldOutlet: UITextField!
    let password = NSPredicate(format: "SELF MATCHES %@ ", "^(?=.*[a-z])(?=.*[$@$#!%*?&]).{6,}$")
    var showPassword = true
    var showConfirmPassword = true

    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordFieldOutlet.isSecureTextEntry = true
        passwordConfirmationFieldOutlet.isSecureTextEntry = true
        hideKeyboardWhenTappedAround()
        emailFieldOutlet.attributedPlaceholder = NSAttributedString(string: "E-mail", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0.01, green: 0.10, blue: 0.38, alpha: 1.00)])
        passwordFieldOutlet.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0.01, green: 0.10, blue: 0.38, alpha: 1.00)])
        passwordConfirmationFieldOutlet.attributedPlaceholder = NSAttributedString(string: "Confirm Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0.01, green: 0.10, blue: 0.38, alpha: 1.00)])
        firstNameFieldOutlet.attributedPlaceholder = NSAttributedString(string: "Firstname", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0.01, green: 0.10, blue: 0.38, alpha: 1.00)])
        emailFieldOutlet.layer.borderWidth = 1
        emailFieldOutlet.layer.borderColor = CGColor(red: 164/255, green: 164/255, blue: 164/255, alpha:  1)
        emailFieldOutlet.layer.cornerRadius = 10
        passwordFieldOutlet.layer.borderWidth = 1
        passwordFieldOutlet.layer.borderColor = CGColor(red: 164/255, green: 164/255, blue: 164/255, alpha:  1)
        passwordFieldOutlet.layer.cornerRadius = 10
        passwordConfirmationFieldOutlet.layer.borderWidth = 1
        passwordConfirmationFieldOutlet.layer.borderColor = CGColor(red: 164/255, green: 164/255, blue: 164/255, alpha:  1)
        passwordConfirmationFieldOutlet.layer.cornerRadius = 10
        firstNameFieldOutlet.layer.borderWidth = 1
        firstNameFieldOutlet.layer.borderColor = CGColor(red: 164/255, green: 164/255, blue: 164/255, alpha:  1)
        firstNameFieldOutlet.layer.cornerRadius = 10

    }
    @IBAction func showPasswordPressed(_ sender: UIButton) {
        showPassword = !showPassword
        if showPassword {
            passwordFieldOutlet.isSecureTextEntry = true
            sender.setImage(UIImage(systemName: "eye.fill"), for: .normal)
        } else {
            passwordFieldOutlet.isSecureTextEntry = false
            sender.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
            
        }
    }
    
    @IBAction func showConfirmPasswordPressed(_ sender: UIButton) {
        showConfirmPassword = !showConfirmPassword
        if showConfirmPassword {
            passwordConfirmationFieldOutlet.isSecureTextEntry = true
            sender.setImage(UIImage(systemName: "eye.fill"), for: .normal)
        } else {
            passwordConfirmationFieldOutlet.isSecureTextEntry = false
            sender.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
            
        }
    }
    @IBAction func signUpPressed(_ sender: UIButton) {
        let enteredFirstname = firstNameFieldOutlet.text!.trimmingCharacters(in: .whitespaces)
        let enteredEmail = emailFieldOutlet.text!.trimmingCharacters(in: .whitespaces)
        let enteredPassword = passwordFieldOutlet.text!
        let enteredConfirmPassword = passwordConfirmationFieldOutlet.text!
        if (enteredFirstname.isEmpty){
                   displayAlert(message: "Firstname Missing", title: "Warning")
               }
        else if (enteredEmail.isEmpty) {
                   displayAlert(message: "E-mail Missing", title: "Warning")
               }
               else if !(EmailValidator.validate(email: enteredEmail))  {
                   displayAlert(message: "E-mail is not valid", title: "Warning")
               }
               else if (enteredPassword.isEmpty){
                   displayAlert(message: "Password Missing", title: "Warning")
               }
               else if !(password.evaluate(with: enteredPassword)){
                   displayAlert(message: "Your password must contain at least one special character and must be minimum six characters long.", title: "Warning")
               }
               else if (enteredPassword != enteredConfirmPassword){
                   displayAlert(message: "Your passwords must match.", title: "Warning")
               }
               else {
                   Auth.auth().createUser(withEmail: enteredEmail, password: passwordFieldOutlet.text!) { authResult, errorUser in
                       if(errorUser == nil) {
                           let db = Firestore.firestore()
                        db.collection("users").addDocument(data: ["firstname": enteredFirstname,"uid":authResult!.user.uid,"salary": "","budgetGoal":""]) { (errorDatabase) in
                               if errorDatabase == nil{
                                   self.displayDisappearingAlert(message: "Success", title: "Signup Successful")
                                   self.goToUserPreferences()
                               }
                               else if errorDatabase != nil {
                                   self.displayAlert(message: "Signup completed but an error occurred in saving your firstname. Please check credentials in the settings.", title: "Error in saving credentials")
                               }
                           }
                       }
                       else if (errorUser != nil){
                           self.displayDisappearingAlert(message: "Check Credentials", title:"Signup Failed")
                       }
       
                   }
       
               }
    }
    
    @IBAction func haveAnAccountPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func goToUserPreferences() {
        let homeViewController = storyboard?.instantiateViewController(identifier: "UserPreferencesVC") as? UserPreferencesVC
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
    
    func goToLandingVC() {
        let homeViewController = storyboard?.instantiateViewController(identifier: "LandingVC") as? LandingVC
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
    
}

