//
//  ErrorResponse.swift
//  Studiant
//
//  Created by Lucas REYRE on 17/07/2017.
//  Copyright © 2017 Studiant. All rights reserved.
//

import Foundation
import TRON
import SwiftyJSON

struct ErrorResponse: JSONDecodable{
    
    init(json: JSON) throws {
        print("JSON \(json)" )
        print("JSON parsing error")
    }

}
