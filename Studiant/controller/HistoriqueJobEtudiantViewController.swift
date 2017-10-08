import UIKit
import FoldingCell
import TRON
import SwiftSpinner
import PopupDialog

class HistoriqueJobEtudiantViewController: UITableViewController, CellHistoriqeJobEtudiantDelegate {
    
    let kCloseCellHeight: CGFloat = 179
    let kOpenCellHeight: CGFloat = 488
    var cellHeights: [CGFloat] = []
    let tron = TRON(baseURL: "https://loopbackstudiant.herokuapp.com/api/")
    var isDataLoad = false
    var jobs: [JobResponse] = []
    var user : User!
    var selectedJob : JobResponse!
    
    var filter: [String: Any]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        user = KeychainService.loadUser()
        getData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if(self.isDataLoad == false){
            SwiftSpinner.show("Récupération des jobs en cours")
        }
    }
    
    func getData() {
        
        let request: APIRequest<JobsResponse, ErrorResponse> = tron.request("Jobs")
        request.parameters = ["filter[where][postulantId]":user.idUtilisateur!,
                               "filter[include][appartenir]":"" ]
        
        if self.filter != nil{
            SwiftSpinner.show("Récupération de votre historique")
            request.parameters = self.filter!
        }
        
        request.perform(withSuccess: { (jobsResponse) in
            self.isDataLoad = true
            SwiftSpinner.hide()
            
            self.jobs = jobsResponse.jobs
            print(jobsResponse.jobs)
            self.setup()
            self.tableView.reloadData()
            self.tableView.contentOffset.y = 15
            
        }) { (error) in
            print(error)
        }
    }
    
    private func setup() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        // this is the replacement of implementing: "collectionView.addSubview(refreshControl)"
        tableView.refreshControl = refreshControl
        refreshControl.attributedTitle = NSAttributedString(string: "Récupération des jobs")
        
        self.tableView.contentInset = UIEdgeInsets(top: 30,left: 0,bottom: 50,right: 0)
        cellHeights = Array(repeating: kCloseCellHeight, count: jobs.count)
        tableView.estimatedRowHeight = kCloseCellHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        //tableView.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "background-1"))
    }
    
    func refresh(refreshControl: UIRefreshControl) {
        getData()
        refreshControl.endRefreshing()
    }
    
    func onAskPaiementTouch(job : JobResponse) {
        print("typePaiement : ", job.typePaiementJob)
        selectedJob = job
        print("test : ", job.idJob)
        print("status : ", job.statusJob)
        switch job.typePaiementJob {
        case "CESU":
            presentPopup(message: "Le paiement de ce job s'effectue en Chèque CESU", title: "Attention")
        case "CB":
            if job.statusJob == "1" {
                self.performSegue(withIdentifier: "paiementJobEtudiantSegue", sender: nil)
            }else {
                presentPopup(message: "L'argent de ce Job à déja été transféré", title: "Erreur")
            }
            print("CB")
        case "ESPECE":
            presentPopup(message: "Le paiement de ce job s'effectue en espèce", title: "Attention")
        default:
            presentPopup(message: "Le paiement de ce job s'effectue en espèce", title: "Attention")
        }
        
    }
    
    func presentPopup(message: String, title: String){
        
        // Create the dialog
        let popup = PopupDialog(title: title, message: message)
        // Create buttons
        
        let buttonOne = DefaultButton(title: "VALIDEZ") {
            
        }
        
        popup.addButtons([buttonOne])
        
        // Present dialog
        self.present(popup, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "paiementJobEtudiantSegue"{
            let vc = segue.destination as! PaymentJobEtudiantViewController
            vc.jobId = selectedJob.idJob
            vc.utilisateurId = selectedJob.idPostulant
        }
    }
    
}

// MARK: - TableView
extension HistoriqueJobEtudiantViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jobs.count
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard case let cell as CellHistoriqeJobEtudiant = cell else {
            return
        }
        
        
        cell.setupUi(jobResponse: jobs[indexPath.row], delegate: self)
        cell.backgroundColor = .clear
        
        if cellHeights[indexPath.row] == kCloseCellHeight {
            cell.selectedAnimation(false, animated: false, completion:nil)
        } else {
            cell.selectedAnimation(true, animated: false, completion: nil)
        }
        
        
        cell.number = indexPath.row
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoldingCell", for: indexPath) as! FoldingCell
        
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.init(red:222/255.0, green:225/255.0, blue:227/255.0, alpha: 1.0).cgColor
        
        let durations: [TimeInterval] = [0.26, 0.2, 0.2]
        //cell.durationsForExpandedState = durations
        //cell.durationsForCollapsedState = durations
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath.row]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! FoldingCell
        
        if cell.isAnimating() {
            return
        }
        
        var duration = 0.0
        let cellIsCollapsed = cellHeights[indexPath.row] == kCloseCellHeight
        if cellIsCollapsed {
            cellHeights[indexPath.row] = kOpenCellHeight
            cell.selectedAnimation(true, animated: true, completion: nil)
            duration = 0.5
        } else {
            cellHeights[indexPath.row] = kCloseCellHeight
            cell.selectedAnimation(false, animated: true, completion: nil)
            duration = 0.8
        }
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: { () -> Void in
            tableView.beginUpdates()
            tableView.endUpdates()
        }, completion: nil)
        
    }
    
}
