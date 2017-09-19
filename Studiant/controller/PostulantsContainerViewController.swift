import UIKit
import FoldingCell
import TRON
import SwiftSpinner


class PostulantsContainerViewController: UIViewController {
    
    var delegate : CellJobParticulierDelegate?
    var tableContainer: PostulantsTableViewController!
    
    var postulants: UsersResponse?
    var job : JobResponse?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? PostulantsTableViewController,
            segue.identifier == "postulantsEmbedSegue" {
            self.tableContainer = vc
            //self.tableContainer.delegate = self
            self.tableContainer.postulants = self.postulants
            self.tableContainer.job = self.job!
        }
    }
    @IBAction func dismissAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
