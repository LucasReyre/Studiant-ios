//
//  MainViewController.swift
//  Studiant
//
//  Created by Lucas REYRE on 12/07/2017.
//  Copyright © 2017 Studiant. All rights reserved.
//

import UIKit
import PopupDialog

class ReglagesParticulierViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    

    @IBAction func onDeconnexionTouch(_ sender: Any) {
        
        let popup = PopupDialog(title: "Attention", message: "En vous déconnectant vos données seront perdues")
        
        // Create buttons
        let buttonOne = DefaultButton(title: "VALIDEZ") {
            KeychainService.deleteAll()
            self.performSegue(withIdentifier: "deconnexionSegue", sender: self)
        }
        
        let buttonTwo = DefaultButton(title: "ANNULEZ") {
        }
        
        popup.addButtons([buttonOne, buttonTwo])
        self.present(popup, animated: true, completion: nil)
        
        
    }
    
}

