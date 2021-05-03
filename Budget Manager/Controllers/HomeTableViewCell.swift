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
    
    func setEntry(entry: Entry){
        recurringImage.isHidden = true

        if entry.type == "Expense" {
            amountOutlet.textColor = UIColor(red: 0.98, green: 0.39, blue: 0.00, alpha: 1.00)
            
        }
        else if entry.type == "Income" {
            amountOutlet.textColor = UIColor(red: 0.24, green: 0.48, blue: 0.94, alpha: 1.00)

        }
        if entry.recurring == "true" {
            recurringImage.isHidden = false
        }
        amountOutlet.text = entry.amount
        categorySourceOutlet.text = entry.category+" / "+entry.source
    }
    
}
