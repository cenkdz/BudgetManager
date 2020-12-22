//
//  User.swift
//  Budget Manager
//
//  Created by Cenk Donmez on 22.12.2020.
//  Copyright © 2020 CTIS. All rights reserved.
//

import Foundation

class User {
    var firstname: String
    var lastname: String
    var uid: String

    init(firstname:String,lastname:String,uid:String) {
        self.firstname = firstname
        self.lastname = lastname
        self.uid = uid
    }
    
    
    func printAll(){
        print(firstname,lastname,uid)
    }
}
