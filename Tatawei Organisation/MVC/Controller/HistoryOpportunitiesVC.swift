//
//  HistoryOpportunitiesVC.swift
//  Tatawei Organisation
//
//  Created by Wesam Kadah on 21/11/2024.
//

import UIKit

class HistoryOpportunitiesVC: UIViewController, Storyboarded {
    
    //MARK: - Varibales
    var coordinator: MainCoordinator?
    var opportunities = [Opportunity]()
    
    //MARK: - @IBOutlet
    
    @IBOutlet weak var emptyMessage: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    //MARK: - IBAcitions
    @IBAction func didPressedView(_ sender: UIButton) {
        self.dismiss(animated: true)
    }

    
    //MARK: - Functions

}

extension HistoryOpportunitiesVC: UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        emptyMessage.isHidden = opportunities.count > 0 ? true : false
        emptyMessage.alpha = opportunities.count > 0 ? 0 : 1
        return opportunities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryOpportunitiesCell") as! HistoryOpportunitiesCell
        let cellColorAndIcon = Icon(index: opportunities[indexPath.row].iconNumber, category: opportunities[indexPath.row].category).opportunityIcon
        let isFirstCell = indexPath.row == 0
        let isLastCell = indexPath.row == opportunities.count - 1
        
        cell.configOpportunity(opportunityName: opportunities[indexPath.row].name, opportunityTime: opportunities[indexPath.row].time, opportunityDate: opportunities[indexPath.row].date, opportunityIcon: cellColorAndIcon.0, isFirstCell: isFirstCell, isLastCell: isLastCell)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
    
}
