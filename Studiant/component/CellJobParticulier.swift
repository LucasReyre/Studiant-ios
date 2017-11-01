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
import PopupDialog
import SwiftSpinner

class CellJobParticulier: FoldingCell, UITextViewDelegate {
    
    @IBOutlet weak var seeStudiantButton: UIButton!
    @IBOutlet weak var paiementImageView: UIImageView!
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var pictoCategorieImageView: UIImageView!
    @IBOutlet weak var pictoCategorieContentImageView: UIImageView!
    @IBOutlet weak var heureContentLabel: UILabel!
    @IBOutlet weak var dateLabelContent: UILabel!
    @IBOutlet weak var adresseLabelContent: UILabel!
    @IBOutlet weak var openNumberLabel: UILabel!
    @IBOutlet weak var categorieLabel: UILabel!
    @IBOutlet weak var adresseLabel: UILabel!
    @IBOutlet weak var tarifContentLabel: UILabel!
    @IBOutlet weak var horaireLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tarifHeaderLabel: UILabel!
    @IBOutlet weak var nomPrenomLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    let tron = TRON(baseURL: "https://loopbackstudiant.herokuapp.com/api/")
    var job : JobResponse?
    var categorie: Categorie?
    
    @IBOutlet weak var studiantCodeButton: UIButton!
    var delegate : CellJobParticulierDelegate?
    
    
    var number: Int = 0 {
        didSet {
            openNumberLabel.text = String(number)
        }
    }
    
    func setupUi(jobResponse: JobResponse, delegate: CellJobParticulierDelegate) {
        self.delegate = delegate
        job = jobResponse
        categorieLabel.text = jobResponse.categorieJob
        adresseLabel.text = jobResponse.adresseJob
        tarifHeaderLabel.text = jobResponse.prixJob + "€"
        tarifContentLabel.text = jobResponse.prixJob + "€"
        horaireLabel.text = jobResponse.heureJob
        dateLabel.text = jobResponse.dateJob
        //nomPrenomLabel.text = jobResponse.appartenir.prenomUtilisateur+" "+jobResponse.appartenir.nomUtilisateur
        nomPrenomLabel.text = jobResponse.categorieJob
        adresseLabelContent.text = jobResponse.adresseJob
        dateLabelContent.text = jobResponse.dateJob
        heureContentLabel.text = jobResponse.heureJob
        descriptionTextView.text = jobResponse.descriptionJob
        
        descriptionTextView.delegate = self
        
        categorie = Categorie(withString: jobResponse.categorieJob)
        
        leftView.backgroundColor = UIColor(patternImage: UIImage(named: "backgroundJob")!)
        
        if (jobResponse.statusJob == "2") {
            seeStudiantButton.isHidden = true
            leftView.backgroundColor = UIColor.gray
        }else{
            seeStudiantButton.isHidden = false
        }
        //leftView.backgroundColor = categorie?.color
        pictoCategorieImageView.image = categorie?.picto
        pictoCategorieContentImageView.image = categorie?.picto
        
        switch jobResponse.typePaiementJob {
        case "CB":
            paiementImageView.image = UIImage(named: "credit-card")!
        case "CESU":
            paiementImageView.image = UIImage(named: "check")!
            studiantCodeButton.isHidden = true
        case "ESPECES":
            paiementImageView.image = UIImage(named: "change")!
            studiantCodeButton.isHidden = true
        default:
            paiementImageView.image = UIImage(named: "change")!
        }
        
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
 
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            descriptionTextView.resignFirstResponder()
            updateJob()
            return false
        }
        return true
    }
    
    func updateJob(){
        SwiftSpinner.show("Modification en cours")
        
        let postRequest: APIRequest<JobResponse, ErrorResponse> = tron.request("Jobs/")
        postRequest.method = .patch
        
        postRequest.parameters = ["descriptionJob": self.descriptionTextView.text!,
                                  "id": (job?.idJob)!]
        
        postRequest.perform(withSuccess: { (userResponse) in
            
            SwiftSpinner.show("Modification enregistrée", animated: false).addTapHandler({
                SwiftSpinner.hide()
            })
            
        }) { (error) in
            print(error)
            SwiftSpinner.show("Une erreure est survenue", animated: false).addTapHandler({
                SwiftSpinner.hide()
            })
            print("Error")
        }
    }
    
}

// MARK: - Actions ⚡️
extension CellJobParticulier {
    
    @IBAction func buttonHandler(_ sender: AnyObject) {
        self.delegate?.onButtonVoirPostulantTouch(postulants: (job?.postulants)!, job: job!)
    }
    
    @IBAction func studiantCodeAction(_ sender: Any) {
        
        let message : String
        let title : String
        
        if job?.typePaiementJob == "CB"{
            title = "Voici le code à transmettre à l'étudiant"
            message = (job?.idJob)!
        }else{
            title = "Le mode de paiement ne vous permet pas de transmettre de code"
            message = ""
        }
        
        
        // Create the dialog
        let popup = PopupDialog(title: title, message: message)
        
        // Create buttons
        let buttonOne = DefaultButton(title: "VALIDEZ") {
        }
        
        popup.addButtons([buttonOne])
        
        UIApplication.shared.keyWindow?.rootViewController?.present(popup, animated: true, completion: nil)
        
    }
    
}

protocol CellJobParticulierDelegate {
    func onButtonVoirPostulantTouch(postulants: UsersResponse, job: JobResponse)
}
