//
//  HelperMethods.swift
//  Budget Manager
//
//  Created by Cenk Dönmez on 31.03.2021.
//  Copyright © 2021 CTIS. All rights reserved.
//

import Foundation
import UIKit


class HelperMethods {
    
    func displayAlert(message: String,title: String, receiverController: UIViewController) {
        let dialogMessage = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
        })
        dialogMessage.addAction(ok)
        receiverController.present(dialogMessage, animated: true, completion: nil)
        
    }
    
    func displayDisappearingAlert(message: String,title: String,receiverController: UIViewController) {
        let dialogMessage = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        receiverController.present(dialogMessage, animated: true, completion: nil)
        //Makes alert disappear after 2 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            dialogMessage.dismiss(animated: true, completion: nil)
        }
    }
    
    func goToHomeVC(senderController: UIViewController) {
        let homeViewController = senderController.storyboard?.instantiateViewController(identifier: "HomeViewController") as? HomeViewController
        senderController.view.window?.rootViewController = homeViewController
        senderController.view.window?.makeKeyAndVisible()
    }
    
    func goToUserPreferences(senderController: UIViewController) {
        let homeViewController = senderController.storyboard?.instantiateViewController(identifier: "UserPreferencesVC") as? UserPreferencesVC
        senderController.view.window?.rootViewController = homeViewController
        senderController.view.window?.makeKeyAndVisible()
    }
    
    func goToLandingVC(senderController: UIViewController) {
        let homeViewController = senderController.storyboard?.instantiateViewController(identifier: "LandingVC") as? LandingVC
        senderController.view.window?.rootViewController = homeViewController
        senderController.view.window?.makeKeyAndVisible()
    }
    
    func goToSettingsVC(senderController: UIViewController) {
        let homeViewController = senderController.storyboard?.instantiateViewController(identifier: "SettingsVC") as? SettingsVC
        senderController.view.window?.rootViewController = homeViewController
        senderController.view.window?.makeKeyAndVisible()
    }
    func goToTableRecurringVC(senderController: UIViewController) {
        let homeViewController = senderController.storyboard?.instantiateViewController(identifier: "TableRecurringVC") as? TableRecurringVC
        senderController.view.window?.rootViewController = homeViewController
        senderController.view.window?.makeKeyAndVisible()
    }
    func goToGraphsVC(senderController: UIViewController) {
        let homeViewController = senderController.storyboard?.instantiateViewController(identifier: "GraphsVC") as? GraphsVC
        senderController.view.window?.rootViewController = homeViewController
        senderController.view.window?.makeKeyAndVisible()
    }
    func goToRecurringEntryVC(senderController: UIViewController) {
        let homeViewController = senderController.storyboard?.instantiateViewController(identifier: "RecurringEntryVC") as? RecurringEntryVC
        senderController.view.window?.rootViewController = homeViewController
        senderController.view.window?.makeKeyAndVisible()
    }
}
