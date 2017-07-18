//
//  NumberPickerViewController.swift
//  PickerView
//
//  Created by Filipe Alvarenga on 09/08/15.
//  Copyright (c) 2015 Filipe Alvarenga. All rights reserved.
//

import UIKit

class CategoriePickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    
    var categorie = ["Aide à la personne", "Aide scolaire", "Entretient", "Ménage", "Bricolage","Autres"]
    var delegate: CategoriePickerViewDelegate? = nil
    
    @IBOutlet weak var pickerView: UIPickerView!
    var updateSelectedValue: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categorie[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categorie.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(categorie[row])
        updateSelectedValue = categorie[row]
    }
    
 
    @IBAction func validate(_ sender: Any) {
        self.delegate?.validateCategorie(controller: self, categorie: updateSelectedValue!)
        //dismiss(animated: true, completion: nil)
    }

    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

protocol CategoriePickerViewDelegate {
    func validateCategorie(controller: CategoriePickerViewController,categorie: String)
}
