//
//  MangoTestViewController.swift
//  Studiant
//
//  Created by Lucas REYRE on 02/08/2017.
//  Copyright © 2017 Studiant. All rights reserved.
//

import UIKit
import TRON
import mangopay

class MangoTestViewController: UIViewController {

    let tron = TRON(baseURL: "https://www.studiant.fr/mangoApi/demos/")
    var mangopayClient = MPAPIClient()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //let request: APIRequest<JobsResponse, ErrorResponse> = tron.request("Utilisateurs/"+myUser.idUtilisateur!+"/creer")
        //let stringRequest = "card_reg.php"
        let request: APIRequest<CardReg, ErrorResponse> = tron.request("card_reg.php")
        //request.parameters = ["filter[include][utilisateurs]":""]
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
            
            self.mangopayClient.appendCardInfo("4706750000000009", cardExpirationDate: "1219", cardCvx: "123")
            self.mangopayClient.registerCard({ (response, error) in
                if let error = error{
                    print("Error : \(error)")
                }else{
                    print("Validated \(String(describing: response))")
                }

            })
        }) { (error) in
            print(error)
        }
        
        // Do any additional setup after loading the view.
    }
}
