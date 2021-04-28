//
//  WeekCell.swift
//  Budget Manager
//
//  Created by Cenk Donmez on 26.04.2021.
//  Copyright © 2021 CTIS. All rights reserved.
//

import UIKit

class WeekCell: UITableViewCell {
    @IBOutlet weak var dayInWeekLabel: UILabel!
    @IBOutlet weak var yearMonthDayLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
        func setEntry(entries: [Entry]){
            dayInWeekLabel.isHidden = true
            yearMonthDayLabel.isHidden = true
//            dayInWeekLabel.text = String(entries[0].dayInWeek.prefix(3))
//            if abs(Int(entries[0].day)!) > 9 && abs(Int(entries[0].month)!) > 9 {
//                yearMonthDayLabel.text = entries[0].year + "." + entries[0].month + "." + entries[0].day
//            }
//            else if abs(Int(entries[0].day)!) < 10 && abs(Int(entries[0].month)!) < 10{
//                yearMonthDayLabel.text = entries[0].year + ".0" + entries[0].month + ".0" + entries[0].day
//
//            }
//            else if abs(Int(entries[0].day)!) > 10 && abs(Int(entries[0].month)!) < 10{
//                yearMonthDayLabel.text = entries[0].year + ".0" + entries[0].month + "." + entries[0].day
//
//            }
//            else if abs(Int(entries[0].day)!) < 10 && abs(Int(entries[0].month)!) > 10{
//                yearMonthDayLabel.text = entries[0].year + "." + entries[0].month + ".0" + entries[0].day
//
//            }
            
            amountLabel.text = entries[0].amount
            categoryLabel.text = entries[0].category+" / "+entries[0].source
        if entries[0].type == "Expense" {
            amountLabel.textColor = UIColor(red: 0.98, green: 0.39, blue: 0.00, alpha: 1.00)

        }
        else if entries[0].type == "Income" {
            amountLabel.textColor = UIColor(red: 0.24, green: 0.48, blue: 0.94, alpha: 1.00)

        }
 
    }
    
}
