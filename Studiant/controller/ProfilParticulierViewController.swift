
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
    @IBOutlet weak var passwordTextField: UITextField!
    
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
        self.addDoneButtonOnKeyboard()
        
        if fromFacebook == true
        {
            initForm()
        }
        
    }
    
    func addDoneButtonOnKeyboard()
    {
        var doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x:0, y:0,width:320,height:50))
        doneToolbar.barStyle = UIBarStyle.default
        
        var flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        var done: UIBarButtonItem = UIBarButtonItem(title: "Validez", style: UIBarButtonItemStyle.done, target: self, action: Selector("doneButtonAction"))
        
        var items = NSMutableArray()
        items.add(flexSpace)
        items.add(done)
        
        doneToolbar.items = items as! [UIBarButtonItem]
        doneToolbar.sizeToFit()
        
        self.telephoneTextField.inputAccessoryView = doneToolbar
        
    }
    
    func doneButtonAction()
    {
        self.telephoneTextField.resignFirstResponder()
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
            emailTextField.becomeFirstResponder()
        } else if textField.tag == 2 {
            passwordTextField.becomeFirstResponder()
            scrollView.setContentOffset(CGPoint(x: 0, y: 250), animated: true)
        } else if textField.tag == 3 {
            telephoneTextField.becomeFirstResponder()
            scrollView.setContentOffset(CGPoint(x: 0, y: 290), animated:true)
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 3 {
            scrollView.setContentOffset(CGPoint(x: 0, y: 250), animated: true)
        }
    }

    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    @IBAction func validerAction(_ sender: Any) {
        SwiftSpinner.show("Inscription en cours")
        self.telephoneTextField.resignFirstResponder()
        let user = User.init(nomUtilisateur: nomTextField.text!, prenomUtilisateur: prenomTextField.text!, mailUtilisateur: emailTextField.text!.lowercased())
        user.telephoneUtilisateur = telephoneTextField.text!
        user.passwordUtilisateur = passwordTextField.text!.sha512()
        
        user.typeUtilisateur = 0
        let token = Messaging.messaging().fcmToken
        
        if (user.telephoneUtilisateur == nil || user.prenomUtilisateur == nil ||
            user.mailUtilisateur == nil || user.nomUtilisateur == nil || !cguSwitch.isOn || user.telephoneUtilisateur?.count != 10 || self.isValidEmail(testStr: user.mailUtilisateur!) == false ){
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
                                      "passwordUtilisateur": user.passwordUtilisateur!,
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
                                      "passwordUtilisateur": user.passwordUtilisateur!,
                                      "typeConnexionUtilisateur": user.typeConnexionUtilisateur,
                                      "descriptionUtilisateur": user.descriptionUtilisateur,
                                      "diplomeUtilisateur": user.diplomeUtilisateur,
                                      "permisUtilisateur": user.permisUtilisateur,
                                      "firebaseToken": token!]
        }
        
        
        
        postRequest.perform(withSuccess: { (usersResponse) in
            print(usersResponse)
            if(usersResponse.idUtilisateur == ""){
                SwiftSpinner.show("Une erreure est survenue", animated: false).addTapHandler({
                    SwiftSpinner.hide()
                })
            }else{
                self.myUser = User.init(idUtilisateur: usersResponse.idUtilisateur, typeUtilisateur: 0)
                self.myUser.nomUtilisateur = usersResponse.nomUtilisateur
                self.myUser.prenomUtilisateur = usersResponse.prenomUtilisateur
                self.myUser.mailUtilisateur = usersResponse.mailUtilisateur
                self.myUser.idMangoPayUtilisateur = usersResponse.idMangoPayUtilisateur
                self.myUser.telephoneUtilisateur = usersResponse.telephoneUtilisateur
                self.myUser.idWalletUtilisateur = usersResponse.idWalletMangoPayUtilisateur
                
                KeychainService.saveUser(user: self.myUser)
                SwiftSpinner.hide()
                self.performSegue(withIdentifier: "AjoutJobSegue", sender: self)
            }
  
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
