//
//  MainViewController.swift
//  Studiant
//
//  Created by Lucas REYRE on 12/07/2017.
//  Copyright © 2017 Studiant. All rights reserved.
//

import UIKit
import SwiftSpinner
import TRON

class ReglagesEtudiantViewController: UIViewController {
    let tron = TRON(baseURL: "https://loopbackstudiant.herokuapp.com/api/")
    
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    @IBAction func onDeconnexionTouch(_ sender: Any) {
        user = KeychainService.loadUser()
                
        let postRequest: APIRequest<UserResponse, ErrorResponse> = tron.request("Utilisateurs/")
        postRequest.method = .patch
        
        postRequest.parameters = ["firebaseToken": "",
                                  "id": user.idUtilisateur!]
        
        postRequest.perform(withSuccess: { (userResponse) in
        }) { (error) in
            print("Error")
            print(error)
        }
        
        KeychainService.deleteAll()
        self.performSegue(withIdentifier: "deconnexionSegue", sender: self)
    }
    
}

