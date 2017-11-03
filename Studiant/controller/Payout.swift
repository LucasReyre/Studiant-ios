//
//  CardReg.swift
//  Studiant
//
//  Created by Lucas REYRE on 02/08/2017.
//  Copyright © 2017 Studiant. All rights reserved.
//

import Foundation
import TRON
import SwiftyJSON

struct PayoutResponse: JSONDecodable{
    
    let idPayout: String
    let status: String
    
    init(json: JSON) {
        
        idPayout = json["Id"].stringValue
        status = json["Status"].stringValue
        
    }
    
}

