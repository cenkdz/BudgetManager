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
    let helperMethods = HelperMethods()
    let firebaseMethods = FirebaseMethods()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUISettings()
        setUIAppearance()
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
            helperMethods.displayAlert(message: "Firstname Missing", title: "Warning",receiverController: self)
               }
        else if (enteredEmail.isEmpty) {
            helperMethods.displayAlert(message: "E-mail Missing", title: "Warning",receiverController: self)
               }
               else if !(EmailValidator.validate(email: enteredEmail))  {
                helperMethods.displayAlert(message: "E-mail is not valid", title: "Warning",receiverController: self)
               }
               else if (enteredPassword.isEmpty){
                helperMethods.displayAlert(message: "Password Missing", title: "Warning",receiverController: self)
               }
               else if !(password.evaluate(with: enteredPassword)){
                helperMethods.displayAlert(message: "Your password must contain at least one special character and must be minimum six characters long.", title: "Warning",receiverController: self)
               }
               else if (enteredPassword != enteredConfirmPassword){
                helperMethods.displayAlert(message: "Your passwords must match.", title: "Warning",receiverController: self)
               }
               else {
                firebaseMethods.signUp(email: enteredEmail, password: passwordFieldOutlet.text!, firstName: enteredFirstname, senderController: self)
               }
    }
    
    @IBAction func haveAnAccountPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setUISettings(){
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
    
    func setUIAppearance(){
        passwordFieldOutlet.isSecureTextEntry = true
        passwordConfirmationFieldOutlet.isSecureTextEntry = true
        hideKeyboardWhenTappedAround()
    }
    
}

