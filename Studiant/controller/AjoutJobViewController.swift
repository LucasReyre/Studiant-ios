import UIKit
import GooglePlaces
import DateTimePicker
import TRON
import SwiftSpinner

class AjoutJobViewController: UIViewController,UIGestureRecognizerDelegate,
                              CategoriePickerViewDelegate {

    var categorieJob: String!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var prixTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var categorieLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var choosePlaceView: UIView!
    @IBOutlet weak var chooseDateTimeView : UIView!
    @IBOutlet weak var chooseCategorieView: UIView!
    
    var date: String!
    var heure: String!
    var adresse: String!
    var latitude: String!
    var longitude: String!
    var ville: String!
    var fromDashboard: Bool!
    var user : User!
    var geoplace: [String: Float]!
    
    let tron = TRON(baseURL: "https://loopbackstudiant.herokuapp.com/api/")
    let tronMango = TRON(baseURL: "https://www.studiant.fr/mangoApi/demos/")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUi()
        setupGesture()
        // Do any additional setup after loading the view.
    }
    
    func setupUi() {
        
        choosePlaceView.layer.cornerRadius = 8.0
        choosePlaceView.clipsToBounds = true
        
        chooseCategorieView.layer.cornerRadius = 8.0
        chooseCategorieView.clipsToBounds = true
        
        if categorieJob != nil{
            self.categorieLabel.text = "Vous avez choisi "+categorieJob
        }
        
    }
    
    
    @IBAction func insertJobAction(_ sender: Any) {
        user = KeychainService.loadUser()
        getCard()
        /*SwiftSpinner.show("Ajout du job en cours")
        
        
        
        let postRequest: APIRequest<JobResponse, ErrorResponse> = tron.request("Jobs/")
        postRequest.method = .post
        print("categorie",categorieJob)
        postRequest.parameters = ["descriptionJob": descriptionTextView.text,
                                  "prixJob": prixTextField.text!,
                                  "adresseJob": adresse,
                                  "latlongJob" : geoplace,
                                  "dateJob" : date,
                                  "heureJob": heure,
                                  "categorieJob": categorieJob,
                                  "statutJob": "0",
                                  "utilisateurId": self.user.idUtilisateur!]
        
        postRequest.perform(withSuccess: { (jobResponse) in
            SwiftSpinner.hide()
            print(jobResponse)
            if self.fromDashboard != nil{
                
                self.dismiss(animated: true, completion: nil)
            }else {
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "AddCBViewController")
                self.present(controller, animated: true, completion: nil)
                //self.performSegue(withIdentifier: "dashboardParticulierSegue", sender: self)
            }
            
        }) { (error) in
            print(error)
        }
*/
    }
    
    func getCard(){
        let postRequest: APIRequest<CardResponse, ErrorResponse> = tronMango.request("user_get_card.php")
        postRequest.method = .post
        postRequest.parameters = ["idMangoPayUtilisateur": self.user.idMangoPayUtilisateur!]
        
        postRequest.perform(withSuccess: { (cardResponse) in
            SwiftSpinner.hide()
            print("success")
            if cardResponse.id == ""{
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "AddCBViewController")
                self.present(controller, animated: true, completion: nil)
            }
            print(cardResponse)
            /*
             
                //self.performSegue(withIdentifier: "dashboardParticulierSegue", sender: self)
            */
        }) { (error) in
            print("error")
            print(error)
        }
    }
    
    func setupGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tap(_:)))
        tap.delegate = self
        chooseCategorieView.addGestureRecognizer(tap)
        
        let tapChoosePlace = UITapGestureRecognizer(target: self, action: #selector(self.tapChoosePlace(_:)))
        tapChoosePlace.delegate = self
        choosePlaceView.addGestureRecognizer(tapChoosePlace)
        
        let tapDateTime = UITapGestureRecognizer(target: self, action: #selector(self.tapDateTime(_:)))
        tapDateTime.delegate = self
        chooseDateTimeView.addGestureRecognizer(tapDateTime)

    }

    func tap(_ gestureRecognizer: UITapGestureRecognizer) {
        chooseCategorieView.alpha = 0.5
        UIView.animate(withDuration: 0.3, animations: {
            self.chooseCategorieView.alpha = 1
            let categoriePickerViewDelegate = CategoriePickerViewController()
            categoriePickerViewDelegate.delegate = self
            self.performSegue(withIdentifier: "pickerViewSegue", sender: nil)
        })
    }
    
    func tapChoosePlace(_ gestureRecognizer: UITapGestureRecognizer) {
        choosePlaceView.alpha = 0.5
        UIView.animate(withDuration: 0.3, animations: {
            self.choosePlaceView.alpha = 1
        })
        
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    
    func tapDateTime(_ gestureRecognizer: UITapGestureRecognizer) {
        chooseDateTimeView.alpha = 0.5
        UIView.animate(withDuration: 0.3, animations: {
            self.chooseDateTimeView.alpha = 1
        })
        
        let picker = DateTimePicker.show()
        picker.cancelButtonTitle = "Annuler"
        picker.todayButtonTitle = "Aujourd'hui"
        picker.doneButtonTitle = "Validez !"
        picker.selectedDate = Date()
        //picker.darkColor = UIColor(red: 102.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1)
        //picker.highlightColor = UIColor(red: 102.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1)
        picker.highlightColor = UIColor(red: 255.0/255.0, green: 138.0/255.0, blue: 138.0/255.0, alpha: 1)
        picker.isDatePickerOnly = false // to hide time and show only date picker
        picker.completionHandler = { date in
            let formatter = DateFormatter()
            formatter.dateFormat = "dd MMM yyyy"
            self.date = formatter.string(from: date)
            formatter.dateFormat = "HH:mm:ss"
            self.heure = formatter.string(from: date)
            
            formatter.dateFormat = "dd MMM yyyy HH:mm:ss"

            self.dateTimeLabel.text = "Date : " + formatter.string(from: date)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pickerViewSegue" {
            let vc = segue.destination as! CategoriePickerViewController
            vc.delegate = self
        }
    }
    
    func validateCategorie(controller: CategoriePickerViewController, categorie: String) {
        controller.dismiss(animated: true, completion: nil)
        self.categorieJob = categorie
        self.categorieLabel.text = "Vous avez choisi "+categorie
    }
    

}

extension AjoutJobViewController: UITextFieldDelegate, UITextViewDelegate{
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 130), animated: true)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            descriptionTextView.resignFirstResponder()
            scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            return false
        }
        return true
    }
    

    
}


extension AjoutJobViewController: GMSAutocompleteViewControllerDelegate{
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress)")
        print("Place attributions: \(place.attributions)")
        geoplace=["lat" : Float(place.coordinate.latitude), "lng" : Float(place.coordinate.longitude)]
    
        
        adresse = place.formattedAddress
        self.placeLabel.text = "Lieu : " + place.formattedAddress!
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }

}
