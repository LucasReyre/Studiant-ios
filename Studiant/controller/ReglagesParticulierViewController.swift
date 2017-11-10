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
        KeychainService.deleteAll()
        self.performSegue(withIdentifier: "deconnexionSegue", sender: self)
        
    }
    
}

