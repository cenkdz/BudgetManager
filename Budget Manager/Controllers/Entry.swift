//
//  Entry.swift
//  Budget Manager
//
//  Created by Cenk Donmez on 22.12.2020.
//  Copyright © 2020 CTIS. All rights reserved.
//

import Foundation
import UIKit

class Entry {
    var categoryIcon: UIImage
    var entryName: String
    var entryAmount: Double
    init(categoryIcon: UIImage,entryName:String,entryAmount: Double) {
        self.categoryIcon = categoryIcon
        self.entryName = entryName
        self.entryAmount = entryAmount
    }
}
