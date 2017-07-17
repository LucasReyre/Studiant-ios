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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.connexionView.alpha = 0.0
        
        if let accessToken = AccessToken.current {
            // User is logged in, use 'accessToken' here.
            print("user connect")
        }else{
            print("user non connect")
        }
        // Do any additional setup after loading the view.
    }
    
    func myfonctionTest(){
        print("ma fonction test")
    }
    
    func showConnexion() {
        self.connexionView.alpha = 1.0
        /*UIView.animate(withDuration: 0.5, animations: {
            let xPosition = self.connexionView.frame.origin.x - self.connexionView.frame.width
            let yPosition = self.connexionView.frame.origin.y
            
            let rect = CGRect(x: xPosition, y: yPosition, width: self.connexionView.frame.size.width, height: self.connexionView.frame.size.height)
            self.connexionView.frame = rect
            
        })*/
        
        //let loginButton = LoginButton(readPermissions: [ .publicProfile, .email ])
        //loginButton.center = view.center
        
        let loginButton = FBSDKLoginButton()
        loginButton.readPermissions = ["email", "public_profile"]
        loginButton.frame = CGRect(x: 0, y: 200, width: view.frame.width, height: 50)
        view.addSubview(loginButton)
        loginButton.delegate = self

    }
    
    
    @IBAction func backPressAction(_ sender: Any) {
        /*UIView.animate(withDuration: 0.5, animations: {
            let xPosition = self.connexionView.frame.origin.x + self.connexionView.frame.width
            let yPosition = self.connexionView.frame.origin.y
            
            let rect = CGRect(x: xPosition, y: yPosition, width: self.connexionView.frame.size.width, height: self.connexionView.frame.size.height)
            self.connexionView.frame = rect
            self.myViewController.onBackPressConnexionTouch()
            
        })*/
        self.connexionView.alpha = 0.0
        self.myViewController.onBackPressConnexionTouch()
    }

    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("logout")
    }
    
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if(error != nil){
            print(error)
        }
        performSegue(withIdentifier: "profilSegue", sender: self)
    }
    
    

    override func didMove(toParentViewController parent: UIViewController?) {
        super.didMove(toParentViewController: parent)
        myViewController = parent as! MainViewController
        
    }

    
}
