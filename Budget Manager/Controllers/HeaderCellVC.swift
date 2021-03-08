//
//  CategoryCellVC.swift
//  Budget Manager
//
//  Created by Cenk Donmez on 22.12.2020.
//  Copyright © 2020 CTIS. All rights reserved.
//

import UIKit
import SwiftIcons


class HeaderCellVC: UITableViewCell {

    @IBAction func plusPressed(_ sender: UIButton) {
        print("Plus button pressed!")
    }
    @IBOutlet weak var sourceNameOutlet: UILabel!
    
    
    func setEntry(selected: String){
        sourceNameOutlet.text = selected
        
    }


}
