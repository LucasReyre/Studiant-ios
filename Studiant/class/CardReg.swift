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

struct CardReg: JSONDecodable{
    
    let accessKey: String
    let baseUrl: String
    let cardPreregistrationId: String
    let cardRegistrationUrl: String
    let cardType: String
    let clientId: String
    let preregistrationData: String

    
    
    init(json: JSON) {
        
        accessKey = json["AccessKey"].stringValue
        baseUrl = json["BaseUrl"].stringValue
        cardPreregistrationId = json["Id"].stringValue
        cardRegistrationUrl = json["CardRegistrationURL"].stringValue
        cardType = json["CardType"].stringValue
        clientId = json["ClientId"].stringValue
        preregistrationData = json["PreregistrationData"].stringValue
        
    }
    
}
