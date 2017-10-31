
import UIKit
import SwiftSpinner
import TRON

class CompteParticulierViewController: UIViewController,UITextFieldDelegate {

    
    @IBOutlet weak var nomPrenomLabel: UILabel!
    
    @IBOutlet weak var telephoneTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
     
    @IBOutlet weak var scrollView: UIScrollView!
    var user : User!
    let tron = TRON(baseURL: "https://loopbackstudiant.herokuapp.com/api/")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addDoneButtonOnKeyboard()
        
        user = KeychainService.loadUser()
        
        let nomprenom = user.prenomUtilisateur! + " " + user.nomUtilisateur!
        nomPrenomLabel.text = nomprenom
        emailTextField.text = user.mailUtilisateur
        telephoneTextField.text = user.telephoneUtilisateur!
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
        self.telephoneTextField.inputAccessoryView = doneToolbar
        
    }
    
    func doneButtonAction()
    {
        self.telephoneTextField.resignFirstResponder()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 1{
            scrollView.setContentOffset(CGPoint(x: 0, y: 150), animated: true)
        }/* else if textField.tag == 1 {
            scrollView.setContentOffset(CGPoint(x: 0, y: 180), animated: true)
        }*/
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print(textField.tag)
        if textField.tag == 0{
            textField.resignFirstResponder()
        }
        return true
        
    }
    
    @IBAction func saveUserAction(_ sender: Any) {
        SwiftSpinner.show("Modification en cours")
        
        let postRequest: APIRequest<UserResponse, ErrorResponse> = tron.request("Utilisateurs/")
        postRequest.method = .patch
        
        postRequest.parameters = ["mailUtilisateur": self.emailTextField.text!,
                                  "telephoneUtilisateur": self.telephoneTextField.text!,
                                  "id": user.idUtilisateur!]
        
        postRequest.perform(withSuccess: { (userResponse) in
            print(userResponse)
            self.user.mailUtilisateur = userResponse.mailUtilisateur
            self.user.telephoneUtilisateur = userResponse.telephoneUtilisateur
            
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
