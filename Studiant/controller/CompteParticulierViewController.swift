
import UIKit

class CompteParticulierViewController: UIViewController {

    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var nomPrenomLabel: UILabel!
    
    var user : User!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        user = KeychainService.loadUser()
        
        let nomprenom = user.prenomUtilisateur! + " " + user.nomUtilisateur!
        nomPrenomLabel.text = nomprenom
        emailLabel.text = user.mailUtilisateur
    }

}