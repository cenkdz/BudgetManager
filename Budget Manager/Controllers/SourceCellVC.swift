//
//  CategoryCellVC.swift
//  Budget Manager
//
//  Created by Cenk Donmez on 22.12.2020.
//  Copyright © 2020 CTIS. All rights reserved.
//

import UIKit
import SwiftIcons


class SourceCellVC: UITableViewCell {

    @IBOutlet weak var sourceNameOutlet: UILabel!
    @IBOutlet weak var sourceImageOutlet: UIImageView!
    
    
    func setEntry(entry: Source){
        sourceImageOutlet.image = UIImage(systemName: entry.sourceIcon)
        sourceNameOutlet.text = entry.sourceName
        
    }

}
