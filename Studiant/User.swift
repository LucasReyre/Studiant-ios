//
//  User.swift
//  Studiant
//
//  Created by Lucas REYRE on 16/07/2017.
//  Copyright © 2017 Studiant. All rights reserved.
//

import Foundation
import TRON

public class User {
    
    var idUtilisateur: String?
    var nomUtilisateur: String?
    var prenomUtilisateur: String?
    var mailUtilisateur: String?
    var photoUtilisateur: String?
    var typeUtilisateur: Int!
    var telephoneUtilisateur: String?
    var idIbanUtilisateur: String?
    var typeConnexionUtilisateur: Int?
    var idMangoPayUtilisateur: String?
    var descriptionUtilisateur: String?
    var diplomeUtilisateur: String?
    var permisUtilisateur: Bool?
    var idExterneUtilisateur: String?
    var idWalletUtilisateur: String?
    
    let tron = TRON(baseURL: "https://loopbackstudiant.herokuapp.com/api/")
    var userUrl = "https://loopbackstudiant.herokuapp.com/api/Utilisateurs/594e691306f7e60011421949"
    typealias JSONStandard = [String : AnyObject]
    
    init(){
        
    }
    
    init(idUtilisateur: String, typeUtilisateur: Int) {
        self.idUtilisateur = idUtilisateur
        self.typeUtilisateur = typeUtilisateur
    }
    
    init(nomUtilisateur: String, prenomUtilisateur: String, mailUtilisateur: String) {
        self.nomUtilisateur = nomUtilisateur
        self.prenomUtilisateur = prenomUtilisateur
        self.mailUtilisateur = mailUtilisateur
    }
    
    init(nomUtilisateur: String, prenomUtilisateur: String, mailUtilisateur: String, photoUtilisateur: String) {
        self.nomUtilisateur = nomUtilisateur
        self.prenomUtilisateur = prenomUtilisateur
        self.mailUtilisateur = mailUtilisateur
        self.photoUtilisateur = photoUtilisateur
    }
    
    func getUsers() {
        let request: APIRequest<UsersResponse, ErrorResponse> = tron.request("Utilisateurs/")
        print(request)
        request.perform(withSuccess: { (usersResponse) in
            print(usersResponse.users)
        }) { (error) in
            print(error)
        }
    }

    
    func parseData(JSONData : Data){
        do{
            var readableJSON = try JSONSerialization.jsonObject(with: JSONData, options: .mutableContainers) as! JSONStandard
            
            let mail = readableJSON["mailUtilisateur"]
            print(readableJSON)
            print(mail)
            
        }catch{
            print(error)
        }
    }
    
}
