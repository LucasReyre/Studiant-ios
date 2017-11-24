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

struct PostulantResponse: JSONDecodable{
    
    let timePostulant: String
    let statutPostulant: String
    let id: String
    let jobId: String
    let utilisateurId: String
    
    init(json: JSON) {
        
        timePostulant = json["timePostulant"].stringValue
        statutPostulant = json["statutPostulant"].stringValue
        id = json["id"].stringValue
        jobId = json["jobId"].stringValue
        utilisateurId = json["utilisateurId"].stringValue
    }
    
}


