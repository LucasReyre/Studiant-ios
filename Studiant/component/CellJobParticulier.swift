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

class CellJobParticulier: FoldingCell {
    
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
    let tron = TRON(baseURL: "https://fcm.googleapis.com/")
    var job : JobResponse?
    var categorie: Categorie?
    
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
        
        categorie = Categorie(withString: jobResponse.categorieJob)
        leftView.backgroundColor = categorie?.color
        pictoCategorieImageView.image = categorie?.picto
        pictoCategorieContentImageView.image = categorie?.picto
        
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
extension CellJobParticulier {
    
    @IBAction func buttonHandler(_ sender: AnyObject) {
        self.delegate?.onButtonVoirPostulantTouch(postulants: (job?.postulants)!)
        
    }
    
}

protocol CellJobParticulierDelegate {
    func onButtonVoirPostulantTouch(postulants: UsersResponse)
}
