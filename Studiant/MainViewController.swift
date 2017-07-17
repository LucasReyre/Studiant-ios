//
//  MainViewController.swift
//  Studiant
//
//  Created by Lucas REYRE on 12/07/2017.
//  Copyright © 2017 Studiant. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    
    @IBOutlet weak var connexionView: UIView!
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var statusView: UIView!
    

    @IBOutlet weak var heightConnexionContraint: NSLayoutConstraint!
    var connexionContainer: ConnexionViewController!
    var statusContainer: StatusViewController!
    var oldHeightConnexionConstraint: CGFloat = 0.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.bringSubview(toFront: statusView)
        //oldHeightConnexionConstraint = heightConnexionContraint.constant
        //heightConnexionContraint.constant = 0
    }

    
    func onParticulierTouch() {
        //heightConnexionContraint.constant = oldHeightConnexionConstraint
        print("touch")
    }
    
    func onEtudiantTouch(){
        connexionContainer.showConnexion()
    }
    
    func onBackPressConnexionTouch() {
        //heightConnexionContraint.constant = 0
        statusContainer.show()
        mainView.bringSubview(toFront: statusView)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ConnexionViewController,
            segue.identifier == "connexionSegue" {
            self.connexionContainer = vc
        }else if let vc = segue.destination as? StatusViewController,
            segue.identifier == "statusSegue" {
            self.statusContainer = vc
        }
    }
    

}

