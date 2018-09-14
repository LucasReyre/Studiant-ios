import UIKit
import CryptoSwift
import TRON
import SwiftSpinner
import FirebaseMessaging

class ConnexionViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var mailTextField: UITextField!
    let tron = TRON(baseURL: "https://loopbackstudiant.herokuapp.com/api/")
    let tron2 = TRON(baseURL: "https://studiant.fr/studiantApi/")
    var myUser : User!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print(textField.tag)
        if textField.tag == 0{
            passwordTextField.becomeFirstResponder()
        } else if textField.tag == 1 {
            textField.resignFirstResponder()
        }
        return true
        
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }

    @IBAction func forgotPasswordAction(_ sender: Any) {

        SwiftSpinner.show("Récupération en cours")

        if !isValidEmail(testStr: mailTextField.text!) {
            SwiftSpinner.show("Adresse mail invalide", animated: false).addTapHandler({
                SwiftSpinner.hide()
            })
            return
        }
        
        let forgotPasswordRequest: APIRequest<UserResponse, ErrorResponse> = tron2.request("forgotPassword.php")
        forgotPasswordRequest.method = .post
        forgotPasswordRequest.parameters = ["mailUtilisateur": mailTextField.text!.lowercased()]
        
        print("mail : ", mailTextField.text!.lowercased())
        forgotPasswordRequest.perform(withSuccess: { (usersResponse) in
            print(usersResponse)
            SwiftSpinner.show("Votre mot de passe vous a été envoyé par mail", animated: false).addTapHandler({
                SwiftSpinner.hide()
            })
            
        }) { (error) in
            SwiftSpinner.show("Une erreure est survenue", animated: false).addTapHandler({
                SwiftSpinner.hide()
            })
            print(error)
        }
        
        
        
    }
    
    
    @IBAction func abandonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func connexionAction(_ sender: Any) {
        
        mailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
        if !isValidEmail(testStr: mailTextField.text!) {
            SwiftSpinner.show("Adresse mail invalide", animated: false).addTapHandler({
                SwiftSpinner.hide()
            })
            return
        }
        
        let request: APIRequest<UserResponse, ErrorResponse> = tron.request("Utilisateurs/findOne")
        request.parameters = ["filter[where][passwordUtilisateur]":passwordTextField.text!.sha512(),
                              "filter[where][mailUtilisateur]": mailTextField.text!]
        
        SwiftSpinner.show("Connexion en cours")

        print(request)
        request.perform(withSuccess: { (usersResponse) in
            SwiftSpinner.hide()
            print(usersResponse)
            
            let postRequest: APIRequest<UserResponse, ErrorResponse> = self.tron.request("Utilisateurs/")
            postRequest.method = .patch
            
            postRequest.parameters = ["firebaseToken": Messaging.messaging().fcmToken!,
                                      "id": usersResponse.idUtilisateur]
            
            postRequest.perform(withSuccess: { (userResponse) in
            }) { (error) in
                print("Error")
                print(error)
            }
            
            self.myUser = User.init(idUtilisateur: usersResponse.idUtilisateur, typeUtilisateur: usersResponse.typeUtilisateur)
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
