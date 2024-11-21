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
    
    //MARK: - IBOutleats

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emtyMessage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    
    
    //MARK: - Functions
    
    func loadOpportunities() {
        // Retrieve all saved opportunities
        let allOpportunities = OpportunityRealmService.shared.getAllOpportunities()
        self.finishedOpportunities = allOpportunities.filter{$0.status == .finished}
        self.opportunities = allOpportunities.filter{$0.status == .open || $0.status == .inProgress}
        tableView.reloadData()
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

