
import UIKit
import TRON
import Haneke
import SwiftSpinner

class CompteEtudiantViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var diplomeTextField: UITextField!
    
    @IBOutlet weak var nomPrenomLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    var user: User!
    
    @IBOutlet weak var scrollview: UIScrollView!
    let tron = TRON(baseURL: "https://loopbackstudiant.herokuapp.com/api/")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
        profileImageView.clipsToBounds = true
        
        user = KeychainService.loadUser()
        
        print(user.photoUtilisateur!)
        let url = URL(string: user.photoUtilisateur!)
        
        
        let nomprenom = user.prenomUtilisateur! + " " + user.nomUtilisateur!
        nomPrenomLabel.text = nomprenom
        diplomeTextField.text = user.diplomeUtilisateur
        emailLabel.text = user.mailUtilisateur
        descriptionTextView.text = user.descriptionUtilisateur
        self.profileImageView.hnk_setImageFromURL(url!)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        scrollview.setContentOffset(CGPoint(x: 0, y: 300), animated: true)
    }

    @IBAction func saveUserAction(_ sender: Any) {
        SwiftSpinner.show("Modification en cours")

        let postRequest: APIRequest<UserResponse, ErrorResponse> = tron.request("Utilisateurs/")
        postRequest.method = .patch
        
        postRequest.parameters = ["descriptionUtilisateur": descriptionTextView.text,
                                  "diplomeUtilisateur": diplomeTextField.text!,
                                  "id": user.idUtilisateur!]
        
        postRequest.perform(withSuccess: { (userResponse) in
            self.user.descriptionUtilisateur = userResponse.descriptionUtilisateur
            self.user.diplomeUtilisateur = userResponse.diplomeUtilisateur
            
            KeychainService.saveUser(user: self.user)
            SwiftSpinner.show("Modification enregistrée", animated: false).addTapHandler({
                SwiftSpinner.hide()
            })
            
        }) { (error) in
            print(error)
            SwiftSpinner.show("Une erreure est survenue", animated: false).addTapHandler({
                SwiftSpinner.hide()
            })
            print("Error")
        }
    }
}
