//
//  GraphCell.swift
//  Budget Manager
//
//  Created by Cenk Donmez on 6.05.2021.
//  Copyright © 2021 CTIS. All rights reserved.
//

import UIKit

class GraphCell: UITableViewCell {
    @IBOutlet weak var mainCatExpense: UILabel!
    
    @IBOutlet weak var totalExpense: UILabel!
    @IBOutlet weak var mainCatIncome: UILabel!
    @IBOutlet weak var totalIncome: UILabel!
    @IBOutlet weak var mainCatRecurring: UILabel!
    @IBOutlet weak var totalRecurring: UILabel!
    func setExpenseTable(mainCat: String, total: String){
        
        mainCatExpense.text = mainCat
        totalExpense.text = total
    }
    
    func setIncomeTable(mainCat: String, total: String){
        mainCatIncome.text = mainCat
        totalExpense.text = total
    }
    
    func setRecurringTable(mainCat: String, total: String){
        mainCatRecurring.text = mainCat
        totalExpense.text = total
    }

}
