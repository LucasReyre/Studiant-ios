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
    
    @IBAction func facebookAction(_ sender: Any) {
        
        guard let url = URL(string: "https://www.facebook.com/StudiantOfficiel/") else {
            return //be safe
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    @IBAction func twitterAction(_ sender: Any) {
        
        guard let url = URL(string: "https://twitter.com/s_tudiant") else {
            return //be safe
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    @IBAction func studientWebAction(_ sender: Any) {
        
        guard let url = URL(string: "http://www.studiant.fr/") else {
            return //be safe
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
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

