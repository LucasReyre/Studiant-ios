//
//  UserResponse.swift
//  Studiant
//
//  Created by Lucas REYRE on 17/07/2017.
//  Copyright © 2017 Studiant. All rights reserved.
//

import Foundation
import TRON
import SwiftyJSON

struct NotificationResponse: JSONDecodable{
    
    let multicastId: String
    let success: String
    let failure: String

    
    init(json: JSON) {
        
        multicastId = json["multicast_id"].stringValue
        success = json["success"].stringValue
        failure = json["failure"].stringValue
    }
    
}

