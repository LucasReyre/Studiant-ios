import UIKit
import TRON
import SwiftSpinner

class IbanViewController: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var cpTextField: UITextField!
    @IBOutlet weak var adresseTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var bicTextField: UITextField!
    @IBOutlet weak var ibanTextField: UITextField!
    var user:User!
    
    @IBOutlet weak var scrollview: UIScrollView!
    let tron = TRON(baseURL: "https://www.studiant.fr/mangoApi/demos/")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        scrollview.contentOffset.x = 0
        // Do any additional setup after loading the view.
    }

    @IBAction func validerIbanAction(_ sender: Any) {
        SwiftSpinner.show("Ajout du RIB")
        
        let postRequest: APIRequest<UserResponse, ErrorResponse> = tron.request("user_create_iban.php/")
        postRequest.method = .post
        user = KeychainService.loadUser()
        
        postRequest.parameters = ["idMangoPayUtilisateur": user.idMangoPayUtilisateur!,
                                  "IBAN": ibanTextField.text!,
                                  "BIC": bicTextField.text!,
                                  "nameUtilisateur" : nameTextField.text!,
                                  "AddressLine1": adresseTextField.text!,
                                  "city": cityTextField.text!,
                                  "codePostal": cpTextField.text!]
        
        postRequest.perform(withSuccess: { (usersResponse) in
            SwiftSpinner.hide()
            print(usersResponse)
        }) { (error) in
            print(error)
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField.tag {
        case 0...1:
            scrollview.setContentOffset(CGPoint(x: 0, y: 100), animated: true)
            break
        case 2...5:
            scrollview.setContentOffset(CGPoint(x: 0, y: 200), animated: true)
            break
        default:
            print("default")
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print(textField.tag)
        if textField.tag == 0{
            bicTextField.becomeFirstResponder()
        } else if textField.tag == 1 {
            nameTextField.becomeFirstResponder()
        } else if textField.tag == 2 {
            adresseTextField.becomeFirstResponder()
        }else if textField.tag == 3{
            cpTextField.becomeFirstResponder()
        }else if textField.tag == 4{
            cityTextField.becomeFirstResponder()
        }else if textField.tag == 5{
            cityTextField.resignFirstResponder()
            scrollview.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
        return true
        
    }

    @IBAction func returnAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
