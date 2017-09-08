
import UIKit
import Haneke

class CompteEtudiantViewController: UIViewController {

    @IBOutlet weak var diplomeLabel: UILabel!
    @IBOutlet weak var nomPrenomLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    var user: User!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
        profileImageView.clipsToBounds = true
        
        user = KeychainService.loadUser()
        
        print(user.photoUtilisateur!)
        let url = URL(string: user.photoUtilisateur!)
        
        let nomprenom = user.prenomUtilisateur! + " " + user.nomUtilisateur!
        nomPrenomLabel.text = nomprenom
        diplomeLabel.text = user.diplomeUtilisateur
        emailLabel.text = user.mailUtilisateur
        
        
        self.profileImageView.hnk_setImageFromURL(url!)
    }



}
