//
//  UsersResponse.swift
//  Studiant
//
//  Created by Lucas REYRE on 17/07/2017.
//  Copyright © 2017 Studiant. All rights reserved.
//

import Foundation
import TRON
import SwiftyJSON

struct UsersResponse: JSONDecodable {
    
    let users: [UserResponse]
    
    init(json: JSON) throws {
        let usersArray = json.arrayValue
        users = usersArray.map({UserResponse(json: $0)})
    }
}