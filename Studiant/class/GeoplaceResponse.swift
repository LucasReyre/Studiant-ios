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


struct GeoplaceResponse: JSONDecodable{
    var latitude: Float
    var longitude: Float
    
    
    init(json: JSON) {
        latitude = json["lat"].floatValue
        longitude = json["lng"].floatValue
    }    
    
}
