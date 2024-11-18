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
    
    //MARK: - IBOutleats

    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadOpportunities()
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        loadOpportunities()
    }
    
    //MARK: - IBAcitions
    
    //MARK: - Functions
    
    func loadOpportunities() {
        // Retrieve all saved opportunities
        if let allOpportunities = Opportunity.allOpportunities {
            opportunities = allOpportunities
            tableView.reloadData()
        }
        
    }
    
}

extension OpportunityManagementVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return opportunities.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OpportunityCell", for: indexPath) as! OpportunityCell
        let cellColorAndIcon = Icon(index: opportunities[indexPath.row].iconNumber).opportunityIcon
        cell.config(backGroundView: cellColorAndIcon.1, image: cellColorAndIcon.0, name: opportunities[indexPath.row].name, time: opportunities[indexPath.row].time, date: opportunities[indexPath.row].date)
        return cell
    }
}

