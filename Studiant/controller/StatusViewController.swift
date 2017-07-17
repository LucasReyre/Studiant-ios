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

    @IBAction func onEtudiantTouch(_ sender: Any) {
        UIView.animate(withDuration: 0.5, animations: {
            self.myViewController.onEtudiantTouch()
            let xPosition = self.statusView.frame.origin.x - self.statusView.frame.width
            let yPosition = self.statusView.frame.origin.y
            
            let rect = CGRect(x: xPosition, y: yPosition, width: self.statusView.frame.size.width, height: self.statusView.frame.size.height)
            self.statusView.frame = rect
            
            
        })
    }
    
    @IBAction func particulierTouch(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5, animations: {
            self.myViewController.onParticulierTouch()
            let xPosition = self.statusView.frame.origin.x - self.statusView.frame.width
            let yPosition = self.statusView.frame.origin.y
            
            let rect = CGRect(x: xPosition, y: yPosition, width: self.statusView.frame.size.width, height: self.statusView.frame.size.height)
            self.statusView.frame = rect
            
            
        })
        
    }
    
    override func didMove(toParentViewController parent: UIViewController?) {
        super.didMove(toParentViewController: parent)
        myViewController = parent as! MainViewController
        
    }

}
