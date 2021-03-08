//
//  Entry.swift
//  Budget Manager
//
//  Created by Cenk Donmez on 22.12.2020.
//  Copyright © 2020 CTIS. All rights reserved.
//

import Foundation
import UIKit

class Entry: Hashable,Equatable,Comparable {
    static func < (lhs: Entry, rhs: Entry) -> Bool {
        return lhs.day == rhs.day
    }
    
    static func == (lhs: Entry, rhs: Entry) -> Bool {
        return lhs.day == rhs.day
    }

    var type: String
    var category: String
    var source: String
    var amount: String
    var day: Int
    var dayInWeek: String
    var year: String
    var month: String
    var id: String
    var uid: String
    
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(day)
    }
    
    
    init(type: String,category:String,source: String,amount:String,day:Int,dayInWeek:String,year:String,month:String,id:String,uid:String) {
        self.type = type
        self.category = category
        self.source = source
        self.amount = amount
        self.day = day
        self.dayInWeek = dayInWeek
        self.year = year
        self.month = month
        self.id = id
        self.uid = uid


    }
}
