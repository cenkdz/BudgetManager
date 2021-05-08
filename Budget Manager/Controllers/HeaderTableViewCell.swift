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
    @IBOutlet weak var weekLabel: UILabel!
    @IBOutlet weak var weekTextLabel: UILabel!
    
    var modeFromHomeVC = ""
    var total = 0
    func setEntry(entries: [Entry]){
        
        switch modeFromHomeVC {
        case "Daily":
            weekLabel.isHidden = true
            weekTextLabel.isHidden = true

            dayInWeekOutlet.text = String(entries[0].dayInWeek.prefix(3))

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
        case "Weekly":
            dayOutlet.text = String(entries[0].weekOfMonth)
            dayInWeekOutlet.isHidden = true
            yearAndMonthOutlet.isHidden = true
            
            
            
            switch entries[0].weekOfMonth {
            case "1":
                weekLabel.text = "st"
            case "2":
                weekLabel.text = "nd"
            case "3":
                weekLabel.text = "rd"
            default:
                weekLabel.text = "th"

            }
        case "Monthly":
            weekTextLabel.isHidden = true
            weekLabel.isHidden = true
            dayInWeekOutlet.text = String(entries[0].dayInWeek.prefix(3))

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
        case "Total":
            weekLabel.isHidden = true
            weekTextLabel.isHidden = true
            
            dayInWeekOutlet.text = String(entries[0].dayInWeek.prefix(3))
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
        default:
print("Error")
            
        }
        for entry in entries {
            if entry.type == "Expense" {
                total = total - Int(entry.amount)!
            }
            else if entry.type == "Income" {
                total = total + Int(entry.amount)!
            }
            
        }
    }
    
    func setMode(mode: String){
        modeFromHomeVC = mode
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
