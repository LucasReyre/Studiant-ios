import UIKit

class CategorieViewController: UIViewController, UIGestureRecognizerDelegate, CategoriePickerViewDelegate {

    @IBOutlet weak var chooseCategorieView: UIView!
    
    @IBOutlet weak var label: UILabel!
    
    var categorie: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tap(_:)))
        tap.delegate = self
        chooseCategorieView.addGestureRecognizer(tap)
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

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pickerViewSegue" {
            let vc = segue.destination as! CategoriePickerViewController
            vc.delegate = self
            //vc.categorie = ["blal","bla"]
        }else if segue.identifier == "inscriptionSegue"{
            let vc = segue.destination as! ConnexionViewController
            vc.statusUser = 0
            vc.categorieJob = categorie
        }
    }

    func validateCategorie(controller: CategoriePickerViewController, categorie: String) {
        controller.dismiss(animated: true, completion: nil)
        self.categorie = categorie
        let labelConcat = "Vous avez choisi "+categorie
        self.label.text = labelConcat
    }
}
