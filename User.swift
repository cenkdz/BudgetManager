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
    var uid: String

    init(firstname:String,uid:String) {
        self.firstname = firstname
        self.uid = uid
    }
    
    
    func printAll(){
        print(firstname,uid)
    }
}
