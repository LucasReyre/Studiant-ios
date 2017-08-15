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

class CellJobEtudiant: FoldingCell {
    
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
    @IBOutlet weak var leftView: UIView!
    let tron = TRON(baseURL: "https://loopbackstudiant.herokuapp.com/api/")
    var job : JobResponse?
    var categorie: Categorie?
    
    var delegate : CellJobEtudiantDelegate?
    
    var number: Int = 0 {
        didSet {
            
            openNumberLabel.text = String(number)
        }
    }
    
    func setupUi(jobResponse: JobResponse, delegate: CellJobEtudiantDelegate) {
        self.delegate = delegate
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
        
        categorie = Categorie(withString: jobResponse.categorieJob)
        leftView.backgroundColor = categorie?.color
        pictoCategorieImageView.image = categorie?.picto

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
extension CellJobEtudiant {
    
    @IBAction func buttonHandler(_ sender: AnyObject) {
        print("tap")
        self.delegate?.onPostulerTouch(jobId: (self.job?.idJob)!)
        
    }
}

protocol CellJobEtudiantDelegate {
    func onPostulerTouch(jobId: String)
}
