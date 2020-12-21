//
//  LandingVC.swift
//  Budget Manager
//
//  Created by CTIS Student on 18.12.2020.
//  Copyright © 2020 CTIS. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import EmailValidator
import iOSUtilitiesSource
import Network

class LandingVC: UIViewController {
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var forgotButtonLabel: UILabel!
    
    let monitor = NWPathMonitor()
    let queue = DispatchQueue(label: "InternetConnectionMonitor")
    
    let password = NSPredicate(format: "SELF MATCHES %@ ", "^(?=.*[a-z])(?=.*[$@$#!%*?&]).{6,}$")
    
    @IBAction func unwind( _ seg: UIStoryboardSegue) {}
    @IBAction func signUpButton(_ sender: UIButton) {
        print("sbp")
    }
    @IBAction func loginButton(_ sender: UIButton) {
        if (emailField.text!.isEmpty) {
            displayAlert(message: "E-mail Missing", title: "Warning")
        }
        else if (passwordField.text!.isEmpty){
            displayAlert(message: "Password Missing", title: "Warning")
        }
        else if !(EmailValidator.validate(email: emailField.text!))  {
            displayAlert(message: "Wrong e-mail", title: "Warning")
        }
        else if !(password.evaluate(with: passwordField.text)){
            displayAlert(message: "Wrong password", title: "Warning")
        }
        else {
            Auth.auth().signIn(withEmail: emailField.text!, password: passwordField.text!) { [weak self] user, error in
                guard let strongSelf = self else { return }
                if(error != nil) {
                    strongSelf.displayAlert(message: "Username or password wrong", title: "Warning")
                }
                else if error == nil{
                    self?.goToHomeVC()
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        monitor.pathUpdateHandler = { pathUpdateHandler in
            DispatchQueue.main.async {
                if pathUpdateHandler.status == .unsatisfied {
                    self.displayAlert(message:"There's no internet connection.", title: "Warning")
                }
                
            }
        }
        self.monitor.start(queue: self.queue)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(LandingVC.tapFunction))
        self.forgotButtonLabel.addGestureRecognizer(tap)
    }
    @objc func tapFunction(sender:UITapGestureRecognizer) {
        if emailField.text == "" {
            displayAlert(message: "Please enter your email in the email field", title: "Warning")
        }
        else if !(EmailValidator.validate(email: emailField.text!))  {
            displayAlert(message: "E-mail is not valid", title: "Warning")
        }
        else if emailField.text != ""{
            // After asking the user for their email.
            Auth.auth().fetchSignInMethods(forEmail: emailField.text!) { signInMethods, error in
                if ((error) != nil) {
                    self.displayAlert(message: "Cant establish connection with the server", title: "Error")
                }
                else if ((error) == nil) {
                    Auth.auth().sendPasswordReset(withEmail: self.emailField.text!) { (err) in
                        if err == nil{
                            self.displayAlert(message: "Reset e-mail will be sent to your e-mail adress.", title: "Check your e-mail")
                            
                        }
                        else if err != nil {
                            self.displayAlert(message: "Your e-mail is not registered", title: "Warning")
                        }
                    }
                    
                }
            }
        }
    }
    
    func goToHomeVC() {
        let homeViewController = storyboard?.instantiateViewController(identifier: "HomeVC") as? HomeVC
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
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
