import UIKit
import TRON
import SwiftSpinner


class DashboardParticulierViewController: UIViewController, CellJobParticulierDelegate {

    var tableContainer: ParticulierTableViewContainer!
    var postulantTableContainer: PostulantsTableViewContainer!
    let tron = TRON(baseURL: "https://loopbackstudiant.herokuapp.com/api/")
    var isDataLoad = false
    var jobs: [JobResponse] = []
    var postulants: UsersResponse?
    var myUser : User!
    var user : User!
    
    @IBOutlet weak var floatingButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
/*        user = User.init(idUtilisateur: "okokok")
        KeychainService.saveUser(user: user)*/
        floatingButton.layer.cornerRadius = 0.5 * floatingButton.bounds.size.width
        floatingButton.clipsToBounds = true
        
        myUser = KeychainService.loadUser()
        print("mon id : ",myUser.idUtilisateur!)
        
        getData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (isDataLoad == false) {
            SwiftSpinner.show("Récupération des jobs en cours")
        }
        
    }
    
    func getData() {
        
        //let request: APIRequest<JobsResponse, ErrorResponse> = tron.request("Utilisateurs/"+myUser.idUtilisateur!+"/creer")
        let stringRequest = "Utilisateurs/"+myUser.idUtilisateur!+"/creer"
        let request: APIRequest<JobsResponse, ErrorResponse> = tron.request(stringRequest)
        request.parameters = ["filter[include][utilisateurs]":""]
        print(request.path)
        request.perform(withSuccess: { (jobsResponse) in
            self.isDataLoad = true
            SwiftSpinner.hide()
            self.jobs = jobsResponse.jobs
            print(jobsResponse.jobs)
            self.tableContainer.displayData(jobs: jobsResponse.jobs)
        }) { (error) in
            print(error)
            SwiftSpinner.show("Erreur", animated:false).addTapHandler({
                SwiftSpinner.hide()
                
            })
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ParticulierTableViewContainer,
            segue.identifier == "particulierTableViewContainer" {
            self.tableContainer = vc
            self.tableContainer.delegate = self
        }else if let vc = segue.destination as? PostulantsTableViewContainer,
        segue.identifier == "listePostulantsSegue" {
            self.postulantTableContainer = vc
            //self.tableContainer.delegate = self
            self.postulantTableContainer.postulants = self.postulants
        }else if let vc = segue.destination as? AjoutJobViewController,
            segue.identifier == "addJobFromDashboardSegue"{
            vc.fromDashboard = true
        }
    }
    
    @IBAction func floatingButtonAction(_ sender: Any) {
    }
    func onButtonVoirPostulantTouch(postulants: UsersResponse) {
        self.postulants = postulants
        self.performSegue(withIdentifier: "listePostulantsSegue", sender: nil)
    }
    
}