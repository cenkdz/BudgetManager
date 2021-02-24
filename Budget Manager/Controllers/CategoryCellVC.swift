//
//  CategoryCellVC.swift
//  Budget Manager
//
//  Created by Cenk Donmez on 22.12.2020.
//  Copyright © 2020 CTIS. All rights reserved.
//

import UIKit
import SwiftIcons


class CategoryCellVC: UITableViewCell {
    

    @IBOutlet weak var editCategoryButton: UIButton!
    @IBOutlet weak var categoryIcon: UIImageView!
    @IBOutlet weak var categoryName: UILabel!
    func setEntry(entry: Category){
        categoryIcon.image = UIImage(systemName: entry.categoryIcon)
        categoryName.text = entry.categoryName    }

}
