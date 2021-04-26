//
//  HeaderTableViewCell.swift
//  Budget Manager
//
//  Created by Cenk Donmez on 7.03.2021.
//  Copyright © 2021 CTIS. All rights reserved.
//

import UIKit

class HeaderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dayOutlet: UILabel!
    @IBOutlet weak var dayInWeekOutlet: UILabel!
    @IBOutlet weak var yearAndMonthOutlet: UILabel!
    @IBOutlet weak var totalAmountOutlet: UILabel!
    var total = 0
    func setEntry(entries: [Entry]){
        dayOutlet.text = String(entries[0].day)
        dayInWeekOutlet.text = String(entries[0].dayInWeek.prefix(3))
        yearAndMonthOutlet.text = entries[0].year + ".0" + entries[0].month
        for entry in entries {
            if entry.type == "Expense" {
                total = total - Int(entry.amount)!
            }
            else if entry.type == "Income" {
                total = total + Int(entry.amount)!
            }
            
        }
    }
    
    func setTotal(entries: [Entry]){
        var total = 0
        for entry in entries {
            total = total + Int(entry.amount)!
        }

        if total>=0 {
            totalAmountOutlet.textColor = UIColor(red: 0.24, green: 0.48, blue: 0.94, alpha: 1.00)
        }
        else if total<0{
            totalAmountOutlet.textColor = UIColor(red: 0.98, green: 0.39, blue: 0.00, alpha: 1.00)
        }
        totalAmountOutlet.text = String(total)
        
    }
    
}
