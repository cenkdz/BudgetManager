//
//  Category.swift
//  Budget Manager
//
//  Created by Cenk Donmez on 22.12.2020.
//  Copyright © 2020 CTIS. All rights reserved.
//

import Foundation
import UIKit
class Source {
    var sourceID: String
    var sourceIcon: String
    var sourceName: String
    var uid: String
    init(sourceID:String,sourceName:String,sourceIcon: String,uid: String) {
        self.sourceID = sourceID
        self.sourceName = sourceName
        self.sourceIcon = sourceIcon
        self.uid = uid
        
    }
    
    func getDictionary() -> [String: Any]{
         return ["source_id": sourceID,"source_name":sourceName,"source_icon":sourceIcon,"uid":uid]
     }
}
