//
//  GraphSubCell2.swift
//  Budget Manager
//
//  Created by Cenk Donmez on 6.05.2021.
//  Copyright © 2021 CTIS. All rights reserved.
//

import UIKit

class GraphSubCell2: UITableViewCell {

    @IBOutlet weak var subName: UILabel!
    @IBOutlet weak var subTotal: UILabel!
    func setEntry(cSubName: String,cSubTotal:String){
        subName.text = cSubName
        subTotal.text = cSubTotal
    }

}
