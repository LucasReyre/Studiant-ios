
import UIKit
import FBSDKLoginKit
import FacebookCore
import TRON
import SwiftSpinner
import FirebaseMessaging

class ProfilParticulierViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var cguSwitch: UISwitch!
    @IBOutlet weak var telephoneTextField: UITextField!
    @IBOutlet weak var nomTextField: UITextField!
    @IBOutlet weak var prenomTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    var id: String?
    var categorieJob: String!
    var myUser : User!
    
    var fromFacebook: Bool?
    
    //let tron = TRON(baseURL: "https://loopbackstudiant.herokuapp.com/api/")
    let tron = TRON(baseURL: "https://www.studiant.fr/mangoApi/demos/users_create.php")
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("catégorie choisie", categorieJob)
        if fromFacebook == true
        {
            initForm()
        }
        
    }
    
    func initForm() {
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"]).start {
            (connexion, result, err) in
            if err != nil{
                print("Failed to start graph request: ",err)
                return
            }
            
            
            let myResult = result as AnyObject
            let name = myResult.value(forKey: "name") as! String
            let nameArray = name.components(separatedBy: " ")
            
            self.id = myResult.value(forKey: "id") as! String
            let url = URL(string: "https://graph.facebook.com/" + self.id! + "/picture?height=200&width=200")
            
            self.emailTextField.text = myResult.value(forKey: "email") as! String
            self.prenomTextField.text = nameArray[0]
            self.nomTextField.text = nameArray[1]
            
            
            //print(myResult.value(forKey: "email"))
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print(textField.tag)
        if textField.tag == 0{
            prenomTextField.becomeFirstResponder()
        } else if textField.tag == 1 {
            nomTextField.becomeFirstResponder()
        } else if textField.tag == 2 {
            telephoneTextField.becomeFirstResponder()
            scrollView.setContentOffset(CGPoint(x: 0, y: 250), animated: true)
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 3 {
            scrollView.setContentOffset(CGPoint(x: 0, y: 250), animated: true)
        }
    }

    @IBAction func validerAction(_ sender: Any) {
        SwiftSpinner.show("Inscription en cours")
        let user = User.init(nomUtilisateur: nomTextField.text!, prenomUtilisateur: prenomTextField.text!, mailUtilisateur: emailTextField.text!)
        user.telephoneUtilisateur = telephoneTextField.text!
        user.typeUtilisateur = 0
        print("telphone : ", user.telephoneUtilisateur)
        let token = Messaging.messaging().fcmToken
        print("FCM token: \(token ?? "")")
        
        if (user.telephoneUtilisateur == nil || user.prenomUtilisateur == nil ||
            user.mailUtilisateur == nil || user.nomUtilisateur == nil || !cguSwitch.isOn || user.telephoneUtilisateur?.count != 10){
            SwiftSpinner.show("Erreur vérifiez le formulaire", animated: false).addTapHandler({
                SwiftSpinner.hide()
                
            })
            return
        }
        
        let postRequest: APIRequest<UserResponse, ErrorResponse> = tron.request("")
        postRequest.method = .post
        
        if fromFacebook == true{
            user.idExterneUtilisateur = self.id!
            user.photoUtilisateur = "https://graph.facebook.com/" + self.id! + "/picture?height=200&width=200"
            user.typeConnexionUtilisateur = 0
            
            postRequest.parameters = ["nomUtilisateur": user.nomUtilisateur!,
                                      "prenomUtilisateur": user.prenomUtilisateur!,
                                      "photoUtilisateur": user.photoUtilisateur!,
                                      "mailUtilisateur" : user.mailUtilisateur!,
                                      "telephoneUtilisateur": user.telephoneUtilisateur!,
                                      "typeUtilisateur": user.typeUtilisateur,
                                      "idExterneUtilisateur": user.idExterneUtilisateur!,
                                      "typeConnexionUtilisateur": user.typeConnexionUtilisateur,
                                      "descriptionUtilisateur": user.descriptionUtilisateur,
                                      "diplomeUtilisateur": user.diplomeUtilisateur,
                                      "permisUtilisateur": user.permisUtilisateur,
                                      "firebaseToken": token!]
            
        }else if fromFacebook == false{
            user.typeConnexionUtilisateur = 1
            print("from facebook false")
            print("nom : ", user.nomUtilisateur!)
            print("prenom : ", user.prenomUtilisateur!)
            
            postRequest.parameters = ["nomUtilisateur": user.nomUtilisateur!,
                                      "prenomUtilisateur": user.prenomUtilisateur!,
                                      "mailUtilisateur" : user.mailUtilisateur!,
                                      "telephoneUtilisateur": user.telephoneUtilisateur!,
                                      "typeUtilisateur": user.typeUtilisateur,
                                      "typeConnexionUtilisateur": user.typeConnexionUtilisateur,
                                      "descriptionUtilisateur": user.descriptionUtilisateur,
                                      "diplomeUtilisateur": user.diplomeUtilisateur,
                                      "permisUtilisateur": user.permisUtilisateur,
                                      "firebaseToken": token!]
        }
        
        
        
        postRequest.perform(withSuccess: { (usersResponse) in
            print(usersResponse)
            self.myUser = User.init(idUtilisateur: usersResponse.idUtilisateur, typeUtilisateur: 0)
            self.myUser.idMangoPayUtilisateur = usersResponse.idMangoPayUtilisateur
            self.myUser.telephoneUtilisateur = usersResponse.telephoneUtilisateur
            KeychainService.saveUser(user: self.myUser)
            SwiftSpinner.hide()
            self.performSegue(withIdentifier: "AjoutJobSegue", sender: self)
        }) { (error) in
            SwiftSpinner.show("Une erreure s'est produite", animated: false).addTapHandler({
                SwiftSpinner.hide()
            })
            print(error)
        }
    }
    
    
    @IBAction func cguAction(_ sender: Any) {
        guard let url = URL(string: "http://www.studiant.fr/?page_id=961") else {
            return //be safe
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    @IBAction func abandonnerAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AjoutJobSegue" {
            let vc = segue.destination as! AjoutJobViewController
            print("categorie ",self.categorieJob)
            vc.categorieJob = self.categorieJob
    
            let backItem = UIBarButtonItem()
            backItem.title = "Création du job"
            navigationItem.backBarButtonItem = backItem
        }
    }
}
