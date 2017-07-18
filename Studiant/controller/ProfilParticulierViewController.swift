
import UIKit
import FBSDKLoginKit
import FacebookCore
import TRON

class ProfilParticulierViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var nomTextField: UITextField!
    @IBOutlet weak var prenomTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    var id: String?
    var categorieJob: String!
    
    let tron = TRON(baseURL: "https://loopbackstudiant.herokuapp.com/api/")
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("catégorie choisie", categorieJob)
        initForm()
        
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
            nomTextField.resignFirstResponder()
        }
        return true
        
    }

    @IBAction func validerAction(_ sender: Any) {
        let user = User.init(nomUtilisateur: nomTextField.text!, prenomUtilisateur: prenomTextField.text!, mailUtilisateur: emailTextField.text!)
        user.idExterneUtilisateur = id
        user.photoUtilisateur = "https://graph.facebook.com/" + self.id! + "/picture?height=200&width=200"
        user.typeUtilisateur = 0
        user.typeConnexionUtilisateur = 0
        
        let postRequest: APIRequest<UserResponse, ErrorResponse> = tron.request("Utilisateurs/")
        postRequest.method = .post
        postRequest.parameters = ["nomUtilisateur": user.nomUtilisateur,
                                  "prenomUtilisateur": user.prenomUtilisateur,
                                  "photoUtilisateur": user.photoUtilisateur,
                                  "mailUtilisateur" : user.mailUtilisateur,
                                  "typeUtilisateur": user.typeUtilisateur,
                                  "idExterneUtilisateur": user.idExterneUtilisateur,
                                  "typeConnexionUtilisateur": user.typeConnexionUtilisateur,
                                  "descriptionUtilisateur": user.descriptionUtilisateur,
                                  "diplomeUtilisateur": user.diplomeUtilisateur,
                                  "permisUtilisateur": user.permisUtilisateur]
        postRequest.perform(withSuccess: { (usersResponse) in
            print(usersResponse)
            self.performSegue(withIdentifier: "dashboardEtudiantSegue", sender: self)
        }) { (error) in
            print(error)
        }

    }
}
