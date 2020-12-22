//
//  CategoryCellVC.swift
//  Budget Manager
//
//  Created by Cenk Donmez on 22.12.2020.
//  Copyright © 2020 CTIS. All rights reserved.
//

import UIKit

class CategoryCellVC: UITableViewCell {
    

    @IBOutlet weak var categoryIcon: UIImageView!
    @IBOutlet weak var categoryName: UILabel!
    func setEntry(entry: Category){
        categoryIcon.image = entry.categoryIcon
        categoryName.text = entry.categoryName
    }
}
