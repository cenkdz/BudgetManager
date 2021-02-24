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
    
    @IBOutlet weak var editButtonOutlet: UIButton!
    
    
    func setEntry(entry: UserEntry){
        categoryIcon.image = #imageLiteral(resourceName: "coins-512")
        entryNameLabel.text = entry.entryName
        entryAmount.text = entry.entryAmount as! String
        editButtonOutlet.setImage(UIImage(systemName: "pencil"), for: .normal)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if selected {
            contentView.backgroundColor = .black
        } else {
            
        }
    }
    
    

}
