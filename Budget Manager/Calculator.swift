//
//  Calculator.swift
//  Budget Manager
//
//  Created by Cenk Dönmez on 31.03.2021.
//  Copyright © 2021 CTIS. All rights reserved.
//

import Foundation
import UIKit

class Calculator{
    
    func calculateTotal(entries: [[Entry]]) -> String {
        var total = 0
        
        for array in entries {
            for value in array {
                total = total + Int(value.amount)!
            }
        }
        return String(total)
    }
    
    func calculateExpenses(entries: [[Entry]]) -> String {
        var expenses = 0
        
        for array in entries {
            for value in array {
                if value.type == "Expense" {
                    expenses = expenses + Int(value.amount)!
                }
            }
        }
        return String(expenses)
    }
    
    func calculateIncome(entries: [[Entry]]) -> String {
        var income = 0
        
        for array in entries {
            for value in array {
                if value.type == "Income" {
                    income = income + Int(value.amount)!
                }
            }
        }
        return String(income)
    }
}
