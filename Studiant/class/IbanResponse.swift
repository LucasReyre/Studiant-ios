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

struct IbanResponse: JSONDecodable{
    
    let active: String
    let creationDate: String
    let ownerName: String
    let userId: String
    let id: String
    let type: String
    
    init(json: JSON) {
        active = json["Active"].stringValue
        creationDate = json["CreationDate"].stringValue
        ownerName = json["OwnerName"].stringValue
        userId = json["UserId"].stringValue
        id = json["Id"].stringValue
        type = json["Type"].stringValue
    }
    
}

