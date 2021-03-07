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
    
    func setEntry(entry: Entry){
        if entry.type == "Expense" {
            amountOutlet.textColor = UIColor(red: 0.98, green: 0.39, blue: 0.00, alpha: 1.00)
            
        }
        amountOutlet.text = entry.amount
        categorySourceOutlet.text = entry.category+" / "+entry.source
    }
    
}
