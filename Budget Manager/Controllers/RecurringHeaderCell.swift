//
//  RecurringHeaderCell.swift
//  Budget Manager
//
//  Created by Cenk Donmez on 28.04.2021.
//  Copyright © 2021 CTIS. All rights reserved.
//

import UIKit

class RecurringHeaderCell: UITableViewCell {
    
    @IBOutlet weak var monthOutlet: UILabel!
    @IBOutlet weak var yearOutlet: UILabel!
    
    
    func setEntry(entries: [Entry]){
        
        let month = switchToText(month: Int(entries[0].month)!)
                                
        monthOutlet.text = month
        yearOutlet.text = entries[0].year
    }
    
    
    func switchToText(month: Int) -> String{
        switch month {
        case 1:
            return "January"
        case 2:
            return "February"
        case 3:
            return "March"
        case 4:
            return "April"
        case 5:
            return "May"
        case 6:
            return "June"
        case 7:
            return "July"
        case 8:
            return "August"
        case 9:
            return "September"
        case 10:
            return "October"
        case 11:
            return "November"
        case 12:
            return "December"
        default:
            return ""
        }
    }
}
