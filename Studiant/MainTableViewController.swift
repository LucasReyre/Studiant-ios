//
//  MainTableViewController.swift
//
// Copyright (c) 21/12/15. Ramotion Inc. (http://ramotion.com)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit
import FoldingCell
import TRON
import SwiftSpinner

class MainTableViewController: UITableViewController, CellJobEtudiantDelegate {
  
  let kCloseCellHeight: CGFloat = 179
  let kOpenCellHeight: CGFloat = 541
  var cellHeights: [CGFloat] = []
  let tron = TRON(baseURL: "https://loopbackstudiant.herokuapp.com/api/")
  let tronStudiant = TRON(baseURL: "https://www.studiant.fr/notification/")
    
  var isDataLoad = false
  var jobs: [JobResponse] = []
  var user : User!
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
        request.parameters = ["filter[include][appartenir]":""]
        
        if self.filter != nil{
            SwiftSpinner.show("Récupération des jobs en cours")
            request.parameters = self.filter!
        }
        
        
        print(request)
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
    
    func onPostulerTouch(job : JobResponse) {
        SwiftSpinner.show("Candidature en cours")
        let postRequest: APIRequest<JobResponse, ErrorResponse> = tron.request("Postulants/")
        postRequest.method = .post
        
        postRequest.parameters = ["timePostulant": String(NSDate().timeIntervalSince1970),
                                  "statutPostulant": "0",
                                  "jobId": job.idJob,
                                  "utilisateurId" : self.user.idUtilisateur!]
        
        postRequest.perform(withSuccess: { (jobResponse) in
            SwiftSpinner.show("Votre Candidature à bien été prise en compte !", animated: false).addTapHandler({
                SwiftSpinner.hide()
            })
            
            let postRequest: APIRequest<NotificationResponse, ErrorResponse> = self.tronStudiant.request("notification.php")
            postRequest.method = .get
            
            let body : String = self.user.prenomUtilisateur!+" à postulé à votre job "
            postRequest.parameters = ["token": job.appartenir.firebaseToken]
            postRequest.parameters = ["body": body]
            
            postRequest.perform(withSuccess: { (notificationResponse) in
                print("success")
                print(notificationResponse)
                
            }) { (error) in
                print("error")
                print(error)
            }
            
        
            print(jobResponse)
            //self.performSegue(withIdentifier: "AjoutJobSegue", sender: self)
        }) { (error) in
            SwiftSpinner.show("Erreur vous avez déja postulé", animated: false).addTapHandler({
                SwiftSpinner.hide()
            })
            
            print(error)
        }

        
    }
}

// MARK: - TableView
extension MainTableViewController {
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return jobs.count
  }
  
  override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    guard case let cell as CellJobEtudiant = cell else {
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
