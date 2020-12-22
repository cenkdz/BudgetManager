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
    var categoryIcon: UIImage
    var categoryName: String
    init(categoryIcon: UIImage,categoryName:String) {
        self.categoryIcon = categoryIcon
        self.categoryName = categoryName
    }
}
