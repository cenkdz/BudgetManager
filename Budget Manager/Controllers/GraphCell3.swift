//
//  GraphCell3.swift
//  Budget Manager
//
//  Created by Cenk Donmez on 6.05.2021.
//  Copyright © 2021 CTIS. All rights reserved.
//

import UIKit

class GraphCell3: UITableViewCell {

    @IBOutlet weak var mainCat: UILabel!
    @IBOutlet weak var total: UILabel!
    func setRecurringTable(mainCategory: String, totalIncome: String){
        mainCat.text = mainCategory
        total.text = totalIncome
    }

}
