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

struct UserResponse: JSONDecodable{
    
    let idUtilisateur: String
    let nomUtilisateur: String
    let prenomUtilisateur: String
    let mailUtilisateur: String
    let photoUtilisateur: String
    let descriptionUtilisateur: String
    let typeUtilisateur: Int
    let typeConnexionUtilisateur: Int
    let permisUtilisateur: Bool
    let idExterneUtilisateur: String
    let diplomeUtilisateur: String
    
    
    init(json: JSON) {
        
        idUtilisateur = json["id"].stringValue
        nomUtilisateur = json["nomUtilisateur"].stringValue
        prenomUtilisateur = json["prenomUtilisateur"].stringValue
        mailUtilisateur = json["mailUtilisateur"].stringValue
        photoUtilisateur = json["photoUtilisateur"].stringValue
        descriptionUtilisateur = json["descriptionUtilisateur"].stringValue
        typeUtilisateur = json["typeUtilisateur"].intValue
        typeConnexionUtilisateur = json["typeConnexionUtilisateur"].intValue
        permisUtilisateur = json["permisUtilisateur"].boolValue
        idExterneUtilisateur = json["idExterneUtilisateur"].stringValue
        diplomeUtilisateur = json["diplomeUtilisateur"].stringValue
    }
    
}