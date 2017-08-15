//
//  MangoServices.swift
//  Studiant
//
//  Created by Lucas REYRE on 03/08/2017.
//  Copyright © 2017 Studiant. All rights reserved.
//

import Foundation
import TRON

struct MangoServices {
     static let tron = TRON(baseURL: "https://www.studiant.fr/mangoApi/demos/")
    
    static func getCard(id: Int) -> APIRequest<UserResponse, ErrorResponse> {
        return tron.request("user_get_card.php/\(id)")
    }

    
    
}
