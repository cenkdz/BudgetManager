//
//  Category.swift
//  Budget Manager
//
//  Created by Cenk Donmez on 22.12.2020.
//  Copyright © 2020 CTIS. All rights reserved.
//

import Foundation
import UIKit
class Category {
    var categoryID: String
    var categoryIcon: String
    var categoryMainName: String
    var categorySubName: String
    var categoryType: String
    var uid: String
    init(categoryID:String,categoryMainName:String,categorySubName:String,categoryIcon: String,categoryType: String,uid: String) {
        self.categoryID = categoryID
        self.categoryMainName = categoryMainName
        self.categorySubName = categorySubName
        self.categoryIcon = categoryIcon
        self.categoryType = categoryType
        self.uid = uid
        
    }
    
    func getDictionary() -> [String: Any]{
        return ["categoryID": categoryID,"categoryMainName":categoryMainName,"categorySubName":categorySubName,"categoryIcon":categoryIcon,"categoryType":categoryType,"uid":uid]
     }
}
