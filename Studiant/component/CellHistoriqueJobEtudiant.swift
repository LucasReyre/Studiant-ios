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

class CellHistoriqeJobEtudiant: FoldingCell {
    
    @IBOutlet weak var jobDoneButton: UIButton!
    @IBOutlet weak var validateButton: RotatedView!
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
    @IBOutlet weak var pictoCategorieImageView: UIImageView!
    //let tron = TRON(baseURL: "https://fcm.googleapis.com/")
    @IBOutlet weak var pictoCategorieImageView2: UIImageView!
    @IBOutlet weak var telephoneLabel: UILabel!
    @IBOutlet weak var tarifImageView: UIImageView!
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var job : JobResponse?
    var categorie: Categorie?
    
    var delegate : CellHistoriqeJobEtudiantDelegate?
    
    var number: Int = 0 {
        didSet {
            
            openNumberLabel.text = String(number)
        }
    }
    
    func setupUi(jobResponse: JobResponse, delegate: CellHistoriqeJobEtudiantDelegate) {
        self.delegate = delegate
        job = jobResponse
        categorieLabel.text = jobResponse.categorieJob
        adresseLabel.text = jobResponse.villeJob
        
        horaireLabel.text = jobResponse.heureJob
        dateLabel.text = jobResponse.dateJob
        descriptionTextView.text = jobResponse.descriptionJob
        //nomPrenomLabel.text = jobResponse.appartenir.prenomUtilisateur+" "+jobResponse.appartenir.nomUtilisateur
        nomPrenomLabel.text = jobResponse.appartenir.prenomUtilisateur
        
        dateLabelContent.text = jobResponse.dateJob
        heureContentLabel.text = jobResponse.heureJob
        
        categorie = Categorie(withString: jobResponse.categorieJob)
        //leftView.backgroundColor = categorie?.color
        pictoCategorieImageView.image = categorie?.picto
        
        pictoCategorieImageView2.image = categorie?.picto
        leftView.backgroundColor = UIColor(patternImage: UIImage(named: "backgroundJob")!)
        
        
        if (jobResponse.statusJob == "2") {
            jobDoneButton.isHidden = true
            telephoneLabel.text = ""
            adresseLabelContent.text = ""
            leftView.backgroundColor = UIColor.gray
        }else{
            jobDoneButton.isHidden = false
            telephoneLabel.text = jobResponse.appartenir.telephoneUtilisateur
            adresseLabelContent.text = jobResponse.adresseJob
        }
        
        switch jobResponse.typePaiementJob {
        case "CB":
            tarifImageView.image = UIImage(named: "credit-card")!
            let price:Float! = Float(jobResponse.prixJob)! - (Float(jobResponse.prixJob)!*15/100)
            tarifHeaderLabel.text = String(describing: price!) + "€"
            tarifContentLabel.text = String(describing: price!) + "€"
        case "CESU":
            tarifImageView.image = UIImage(named: "check")!
            tarifHeaderLabel.text = jobResponse.prixJob
            tarifContentLabel.text = jobResponse.prixJob
        case "ESPECES":
            tarifImageView.image = UIImage(named: "change")!
            tarifHeaderLabel.text = jobResponse.prixJob
            tarifContentLabel.text = jobResponse.prixJob
        default:
            tarifImageView.image = UIImage(named: "change")!
            tarifHeaderLabel.text = jobResponse.prixJob
            tarifContentLabel.text = jobResponse.prixJob
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
    
}

// MARK: - Actions ⚡️
extension CellHistoriqeJobEtudiant {
    
    @IBAction func buttonHandler(_ sender: AnyObject) {
        self.delegate?.onAskPaiementTouch(job:job!)
        
    }
}

protocol CellHistoriqeJobEtudiantDelegate {
    func onAskPaiementTouch(job: JobResponse)
}

