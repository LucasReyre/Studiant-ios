//
//  AddCBViewController.swift
//  Studiant
//
//  Created by Lucas REYRE on 08/08/2017.
//  Copyright © 2017 Studiant. All rights reserved.
//

import UIKit
import TRON
import mangopay

class AddCBViewController: UIViewController {
    @IBOutlet weak var numberCBTextField: UITextField!
    
    @IBOutlet weak var mmCBTextField: UITextField!
    
    @IBOutlet weak var ccvCBTextField: UITextField!
    
    @IBOutlet weak var yyCBTextField: UITextField!
    
    let tron = TRON(baseURL: "https://www.studiant.fr/mangoApi/demos/")
    var mangopayClient = MPAPIClient()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func validerAction(_ sender: Any) {
        let user : User
        user = KeychainService.loadUser()!
        
        print("idUser : ", user.idMangoPayUtilisateur!)
        let request: APIRequest<CardReg, ErrorResponse> = tron.request("card_reg.php")
        request.method = .post
        //print("mangopayid : ", user.idMangoPayUtilisateur!)
        //request.parameters = ["idMangoPayUtilisateur":user.idMangoPayUtilisateur!]
        request.parameters = ["idMangoPayUtilisateur":user.idMangoPayUtilisateur!]
        print(request.path)
        request.perform(withSuccess: { (cardRegResponse) in
            print(cardRegResponse)
            let cardObject :[AnyHashable: Any] = ["accessKey": cardRegResponse.accessKey,
                                                  "baseURL": cardRegResponse.baseUrl,
                                                  "cardPreregistrationId": cardRegResponse.cardPreregistrationId,
                                                  "cardRegistrationURL": cardRegResponse.cardRegistrationUrl,
                                                  "cardType": cardRegResponse.cardType,
                                                  "clientId": cardRegResponse.clientId,
                                                  "preregistrationData": cardRegResponse.preregistrationData]
            self.mangopayClient = MPAPIClient.init(card: cardObject)
            
            //self.mangopayClient.appendCardInfo("4706750000000009", cardExpirationDate: "1219", cardCvx: "123")
            let cardExpiration = self.mmCBTextField.text! + self.yyCBTextField.text!
            self.mangopayClient.appendCardInfo(self.numberCBTextField.text, cardExpirationDate: cardExpiration, cardCvx: self.ccvCBTextField.text)
            self.mangopayClient.registerCard({ (response, error) in
                if let error = error{
                    print("Error : \(error)")
                }else{
                    self.dismiss(animated: true, completion: nil)
                    print("Validated \(String(describing: response))")
                }
                
            })
        }) { (error) in
            print(error)
        }
    }
}
