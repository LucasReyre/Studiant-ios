//
//  DashboardEtudiantViewController.swift
//  Studiant
//
//  Created by Lucas REYRE on 17/07/2017.
//  Copyright © 2017 Studiant. All rights reserved.
//

import UIKit
import PopupDialog

class DashboardEtudiantViewController: UIViewController {

    @IBOutlet weak var filterFloatingButton: UIButton!
    var tableContainer: MainTableViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        filterFloatingButton.layer.cornerRadius = 0.5 * filterFloatingButton.bounds.size.width
        filterFloatingButton.clipsToBounds = true
    }

    @IBAction func filterAction(_ sender: Any) {
        
        // Create a custom view controller
        let filterVc = FilterViewController(nibName: "FilterViewController", bundle: nil)
        
        // Create the dialog
        let popup = PopupDialog(viewController: filterVc, buttonAlignment: .vertical, transitionStyle: .bounceUp, gestureDismissal: true)
       
        self.tableContainer.filter = nil
        // Create second button
        let buttonTwo = DefaultButton(title: "Valider", height: 60) {
            print("categorie : ", filterVc.chooseCategorieLabel.text!)

            
            if filterVc.categorie != nil && filterVc.distance != nil && filterVc.lat != nil{
                let latlongString = filterVc.lat + "," + filterVc.long
                self.tableContainer.filter = ["filter[where][latlongJob][near]": latlongString,
                                              "filter[where][latlongJob][maxDistance]": filterVc.distance,
                                              "filter[where][latlongJob][unit]": "kilometers",
                                              "filter[where][categorieJob]": filterVc.categorie!,
                                              "filter[where][statutJob]": "0"]
            } else if filterVc.distance != nil && filterVc.lat != nil{
                let latlongString = filterVc.lat + "," + filterVc.long
                self.tableContainer.filter = ["filter[where][latlongJob][near]": latlongString,
                                              "filter[where][latlongJob][maxDistance]": filterVc.distance,
                                              "filter[where][latlongJob][unit]": "kilometers",
                                              "filter[where][statutJob]": "0"]
                
                print("have filter distance "+filterVc.distance+" - "+latlongString)
            } else if filterVc.categorie != nil{
                self.tableContainer.filter = ["filter[where][categorieJob]": filterVc.categorie!,
                                              "filter[where][statutJob]": "0"]
                print("have filter categorie")
            }
            
            print("count : ",self.tableContainer.filter!.count)
            
            self.tableContainer.getData()
        }
        
        // Add buttons to dialog
        popup.addButtons([buttonTwo])
        
        // Present dialog
        present(popup, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("prepare segue")
        if let vc = segue.destination as? MainTableViewController,
            segue.identifier == "listJobEtudiantEmbedSegue" {
            print("listJobEtudiantEmbedSegue")
            self.tableContainer = vc
            //self.tableContainer.delegate = self
        }
    }
}
