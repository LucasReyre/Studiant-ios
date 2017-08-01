//
//  DemoCell.swift
//  FoldingCell
//
//  Created by Alex K. on 25/12/15.
//  Copyright © 2015 Alex K. All rights reserved.
//

import UIKit
import FoldingCell
import TRON

class DemoCell: FoldingCell {
  
    @IBOutlet weak var heureContentLabel: UILabel!
    @IBOutlet weak var dateLabelContent: UILabel!
    @IBOutlet weak var adresseLabelContent: UILabel!
  @IBOutlet weak var closeNumberLabel: UILabel!
  @IBOutlet weak var openNumberLabel: UILabel!
    @IBOutlet weak var categorieLabel: UILabel!
    @IBOutlet weak var adresseLabel: UILabel!
    @IBOutlet weak var tarifContentLabel: UILabel!
    @IBOutlet weak var horaireLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tarifHeaderLabel: UILabel!
    @IBOutlet weak var nomPrenomLabel: UILabel!
    let tron = TRON(baseURL: "https://fcm.googleapis.com/")
    var job : JobResponse?
    
  var number: Int = 0 {
    didSet {
      closeNumberLabel.text = String(number)
      openNumberLabel.text = String(number)
    }
  }
  
    func setupUi(jobResponse: JobResponse) {
        job = jobResponse
        categorieLabel.text = jobResponse.categorieJob
        adresseLabel.text = jobResponse.adresseJob
        tarifHeaderLabel.text = jobResponse.prixJob + "€"
        tarifContentLabel.text = jobResponse.prixJob + "€"
        horaireLabel.text = jobResponse.heureJob
        dateLabel.text = jobResponse.dateJob
        nomPrenomLabel.text = jobResponse.appartenir.prenomUtilisateur+" "+jobResponse.appartenir.nomUtilisateur
        adresseLabelContent.text = jobResponse.adresseJob
        dateLabelContent.text = jobResponse.dateJob
        heureContentLabel.text = jobResponse.heureJob
        
    }
  override func awakeFromNib() {
    foregroundView.layer.cornerRadius = 10
    foregroundView.layer.masksToBounds = true
    super.awakeFromNib()
  }
  
  override func animationDuration(_ itemIndex: NSInteger, type: FoldingCell.AnimationType) -> TimeInterval {
    let durations = [0.26, 0.2, 0.2]
    return durations[itemIndex]
  }
  
}

// MARK: - Actions ⚡️
extension DemoCell {
  
  @IBAction func buttonHandler(_ sender: AnyObject) {
    print("tap")
    /*
    let postRequest: APIRequest<JobResponse, ErrorResponse> = tron.request("fcm/send")
    postRequest.method = .post
    
    postRequest.headers["Authorization"] = "key=AAAA6imzCUY:APA91bFW3SFt53D9Pb_mR6APrsRKp2ouXpyELZwvmHBH4oLNmzSOoNMoetPIwnsTyPSY12j8hzxjqgkXfJLqcEB2puRXsCem5ujyJgFzt3ANBcVb1MWZZ3Y3Z9Jt6D26FqhyPHUzzz6w"
    let notification = ["title":"Application Studiant", "text":"Une personne à postulé"]
    postRequest.parameters = ["to": job!.appartenir.firebaseToken,
                              "priority" : "high",
                              "project_id": "studiant-103b8",
                              "notification": notification,
                              "content_available": true]
    
    print(postRequest.parameters)
    //postRequest.perform()
    postRequest.perform(withSuccess: { (jobResponse) in
        print(jobResponse)
        //self.performSegue(withIdentifier: "AjoutJobSegue", sender: self)
    }) { (error) in
        print(error)
    }*/
  }
  
}
