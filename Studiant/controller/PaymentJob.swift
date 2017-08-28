import Foundation
import UIKit
import TRON
import SwiftSpinner

class PaymentJob: UIViewController{
    
    var price: String!
    var delegate: PaymentDelegate? = nil
    
    @IBOutlet weak var priceLabel: UILabel!
    let tron = TRON(baseURL: "https://www.studiant.fr/mangoApi/demos/")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        priceLabel.text = price + " €"
    }
    
    @IBAction func validerAction(_ sender: Any) {
        
        let user : User
        user = KeychainService.loadUser()!
        
        print("idUser : ", user.idMangoPayUtilisateur!)
        print("price : ", price!)
        SwiftSpinner.show("Paiement en cours")
        
        let request: APIRequest<PayinResponse, ErrorResponse> = tron.request("user_direct_pay_in.php")
        request.method = .post
        request.parameters = ["idMangoPayUtilisateur":user.idMangoPayUtilisateur!,"amount":price!]
        
        print(request.path)
        request.perform(withSuccess: { (payinResponse) in
            print("response : ",payinResponse)
            print("response status : ", payinResponse.status)
            SwiftSpinner.hide()
            if (payinResponse.status == "SUCCEEDED"){
                self.delegate?.onJobIsPaying(controller: self)
            }else{
                self.delegate?.onPayingError(controller: self)
            }
            
            //self.delegate?.onJobIsPaying(controller: self)

            
        }) { (error) in
            print(error)
        }
        
        

    }
}


protocol PaymentDelegate {
    func onJobIsPaying(controller: PaymentJob)
    func onPayingError(controller: PaymentJob)
}
