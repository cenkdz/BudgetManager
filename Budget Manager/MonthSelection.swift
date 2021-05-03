//
//  MonthSelection.swift
//  Budget Manager
//
//  Created by Cenk Donmez on 3.05.2021.
//  Copyright © 2021 CTIS. All rights reserved.
//

import Foundation


class MonthSelection{
    
    var date = Date()
    func increment(){
        let monthsToAdd = 1
        date = Calendar.current.date(byAdding: .month, value: monthsToAdd, to: date)!
        print(date)
    }
    
    func decrement(){
        let monthsToAdd = 1
        date = Calendar.current.date(byAdding: .month, value: -monthsToAdd, to: date)!
        print(date)
    }
    
    func getDate() -> Date{
        return date
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
    
    func getMonthYear() -> String{
        let date = getDate()
        let comp = date.get(.month,.year)
        
        var month = switchToText(month: comp.month!)
        var year = comp.year!
        
        return month + " " + String(year)
    }
}
