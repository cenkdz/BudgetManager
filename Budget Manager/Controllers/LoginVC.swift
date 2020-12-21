//
//  LoginVC.swift
//  Budget Manager
//
//  Created by CTIS Student on 18.12.2020.
//  Copyright © 2020 CTIS. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import EmailValidator

class LoginVC: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    let password = NSPredicate(format: "SELF MATCHES %@ ", "^(?=.*[a-z])(?=.*[$@$#!%*?&]).{6,}$")
    
    @IBAction func loginBPressed(_ sender: UIButton) {
        if (emailField.text!.isEmpty) {
            displayAlert(message: "E-mail Missing", title: "Warning")
        }
        else if (passwordField.text!.isEmpty){
            displayAlert(message: "Password Missing", title: "Warning")
        }
        else if !(EmailValidator.validate(email: emailField.text!))  {
            displayAlert(message: "E-mail is not valid", title: "Warning")
        }
        else if !(password.evaluate(with: passwordField.text)){
            displayAlert(message: "Your password must contain at least one special character and must be minimum six characters long.", title: "Warning")
        }
        else {
            Auth.auth().signIn(withEmail: emailField.text!, password: passwordField.text!) { [weak self] user, error in
                guard let strongSelf = self else { return }
                if(error != nil) {
                    strongSelf.displayAlert(message: "Error, check username and password", title: "Warning")
                    print(error)
                    return
                }
                strongSelf.displayDisappearingAlert(message: "Login sucesss for email \(self!.emailField.text)", title: "Success")
                
            }
           

        }
    }

override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
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
