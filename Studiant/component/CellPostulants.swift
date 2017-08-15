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
    
    var delegate : CellPostulantDelegate?
    
    let tron = TRON(baseURL: "https://fcm.googleapis.com/")
    var postulant : UserResponse!
    
    var number: Int = 0 {
        didSet {
            openNumberLabel.text = String(number)
        }
    }
    
    func setupUi(postulant: UserResponse,delegate: CellPostulantDelegate) {
        self.postulant = postulant
        nomLabelHeader.text = postulant.nomUtilisateur
        prenomLabelHeader.text = postulant.prenomUtilisateur
        diplomeLabelHeader.text = postulant.diplomeUtilisateur
        prenomLabelContent.text = postulant.prenomUtilisateur
        nomLabelContent.text = postulant.nomUtilisateur
        etudesLabelContent.text = postulant.diplomeUtilisateur
        descriptionLabelContent.text = postulant.descriptionUtilisateur
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
        SwiftSpinner.show("Coming soon", animated: false).addTapHandler({
            SwiftSpinner.hide()
            self.delegate?.onButtonChoosePostulant()

        })
    }
}

// MARK: - Actions ⚡️
extension CellPostulants {
    

    
}

protocol CellPostulantDelegate {
    func onButtonChoosePostulant()
}