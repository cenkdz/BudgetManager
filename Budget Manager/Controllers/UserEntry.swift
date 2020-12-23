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
    var entryAmount: Any
    var uid: String
    var entryDate: Any
    var entryType: String
    init(category: String,entryName:String,entryAmount: Any,uid: String,entryDate: Any,entryType: String) {
        self.category = category
        self.entryName = entryName
        self.entryAmount = entryAmount
        self.uid = uid
        self.entryDate = entryDate
        self.entryType = entryType
    }
    
    func getDictionary() -> [String: Any]{
        return ["category": category,"entryName":entryName,"entryAmount":entryAmount,"uid":uid,"entryDate":entryDate,"entryType":entryType]
    }
}
