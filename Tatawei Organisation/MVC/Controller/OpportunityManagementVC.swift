//
//  OpportunityManagementVC.swift
//  Tatawei Organisation
//
//  Created by omar alzhrani on 08/05/1446 AH.
//

import UIKit

class OpportunityManagementVC: UIViewController, Storyboarded {
    
    //MARK: - Varibales
    
    var coordinator: MainCoordinator?
    
    var opportunities: [Opportunity] = []
    var searchedOpportunities = [Opportunity]()
    var finishedOpportunities = [Opportunity]()
    
    private var refreshControl: UIRefreshControl!
    
    //MARK: - IBOutleats

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emtyMessage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupRefreshControl()
        loadOpportunities()
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        loadOpportunities()
    }
    
    //MARK: - IBAcitions
    
    @IBAction func searchOpportunityTF(_ sender: UITextField) {
        if let serchText = sender.text {
            searchedOpportunities = serchText.isEmpty ? opportunities : opportunities.filter{$0.name.lowercased().contains(serchText.lowercased())}
            tableView.reloadData()
        }
    }
    
    @IBAction func historyBtn(_ sender: UIButton) {
        coordinator?.viewHistoryOpportunitiesVC(opportunities: finishedOpportunities)
    }
    
    
    //MARK: - Functions
    
    func loadOpportunities() {
        // Retrieve all saved opportunities
        let allOpportunities = OpportunityRealmService.shared.getAllOpportunities()
        self.finishedOpportunities = allOpportunities.filter{$0.status == .finished}
        self.opportunities = allOpportunities.filter{$0.status == .open || $0.status == .inProgress}
        tableView.reloadData()
    }
    
    private func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshTableView), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    @objc private func refreshTableView() {
        getAllOpportunity()
        loadOpportunities()
        checkOpportunityStatus()
        refreshControl.endRefreshing()
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

extension OpportunityManagementVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        emtyMessage.isHidden = opportunities.count > 0 ? true : false
        emtyMessage.alpha = opportunities.count > 0 ? 0 : 1
        return opportunities.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OpportunityCell", for: indexPath) as! OpportunityCell
        let cellColorAndIcon = Icon(index: opportunities[indexPath.row].iconNumber, category: opportunities[indexPath.row].category).opportunityIcon
        cell.config(backGroundView: cellColorAndIcon.1, image: cellColorAndIcon.0, name: opportunities[indexPath.row].name, time: opportunities[indexPath.row].time, date: opportunities[indexPath.row].date, isFinished: opportunities[indexPath.row].isStudentsAcceptanceFinished)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        coordinator?.viewOpportunityVC(opportunity: opportunities[indexPath.row])
    }
}

