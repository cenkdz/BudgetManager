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

class LandingVC: UIViewController {
    
    @IBOutlet weak var emailTextFieldOutlet: UITextField!
    @IBOutlet weak var passwordTextFieldOutlet: UITextField!
    let password = NSPredicate(format: "SELF MATCHES %@ ", "^(?=.*[a-z])(?=.*[$@$#!%*?&]).{6,}$")
    var showPassword = true
    let helperMethods = HelperMethods()
    let firebaseMethods = FirebaseMethods()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUISettings()
        setUIAppearance()

    }
    
    override func viewDidAppear(_ animated: Bool) {

        super.viewDidAppear(animated)

        // Check if the user is logged in
        if UserDefaults.standard.object(forKey: "user_uid_key") != nil {
            // send them to a new view controller or do whatever you want
            helperMethods.goToHomeVC(senderController: self)
        }
    }
    @IBAction func forgotPasswordPressed(_ sender: UIButton) {
        print("Forgot password Pressed!!")
    }
    @IBAction func loginPressed(_ sender: UIButton) {
        let trimmedEmail = emailTextFieldOutlet.text!.trimmingCharacters(in: .whitespaces)

        if (trimmedEmail.isEmpty) {
            helperMethods.displayAlert(message: "E-mail Missing", title: "Warning",receiverController: self)
        }
        else if (passwordTextFieldOutlet.text!.isEmpty){
            helperMethods.displayAlert(message: "Password Missing", title: "Warning",receiverController: self)
        }
        else if !(EmailValidator.validate(email: trimmedEmail))  {
            helperMethods.displayAlert(message: "Wrong e-mail", title: "Warning",receiverController: self)
        }
        else if !(password.evaluate(with: passwordTextFieldOutlet.text)){
            helperMethods.displayAlert(message: "Wrong password", title: "Warning",receiverController: self)
        }
        else {
            firebaseMethods.signIn(email: trimmedEmail, password: passwordTextFieldOutlet.text!, senderController: self)
        }
    }
    @IBAction func dontHaveAnAccountPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToSignUpVC", sender: self)
    }
    @IBAction func passwordTogglePressed(_ sender: UIButton) {
        showPassword = !showPassword
        if showPassword {
            passwordTextFieldOutlet.isSecureTextEntry = true
            sender.setImage(UIImage(systemName: "eye.fill"), for: .normal)
        } else {
            passwordTextFieldOutlet.isSecureTextEntry = false
            sender.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
        }
    }
    
    func setUIAppearance(){
        emailTextFieldOutlet.attributedPlaceholder = NSAttributedString(string: "E-mail", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0.01, green: 0.10, blue: 0.38, alpha: 1.00)])
        passwordTextFieldOutlet.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0.01, green: 0.10, blue: 0.38, alpha: 1.00)])
        emailTextFieldOutlet.layer.borderWidth = 1
        emailTextFieldOutlet.layer.borderColor = CGColor(red: 164/255, green: 164/255, blue: 164/255, alpha:  1)
        emailTextFieldOutlet.layer.cornerRadius = 10
        passwordTextFieldOutlet.layer.borderWidth = 1
        passwordTextFieldOutlet.layer.borderColor = CGColor(red: 164/255, green: 164/255, blue: 164/255, alpha:  1)
        passwordTextFieldOutlet.layer.cornerRadius = 10
    }
    
    func setUISettings(){
        passwordTextFieldOutlet.isSecureTextEntry = true
        self.hideKeyboardWhenTappedAround()
    }

}


