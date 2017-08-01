//
//  ConnexionViewController.swift
//  Studiant
//
//  Created by Lucas REYRE on 15/07/2017.
//  Copyright © 2017 Studiant. All rights reserved.
//

import UIKit
import FacebookLogin
import FBSDKLoginKit
import FacebookCore


class ConnexionViewController: UIViewController, FBSDKLoginButtonDelegate {

    @IBOutlet var connexionView: UIView!
    var myViewController: MainViewController!
    var statusUser: Int!
    var categorieJob: String!
    var fromFacebook: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("status ", statusUser)
        
        let loginButton = FBSDKLoginButton()
        loginButton.readPermissions = ["email", "public_profile"]
        loginButton.frame = CGRect(x: 0, y: 200, width: view.frame.width, height: 50)
        view.addSubview(loginButton)
        loginButton.delegate = self
        
        if let accessToken = AccessToken.current {
            // User is logged in, use 'accessToken' here.
            print("user connect")
        }else{
            print("user non connect")
        }
        // Do any additional setup after loading the view.
    }
    
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("logout")
    }
    
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if(error != nil){
            print(error)
        }
        
        self.fromFacebook = true
        if statusUser == 1{
            self.performSegue(withIdentifier: "profilEtudiantSegue", sender: nil)
        } else if statusUser == 0{
            self.performSegue(withIdentifier: "profilParticulierSegue", sender: nil)
        }
        
    }
    
    @IBAction func inscriptionAction(_ sender: Any) {
        self.fromFacebook = false
        if statusUser == 1{
            self.performSegue(withIdentifier: "profilEtudiantSegue", sender: nil)
        } else if statusUser == 0{
            self.performSegue(withIdentifier: "profilParticulierSegue", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = "Votre profil"
        navigationItem.backBarButtonItem = backItem
        
        if segue.identifier == "profilParticulierSegue" {
            let vc = segue.destination as! ProfilParticulierViewController
            vc.categorieJob = self.categorieJob
            vc.fromFacebook = self.fromFacebook
        }else if segue.identifier == "profilEtudiantSegue"{
            let vc = segue.destination as! ProfilEtudiantViewController
            vc.fromFacebook = self.fromFacebook
        }
    }
    
    /*

    override func didMove(toParentViewController parent: UIViewController?) {
        super.didMove(toParentViewController: parent)
        myViewController = parent as! MainViewController
        
    }
*/
    
}
