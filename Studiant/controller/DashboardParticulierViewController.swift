import UIKit
import TRON
import SwiftSpinner


class DashboardParticulierViewController: UIViewController, CellJobParticulierDelegate {

    var tableContainer: ParticulierTableViewContainer!
    var postulantTableContainer: PostulantsContainerViewController!
    let tron = TRON(baseURL: "https://loopbackstudiant.herokuapp.com/api/")
    var isDataLoad = false
    var jobs: [JobResponse] = []
    var postulants: UsersResponse?
    var selectedJob: JobResponse?
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
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getData()
        if (isDataLoad == false) {
            SwiftSpinner.show("Récupération de vos jobs en cours")
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
        }else if let vc = segue.destination as? PostulantsContainerViewController,
        segue.identifier == "listePostulantsSegue" {
            self.postulantTableContainer = vc
            //self.tableContainer.delegate = self
            print("prepare segue listPostulantSegue : ",self.selectedJob?.idJob)
            self.postulantTableContainer.postulants = self.postulants
            self.postulantTableContainer.job = self.selectedJob
        }else if let vc = segue.destination as? AjoutJobViewController,
            segue.identifier == "addJobFromDashboardSegue"{
            vc.fromDashboard = true
        }
    }
    
    @IBAction func floatingButtonAction(_ sender: Any) {
    }
    
    func onButtonVoirPostulantTouch(postulants: UsersResponse, job: JobResponse) {
        self.postulants = postulants
        self.selectedJob = job
        self.performSegue(withIdentifier: "listePostulantsSegue", sender: nil)
    }
    
}
