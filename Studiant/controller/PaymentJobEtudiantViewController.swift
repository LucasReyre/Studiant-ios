import UIKit
import TRON
import SwiftSpinner

class PaymentJobEtudiantViewController: UIViewController {
    
    let tron = TRON(baseURL: "https://www.studiant.fr/mangoApi/demos/")
    
    var jobId : String?
    var utilisateurId : String?

    @IBOutlet weak var studiantCodeTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func validezAction(_ sender: Any) {
        SwiftSpinner.show("Paiement en cours")
        let request: APIRequest<JobResponse, ErrorResponse> = tron.request("validateStudiantCode.php")
        
        request.method = .post
        request.parameters = ["postulantId": utilisateurId!,
                              "jobId": jobId!,
                              "secret": "cQEWS7UoI39I7Uk1FxC0YcuG8ge3kXEWArhu2DM1"]
        
        request.perform(withSuccess: { (jobResponse) in
        SwiftSpinner.hide()
        self.dismiss(animated: true, completion: nil)
            
        }) { (error) in
            print(error)
            SwiftSpinner.hide()
            print("Error")
        }

    }

}