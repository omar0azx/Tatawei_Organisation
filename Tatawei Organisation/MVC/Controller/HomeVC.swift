//
//  HomeVC.swift
//  Tatawei Organisation
//
//  Created by omar alzhrani on 08/05/1446 AH.
//

import UIKit

class HomeVC: UIViewController, Storyboarded {

    var coordinator: MainCoordinator?
    
    @IBOutlet weak var officialName: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    private var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupRefreshControl()
        tableView.showsVerticalScrollIndicator = false
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        
    }
    
    @IBAction func showQRCode(_ sender: UIButton) {
        print("showQRCode")
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
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    func updateOrganisationData() {
        if let organisationID = Organization.currentOrganization?.id {
            OfficialDataService.shared.getOrganisationData(organisationID: organisationID) { status, error in
                if status! {
                    print("Success to update locally storage")
                } else {
                    print("Have problem when update locally storage")
                }
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
                cell.config(organisationRate: "\(organisation.rate)", numberOfOpportunities: "\(organisation.opportunitiesNumber)", numberOfStudents: "\(organisation.volunteersNumber)", opportunitiesHours: "0")
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
    
