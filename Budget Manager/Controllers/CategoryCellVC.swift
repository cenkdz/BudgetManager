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
    

    @IBOutlet weak var imageOutlet: UIImageView!
    @IBOutlet weak var nameOutlet: UILabel!
    

    
    
    func setEntry(category: Category,source: Source,selectedButton: String){
        switch selectedButton {
        case "SourceButton":
            imageOutlet.image = UIImage(systemName: source.sourceIcon)
            nameOutlet.text = source.sourceName
        case "CategoryButton":
            imageOutlet.image = UIImage(systemName: category.categoryIcon)
            nameOutlet.text = category.categoryName
        default:
            print("Error")
        }
        
    }

}
