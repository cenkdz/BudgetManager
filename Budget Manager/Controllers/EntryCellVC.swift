//
//  EntryCellVC.swift
//  Budget Manager
//
//  Created by Cenk Donmez on 22.12.2020.
//  Copyright © 2020 CTIS. All rights reserved.
//

import UIKit

class EntryCellVC: UITableViewCell {

    @IBOutlet weak var categoryIcon: UIImageView!
    @IBOutlet weak var entryNameLabel: UILabel!
    @IBOutlet weak var entryAmount: UILabel!
    
    
    func setEntry(entry: Entry){
        categoryIcon.image = entry.categoryIcon
        entryNameLabel.text = entry.entryName
        entryAmount.text = String(entry.entryAmount)
    }
    
    
    

}
