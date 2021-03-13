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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextFieldOutlet.isSecureTextEntry = true
        self.hideKeyboardWhenTappedAround()
        emailTextFieldOutlet.attributedPlaceholder = NSAttributedString(string: "E-mail", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0.01, green: 0.10, blue: 0.38, alpha: 1.00)])
        passwordTextFieldOutlet.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0.01, green: 0.10, blue: 0.38, alpha: 1.00)])
        
        emailTextFieldOutlet.layer.borderWidth = 1
        emailTextFieldOutlet.layer.borderColor = CGColor(red: 164/255, green: 164/255, blue: 164/255, alpha:  1)
        emailTextFieldOutlet.layer.cornerRadius = 10
        passwordTextFieldOutlet.layer.borderWidth = 1
        passwordTextFieldOutlet.layer.borderColor = CGColor(red: 164/255, green: 164/255, blue: 164/255, alpha:  1)
        passwordTextFieldOutlet.layer.cornerRadius = 10
        
    }
    @IBAction func forgotPasswordPressed(_ sender: UIButton) {
        print("Forgot password Pressed!!")
    }
    @IBAction func loginPressed(_ sender: UIButton) {
        let trimmedEmail = emailTextFieldOutlet.text!.trimmingCharacters(in: .whitespaces)

        if (trimmedEmail.isEmpty) {
            displayAlert(message: "E-mail Missing", title: "Warning")
        }
        else if (passwordTextFieldOutlet.text!.isEmpty){
            displayAlert(message: "Password Missing", title: "Warning")
        }
        else if !(EmailValidator.validate(email: trimmedEmail))  {
            displayAlert(message: "Wrong e-mail", title: "Warning")
        }
        else if !(password.evaluate(with: passwordTextFieldOutlet.text)){
            displayAlert(message: "Wrong password", title: "Warning")
        }
        else {

            Auth.auth().signIn(withEmail: trimmedEmail, password: passwordTextFieldOutlet.text!) { [weak self] user, error in
                guard let strongSelf = self else { return }
                if(error != nil) {
                    strongSelf.displayAlert(message: "Username or password wrong", title: "Warning")
                }
                else if error == nil{
                    self!.goToHomeVC()
                }
            }
        }
    }
    @IBAction func dontHaveAnAccountPressed(_ sender: UIButton) {
        print("DHAA Pressed!!")
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
    func displayAlert(message: String,title: String) {
        let dialogMessage = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
        })
        dialogMessage.addAction(ok)
        self.present(dialogMessage, animated: true, completion: nil)
        
    }
    func goToHomeVC() {
        let homeViewController = storyboard?.instantiateViewController(identifier: "HomeViewController") as? HomeViewController
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
}


