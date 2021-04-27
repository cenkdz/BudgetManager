//
//  TableRecurringCellVC.swift
//  Budget Manager
//
//  Created by Cenk Donmez on 11.03.2021.
//  Copyright © 2021 CTIS. All rights reserved.
//

import UIKit

class TableRecurringCellVC: UITableViewCell {

    @IBOutlet weak var dayOutlet: UILabel!
    @IBOutlet weak var dayInWeekOutlet: UILabel!
    @IBOutlet weak var yearAndMonthOutlet: UILabel!
    @IBOutlet weak var totalAmountOutlet: UILabel!
    @IBOutlet weak var categorySourceOutlet: UILabel!
    var total = 0
    func setEntry(entries: [Entry]){
        dayOutlet.text = String(entries[0].day)
        dayInWeekOutlet.text = String(entries[0].dayInWeek.prefix(3))
        yearAndMonthOutlet.text = entries[0].year + ".0" + entries[0].month
        categorySourceOutlet.text = entries[0].category
        totalAmountOutlet.text = entries[0].amount
        if entries[0].type == "Expense"{
            totalAmountOutlet.textColor = UIColor(red: 0.98, green: 0.39, blue: 0.00, alpha: 1.00)

        }
        else if entries[0].type == "Income" {
            totalAmountOutlet.textColor = UIColor(red: 0.24, green: 0.48, blue: 0.94, alpha: 1.00)
        }
        else{
            totalAmountOutlet.textColor = UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1.00)
        }
        if abs(Int(entries[0].day)!) > 9 && abs(Int(entries[0].month)!) > 9 {
            dayOutlet.text = String(entries[0].day)
            yearAndMonthOutlet.text = entries[0].year + "." + entries[0].month
        }
        else if abs(Int(entries[0].day)!) < 10 && abs(Int(entries[0].month)!) < 10{
            dayOutlet.text = "0"+String(entries[0].day)
            yearAndMonthOutlet.text = entries[0].year + ".0" + entries[0].month

        }
        else if abs(Int(entries[0].day)!) > 10 && abs(Int(entries[0].month)!) < 10{
            dayOutlet.text = String(entries[0].day)
            yearAndMonthOutlet.text = entries[0].year + ".0" + entries[0].month

        }
        else if abs(Int(entries[0].day)!) < 10 && abs(Int(entries[0].month)!) > 10{
            dayOutlet.text = "0"+String(entries[0].day)
            yearAndMonthOutlet.text = entries[0].year + "." + entries[0].month

        }

        for entry in entries {
            total = total + Int(entry.amount)!
        }
    }
    


}
