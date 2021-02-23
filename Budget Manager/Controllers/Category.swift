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
    var categoryName: String
    var uid: String
    init(categoryID:String,categoryName:String,categoryIcon: String,uid: String) {
        self.categoryID = categoryID
        self.categoryName = categoryName
        self.categoryIcon = categoryIcon
        self.uid = uid
        
    }
    
    func getDictionary() -> [String: Any]{
         return ["category_id": categoryID,"category_name":categoryName,"category_icon":categoryIcon,"uid":uid]
     }
}
