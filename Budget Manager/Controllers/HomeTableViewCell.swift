//
//  HomeTableViewCell.swift
//  Budget Manager
//
//  Created by Cenk Donmez on 6.03.2021.
//  Copyright © 2021 CTIS. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var amountOutlet: UILabel!
    @IBOutlet weak var categorySourceOutlet: UILabel!
    @IBOutlet weak var recurringImage: UIImageView!
    
    @IBOutlet weak var sourceIcon: UIImageView!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var mainCategoryOutlet: UILabel!
    func setEntry(entry: Entry){
        recurringImage.isHidden = true

        if entry.type == "Expense" {
            amountOutlet.textColor = UIColor(red: 0.98, green: 0.39, blue: 0.00, alpha: 1.00)
            mainCategoryOutlet.textColor = .red
            sourceIcon.image = UIImage(systemName: "minus.circle.fill")
            
        }
        else if entry.type == "Income" {
            amountOutlet.textColor = UIColor(red: 0.24, green: 0.48, blue: 0.94, alpha: 1.00)
            mainCategoryOutlet.textColor = .green
            sourceIcon.image = UIImage(systemName: "plus.circle.fill")

        }
        if entry.recurring == "true" {
            recurringImage.isHidden = false
        }
        amountOutlet.text = entry.amount
        sourceLabel.text = entry.source
        categorySourceOutlet.text = entry.category
        mainCategoryOutlet.text = entry.mainCategory
    }
    
}
