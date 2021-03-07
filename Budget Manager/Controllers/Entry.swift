//
//  Entry.swift
//  Budget Manager
//
//  Created by Cenk Donmez on 22.12.2020.
//  Copyright © 2020 CTIS. All rights reserved.
//

import Foundation
import UIKit

class Entry {
    var type: String
    var category: String
    var source: String
    var amount: String
    var day: String
    var dayInWeek: String
    var year: String
    var month: String
    init(type: String,category:String,source: String,amount:String,day:String,dayInWeek:String,year:String,month:String) {
        self.type = type
        self.category = category
        self.source = source
        self.amount = amount
        self.day = day
        self.dayInWeek = dayInWeek
        self.year = year
        self.month = month


    }
}
