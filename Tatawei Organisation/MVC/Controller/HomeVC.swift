//
//  HomeVC.swift
//  Tatawei Organisation
//
//  Created by omar alzhrani on 08/05/1446 AH.
//

import UIKit

class HomeVC: UIViewController, Storyboarded {
    
    //MARK: - Varibales

    var coordinator: MainCoordinator?
    
    @IBOutlet weak var officialName: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    private var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllOpportunity()
        setupUI()
        setupRefreshControl()
        tableView.showsVerticalScrollIndicator = false
    }
    
    @IBAction func showQRCode(_ sender: UIButton) {
        coordinator?.viewQRScannerRatingVC()
    }
    
    //MARK: - Functions
    
    private func setupUI() {
        
        if let official = Official.currentOfficial {
            if let firstName = official.name.split(separator: " ").first {
                officialName.text = "🖐🏼 أهلاً \(firstName)"
            }
        }
    }
    
    private func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshTableView), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    @objc private func refreshTableView() {
        updateOrganisationData()
        getAllOpportunity()
        checkOpportunityStatus()
        refreshControl.endRefreshing()
    }
    
    func updateOrganisationData() {
        if let organisationID = Organization.currentOrganization?.id {
            OrganisationDataService.shared.getOrganisationData(organisationID: organisationID) { status, error in
                if status! {
                    print("Success to update locally storage")
                } else {
                    print("Have problem when update locally storage")
                }
            }
        }
    }
    
    func getAllOpportunity() {
        if let organisation = Organization.currentOrganization {
            OpportunityDataService.shared.getAllOpportunities(organisationID: organisation.id) { success, error in
                if success {
                    print("Success to get all opportunity")
                    self.tableView.reloadData()
                } else {
                    
                }
            }
        }
    }
    
    func checkOpportunityStatus() {
        OpportunityDataService.shared.checkAndUpdateOpportunitiesStatus { error in
            if error == nil {
                print("Updated opportunity status")
            } else {
                print("Cat't updated opportunity status")
            }
        }
    }

}

extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return self.view.frame.height * 0.25
        } else {
            return self.view.frame.height * 0.5
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            return tableView.dequeueReusableCell(withIdentifier: "HomeCell-1", for: indexPath)
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell-2", for: indexPath) as! HomeCell
            if let organisation = Organization.currentOrganization {
                cell.config(organisationRate: organisation.rate, numberOfOpportunities: organisation.opportunitiesNumber, numberOfStudents: organisation.volunteersNumber, opportunitiesHours: organisation.completedOpportunitesHours)
            }
            return cell
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if self.refreshControl!.isRefreshing {
            print("hi")
            self.refreshControl!.endRefreshing()
        }
    }
    
}
    
