//
//  AttendanceVC.swift
//  Tatawei Organisation
//
//  Created by omar alzhrani on 08/05/1446 AH.
//

import UIKit

class AttendanceVC: UIViewController, Storyboarded {
    
    //MARK: - Varibales
    
    var coordinator: MainCoordinator?
    var todayOpportunities: [Opportunity] = []
    var otherOpportunities: [Opportunity] = []
    
    private var refreshControl: UIRefreshControl!
    
    //MARK: - IBOutleats
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var emtyMessage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadOpportunities()
        setupRefreshControl()
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        loadOpportunities()
    }
    
    func loadOpportunities() {
        // Retrieve all saved opportunities
        let todayDate = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .none)
        let allOpportunities = OpportunityRealmService.shared.getAllOpportunities().filter{$0.status == .inProgress && $0.isStudentsAcceptanceFinished == true}
        self.todayOpportunities = allOpportunities.filter{$0.date == todayDate}
        self.otherOpportunities = allOpportunities.filter{$0.date != todayDate}
        collectionView.reloadData()
    }
    
    private func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshTableView), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }
    
    @objc private func refreshTableView() {
        loadOpportunities()
        refreshControl.endRefreshing()
    }
    
}

extension AttendanceVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if todayOpportunities.count == 0 && otherOpportunities.count == 0 {
            emtyMessage.isHidden = false
            emtyMessage.alpha = 1
        } else {
            emtyMessage.isHidden = true
            emtyMessage.alpha = 0
        }
        return section == 0 ? self.todayOpportunities.count : self.otherOpportunities.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 347, height: 100)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OpportunityAttendanceCell", for: indexPath) as! OpportunityAttendanceCell
        if indexPath.section == 0 {
            let cellIcon = Icon(index: todayOpportunities[indexPath.row].iconNumber, category: todayOpportunities[indexPath.row].category).opportunityIcon
            cell.config(image: cellIcon.0, name: todayOpportunities[indexPath.row].name, time: todayOpportunities[indexPath.row].time, date: todayOpportunities[indexPath.row].date)
        } else {
            let cellIcon = Icon(index: otherOpportunities[indexPath.row].iconNumber, category: otherOpportunities[indexPath.row].category).opportunityIcon
            cell.config(image: cellIcon.0, name: otherOpportunities[indexPath.row].name, time: otherOpportunities[indexPath.row].time, date: otherOpportunities[indexPath.row].date)

        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
            
            if kind == UICollectionView.elementKindSectionHeader {
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "OpportunityHeaderView", for: indexPath) as! OpportunityHeaderView
                
                if indexPath.section == 0 {
                    if todayOpportunities.count == 0 {
                        headerView.titleLabel.text = ""
                    } else {
                        headerView.titleLabel.text = "اليوم"
                    }
                } else {
                    if otherOpportunities.count == 0 {
                        headerView.titleLabel.text = ""
                    } else {
                        headerView.titleLabel.text = "الأوقات القادمة"
                    }
                }
                return headerView
            }
        
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            coordinator?.viewIntroAttendanceVC(opportunity: todayOpportunities[indexPath.row])
        } else {
            let errorView = MessageView(message: "التاريخ غير متوافق مع تاريخ الفرصة", animationName: "warning", animationTime: 1)
            errorView.show(in: self.view)
        }
    }
    
}
