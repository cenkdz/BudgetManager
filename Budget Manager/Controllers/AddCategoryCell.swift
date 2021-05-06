//
//  AddCategoryCell.swift
//  Budget Manager
//
//  Created by Cenk Donmez on 5.05.2021.
//  Copyright © 2021 CTIS. All rights reserved.
//

import UIKit

class AddCategoryCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func getLabel() -> String{
        return nameLabel.text!
    }
    func setEntry(name: String){
        nameLabel.text = name
    }
    
    
    

}
