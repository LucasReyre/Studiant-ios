//
//  FilterViewController.swift
//  Studiant
//
//  Created by Lucas REYRE on 28/07/2017.
//  Copyright © 2017 Studiant. All rights reserved.
//

import UIKit
import CoreLocation

class FilterViewController: UIViewController, UIGestureRecognizerDelegate, CategoriePickerViewDelegate,  CLLocationManagerDelegate {

    @IBOutlet weak var chooseCategorieLabel: UILabel!
    @IBOutlet weak var categorieView: UIView!
    @IBOutlet weak var maxDistanceLabel: UILabel!
    
    var categorie: String!
    var distance: String!
    var lat: String!
    var long: String!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        askPosition()

        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tap(_:)))
        tap.delegate = self
        categorieView.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }
    
    func askPosition() {
        // Ask for Authorisation from the User.
        self.locationManager.requestWhenInUseAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func tap(_ gestureRecognizer: UITapGestureRecognizer) {
        categorieView.alpha = 0.5
        UIView.animate(withDuration: 0.3, animations: {
            self.categorieView.alpha = 1
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "CategoriePickerViewController") as! CategoriePickerViewController
            controller.delegate = self
            self.present(controller, animated: true, completion: nil)
        })
    }
    

    func validateCategorie(controller: CategoriePickerViewController, categorie: String) {
        controller.dismiss(animated: true, completion: nil)
        self.categorie = categorie
        chooseCategorieLabel.text = categorie        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func distanceValueChanged(_ sender: UISlider) {
        
        maxDistanceLabel.text = "\(Int(sender.value)) km max"
        distance = String(describing: sender.value)
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension FilterViewController {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        lat = String(describing: locValue.latitude)
        long = String(describing: locValue.longitude)
        locationManager.stopUpdatingLocation()
    }
}
