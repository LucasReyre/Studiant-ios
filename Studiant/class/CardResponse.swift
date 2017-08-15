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

struct CardResponse: JSONDecodable{
    
    let expirationDate: String
    let alias: String
    let cardType: String
    let cardProvider: String
    let country: String
    let validity: String
    let userId: String
    let id: String
    
    init(json: JSON) {
        
        expirationDate = json["ExpirationDate"].stringValue
        alias = json["Alias"].stringValue
        cardType = json["CardType"].stringValue
        cardProvider = json["CardProvider"].stringValue
        country = json["Country"].stringValue
        validity = json["Validity"].stringValue
        userId = json["UserId"].stringValue
        id = json["Id"].stringValue
        
    }
    
}
