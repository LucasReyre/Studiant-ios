//
//  geoplaceResponse.swift
//  Studiant
//
//  Created by Lucas REYRE on 30/07/2017.
//  Copyright © 2017 Studiant. All rights reserved.
//

import Foundation
import TRON
import SwiftyJSON


struct MoneyResponse: JSONDecodable{
    var amount: String
    //var longitude: String
    
    init(json: JSON) {
        amount = json["Amount"].stringValue
        //longitude = json["lng"].floatValue
    }
    
}

