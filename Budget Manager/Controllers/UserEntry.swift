//
//  Income.swift
//  Budget Manager
//
//  Created by Cenk Donmez on 22.12.2020.
//  Copyright © 2020 CTIS. All rights reserved.
//

import Foundation
class UserEntry {
    var category: String
    var entryName: String
    var entryAmount: Double
    var uid: String
    var entryDate: String
    init(categoryIcon: String,entryName:String,entryAmount: Double,uid: String,entryDate: String) {
        self.category = categoryIcon
        self.entryName = entryName
        self.entryAmount = entryAmount
        self.uid = uid
        self.entryDate = entryDate

    }
}
