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
import SwiftSpinner

class CellPostulants: FoldingCell {
 
    @IBOutlet weak var etudesLabelContent: UILabel!
    @IBOutlet weak var nomLabelHeader: UILabel!
    @IBOutlet weak var prenomLabelHeader: UILabel!
    @IBOutlet weak var openNumberLabel: UILabel!

    @IBOutlet weak var profileImage: UIImageView!

    @IBOutlet weak var diplomeLabelHeader: UILabel!
 
    @IBOutlet weak var prenomLabelContent: UILabel!

    @IBOutlet weak var nomLabelContent: UILabel!
    
    @IBOutlet weak var descriptionLabelContent: UILabel!
    
    var job : JobResponse!
    
    var delegate : CellPostulantDelegate?
    
    let tron = TRON(baseURL: "https://loopbackstudiant.herokuapp.com/api/")
    let tronStudiant = TRON(baseURL: "https://www.studiant.fr/notification/")
    
    var postulant : UserResponse!
    
    var number: Int = 0 {
        didSet {
            openNumberLabel.text = String(number)
        }
    }
    
    func setupUi(postulant: UserResponse,job: JobResponse,delegate: CellPostulantDelegate) {
        self.postulant = postulant
        self.job = job
        nomLabelHeader.text = postulant.nomUtilisateur
        prenomLabelHeader.text = postulant.prenomUtilisateur
        diplomeLabelHeader.text = postulant.diplomeUtilisateur
        prenomLabelContent.text = postulant.prenomUtilisateur
        nomLabelContent.text = postulant.nomUtilisateur
        etudesLabelContent.text = postulant.diplomeUtilisateur
        //descriptionLabelContent.text = postulant.descriptionUtilisateur
        
        let url = URL(string: postulant.photoUtilisateur)
        self.profileImage.hnk_setImageFromURL(url!)
        
        self.delegate = delegate
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
    
    @IBAction func choosePostulantAction(_ sender: Any) {
        
        let url = "Jobs/" + job.idJob + "/replace"
        let post : APIRequest<JobResponse, ErrorResponse> = tron.request(url)
        post.method = .post
        
        var geoplace=["lat" : job.geoplace.latitude, "lng" : job.geoplace.longitude]
        
        post.parameters = ["descriptionJob": job.descriptionJob,
                                  "prixJob": job.prixJob,
                                  "adresseJob": job.adresseJob,
                                  "latlongJob" : geoplace,
                                  "dateJob" : job.dateJob,
                                  "heureJob": job.heureJob,
                                  "categorieJob": job.categorieJob,
                                  "statutJob": "1",
                                  "villeJob": job.villeJob,
                                  "utilisateurId": job.idUtilisateur,
                                  "typePaiementJob": job.typePaiementJob,
                                  "postulantId": postulant.idUtilisateur]
        
        SwiftSpinner.show("Sélection de l'étudiant en cours")
        
        post.perform(withSuccess: { (jobResponse) in
            print(jobResponse)
            
            let postRequest: APIRequest<NotificationResponse, ErrorResponse> = self.tronStudiant.request("notification.php")
            postRequest.method = .get
            
            let body : String = "Vous avez été sélectionné pour un job !"
            postRequest.parameters = ["token": self.postulant.firebaseToken]
            postRequest.parameters = ["body": body]
            
            postRequest.perform(withSuccess: { (notificationResponse) in
                print("success")
                print(notificationResponse)
                
            }) { (error) in
                print("error")
                print(error)
            }
            
            SwiftSpinner.show("Etudiant validé", animated: false).addTapHandler({
                SwiftSpinner.hide()
                self.delegate?.onButtonChoosePostulant()
                
            })
            
        }) { (error) in
            SwiftSpinner.show("Une erreure est survenue", animated: false).addTapHandler({
                SwiftSpinner.hide()
                self.delegate?.onButtonChoosePostulant()
                
            })
            print(error)
        }
    }
}

// MARK: - Actions ⚡️
extension CellPostulants {
    

    
}

protocol CellPostulantDelegate {
    func onButtonChoosePostulant()
}
