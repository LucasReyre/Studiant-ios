//
//  PayinResponse.swift
//  Studiant
//
//  Created by Lucas REYRE on 20/08/2017.
//  Copyright © 2017 Studiant. All rights reserved.
//

import Foundation
import TRON
import SwiftyJSON

struct PayinResponse: JSONDecodable{
    
    let creditedWalletId: String
    let paymentType: String
    let status: String
    let resultCode: String
    let type: String
    
    init(json: JSON) {
        creditedWalletId = json["CreditedWalletId"].stringValue
        paymentType = json["PaymentType"].stringValue
        status = json["Status"].stringValue
        resultCode = json["ResultCode"].stringValue
        type = json["Type"].stringValue
        
    }
    
}
