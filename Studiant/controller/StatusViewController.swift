//
//  StatusViewController.swift
//  Studiant
//
//  Created by Lucas REYRE on 14/07/2017.
//  Copyright © 2017 Studiant. All rights reserved.
//

import UIKit

class StatusViewController: UIViewController {
    
    @IBOutlet var statusView: UIView!
    var myViewController: MainViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true

        // Do any additional setup after loading the view.
    }
    
    func show(){
        UIView.animate(withDuration: 0.5, animations: {
            let xPosition = self.statusView.frame.origin.x + self.statusView.frame.width
            let yPosition = self.statusView.frame.origin.y
            
            let rect = CGRect(x: xPosition, y: yPosition, width: self.statusView.frame.size.width, height: self.statusView.frame.size.height)
            self.statusView.frame = rect
            
            
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "inscriptionEtudiantSegue" {
            let vc = segue.destination as! InscriptionViewController
            vc.statusUser = 1

            let backItem = UIBarButtonItem()
            backItem.title = "Inscription"
            navigationItem.backBarButtonItem = backItem
        } else if segue.identifier == "chooseCategorieSegue" {
            let backItem = UIBarButtonItem()
            backItem.title = "Catégorie"
            navigationItem.backBarButtonItem = backItem
        }else if segue.identifier == "profilEtudiantSegue"{
            let vc = segue.destination as! ProfilEtudiantViewController
            vc.fromFacebook = false
        }
    }

    @IBAction func connexionAction(_ sender: Any) {
        self.performSegue(withIdentifier: "connexionSegue", sender: nil)
    }
    @IBAction func onEtudiantTouch(_ sender: Any) {
        self.performSegue(withIdentifier: "profilEtudiantSegue", sender: nil)
        /*UIView.animate(withDuration: 0.5, animations: {
            self.myViewController.onEtudiantTouch()
            let xPosition = self.statusView.frame.origin.x - self.statusView.frame.width
            let yPosition = self.statusView.frame.origin.y
            
            let rect = CGRect(x: xPosition, y: yPosition, width: self.statusView.frame.size.width, height: self.statusView.frame.size.height)
            self.statusView.frame = rect
            
            
        })*/
    }
    
    @IBAction func particulierTouch(_ sender: UIButton) {
        /*UIView.animate(withDuration: 0.5, animations: {
            self.myViewController.onParticulierTouch()
            let xPosition = self.statusView.frame.origin.x - self.statusView.frame.width
            let yPosition = self.statusView.frame.origin.y
            
            let rect = CGRect(x: xPosition, y: yPosition, width: self.statusView.frame.size.width, height: self.statusView.frame.size.height)
            self.statusView.frame = rect
            
            
        })*/
        
    }
    
    /*
    override func didMove(toParentViewController parent: UIViewController?) {
        super.didMove(toParentViewController: parent)
        myViewController = parent as! MainViewController
        
    }
*/
}
