import UIKit
import CryptoSwift
import TRON
import SwiftSpinner

class ConnexionViewController: UIViewController {

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var mailTextField: UITextField!
    let tron = TRON(baseURL: "https://loopbackstudiant.herokuapp.com/api/")
    var myUser : User!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func connexionAction(_ sender: Any) {
        let request: APIRequest<UserResponse, ErrorResponse> = tron.request("Utilisateurs/findOne")
        request.parameters = ["filter[where][passwordUtilisateur]":passwordTextField.text!.sha512(),
                              "filter[where][mailUtilisateur]": mailTextField.text!]
        
        SwiftSpinner.show("Connexion en cours")

        print(request)
        request.perform(withSuccess: { (usersResponse) in
            SwiftSpinner.hide()
            print(usersResponse)
            
            
            self.myUser = User.init(idUtilisateur: usersResponse.idUtilisateur, typeUtilisateur: 1)
            self.myUser.idMangoPayUtilisateur = usersResponse.idMangoPayUtilisateur
            self.myUser.photoUtilisateur = usersResponse.photoUtilisateur
            self.myUser.nomUtilisateur = usersResponse.nomUtilisateur
            self.myUser.prenomUtilisateur = usersResponse.prenomUtilisateur
            self.myUser.diplomeUtilisateur = usersResponse.diplomeUtilisateur
            self.myUser.telephoneUtilisateur = usersResponse.telephoneUtilisateur
            self.myUser.mailUtilisateur = usersResponse.mailUtilisateur
            self.myUser.descriptionUtilisateur = usersResponse.descriptionUtilisateur
            self.myUser.idWalletUtilisateur = usersResponse.idWalletMangoPayUtilisateur
            
            KeychainService.saveUser(user: self.myUser)
            
            if(usersResponse.typeUtilisateur == 1){
                self.performSegue(withIdentifier: "dashboardEtudiantSegue", sender: self)
            }else if (usersResponse.typeUtilisateur == 0){
                self.performSegue(withIdentifier: "dashboardParticulierSegue", sender: self)
            }
            
        }) { (error) in
            SwiftSpinner.show("Login/Mdp invalides", animated: false).addTapHandler({
                SwiftSpinner.hide()
            })
            print(error)
        }
    }
}
