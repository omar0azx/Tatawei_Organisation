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


    override func viewDidLoad() {
        super.viewDidLoad()




    }

}

extension AttendanceVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? self.todayOpportunities.count : self.otherOpportunities.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
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
            cell.config(image: UIImage(named: "join")!, name: todayOpportunities.first!.name, time: todayOpportunities.first!.time, date: todayOpportunities.first!.date)
        } else {
            cell.config(image: UIImage(named: "join")!, name: otherOpportunities.first!.name, time: otherOpportunities.first!.time, date: otherOpportunities.first!.date)

        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
           if kind == UICollectionView.elementKindSectionHeader {
               let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "OpportunityHeaderView", for: indexPath) as! OpportunityHeaderView
               
               if indexPath.section == 0 {
                   headerView.titleLabel.text = "اليوم"
               } else {
                   headerView.titleLabel.text = "بعدين"
               }
               return headerView
           }
           return UICollectionReusableView()
       }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let selectedOpportunity: Opportunity
            if indexPath.section == 0 {
                selectedOpportunity = todayOpportunities[indexPath.row]
            } else {
                selectedOpportunity = otherOpportunities[indexPath.row]
            }
                    
        coordinator?.viewIntroAttendanceVC(name: selectedOpportunity.name, description: selectedOpportunity.description)
        }

}
