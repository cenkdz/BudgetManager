//
//  SignUpVC.swift
//  Budget Manager
//
//  Created by CTIS Student on 18.12.2020.
//  Copyright © 2020 CTIS. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import EmailValidator

class SignUpVC: UIViewController {
    // Create a new alert
    var emailMessage = UIAlertController(title: "Attention", message: "", preferredStyle: .alert)
    var passwordMessage = UIAlertController(title: "Attention", message: "Password Missing", preferredStyle: .alert)
    
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    let password = NSPredicate(format: "SELF MATCHES %@ ", "^(?=.*[a-z])(?=.*[$@$#!%*?&]).{6,}$")
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        self.goToLandingVC()
        
    }
    @IBAction func signUpButton(_ sender: UIButton) {
        
        if (emailField.text!.isEmpty) {
            displayAlert(message: "E-mail Missing", title: "Warning")
        }
        else if (passwordField.text!.isEmpty){
            displayAlert(message: "Password Missing", title: "Warning")
        }
            else if (firstNameField.text!.isEmpty){
                displayAlert(message: "Firstname Missing", title: "Warning")
            }
            else if (lastNameField.text!.isEmpty){
                displayAlert(message: "Lastname Missing", title: "Warning")
            }
        else if !(EmailValidator.validate(email: emailField.text!))  {
            displayAlert(message: "E-mail is not valid", title: "Warning")
        }
        else if !(password.evaluate(with: passwordField.text)){
            displayAlert(message: "Your password must contain at least one special character and must be minimum six characters long.", title: "Warning")
        }
        else {
            Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!) { authResult, errorUser in
                if(errorUser == nil) {
                    let db = Firestore.firestore()
                    db.collection("users").addDocument(data: ["firstname":self.firstNameField.text!,"lastname":self.lastNameField.text!,"uid":authResult!.user.uid]) { (errorDatabase) in
                        if errorDatabase == nil{
                            self.displayDisappearingAlert(message: "Success", title: "Signup Successful")
                            self.goToHomeVC()
                        }
                        else if errorDatabase != nil {
                            self.displayAlert(message: "SignUp Completed!Check credentials in the settings.", title: "Error in Saving User Data")
                            self.goToHomeVC()
                        }
                    }
                }
                else if (errorUser != nil){
                    self.displayDisappearingAlert(message: "Check Credentials", title:"Signup Failed")
                }
                
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    func goToHomeVC() {
        let homeViewController = storyboard?.instantiateViewController(identifier: "HomeVC") as? HomeVC
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
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
