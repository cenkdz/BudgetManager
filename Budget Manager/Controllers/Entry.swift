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
    var day: String
    var dayInWeek: String
    var year: String
    var month: String
    var id: String
    var uid: String
    var recurring: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(day)
    }
    
    init(type: String,category:String,source: String,amount:String,day:String,dayInWeek:String,year:String,month:String,id:String,uid:String,recurring:String) {
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
        self.recurring = recurring
    }
    func getDictionary() -> [String: Any]{
        return ["type": type,"category":category,"source":source,"amount":amount,"day":day,"dayInWeek":dayInWeek,"year":year,"month":month,"id":id,"uid":uid,"recurring":recurring]
    }
}
