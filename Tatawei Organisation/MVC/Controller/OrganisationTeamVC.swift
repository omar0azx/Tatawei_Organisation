//
//  OrganisationTeamVC.swift
//  Tatawei Organisation
//
//  Created by omar alzhrani on 13/05/1446 AH.
//

import UIKit

class OrganisationTeamVC: UIViewController, Storyboarded {
    
    
    //MARK: - Varibales
    
    var coordinator: MainCoordinator?
    
    var officials: [Official] = []
    var leader: Official?
    
    
    //MARK: - IBOutleats
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var organisationImage: UIImageView!
    @IBOutlet weak var organisationName: UILabel!
    @IBOutlet weak var organisationDescription: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        getOfficialsFromOrganisation()
        getOrganisationInformation()
        
    }
    
    //MARK: - IBAcitions
    
    
    //MARK: - Functions
//    
    func getOrganisationInformation() {
        if let official = Official.currentOfficial, let organization = Organization.currentOrganization {
            StorageService.shared.downloadImage(from: "organisations_icons/\(official.organizationID).jpg") { imag, error in
                guard let image = imag else {return}
                self.organisationImage.image = image
            }
            organisationName.text = organization.name
            organisationDescription.text = organization.description
        }
        
    }
    
    func getOfficialsFromOrganisation() {
        
        if let organisation = Organization.currentOrganization {
            OfficialDataService.shared.getAllOfficialsFromOrganisation(organisationID: organisation.id) { allofficials, error in
                if error != nil {
                    print("No students found.")
                } else {
                    self.leader = allofficials.filter{$0.role == 0}.first
                    self.officials = allofficials.filter{$0.role == 1}
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }
            }
        } else {
            print("No school found for the current student.")
        }
        
        
    }
}
    
    extension OrganisationTeamVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
        
        func numberOfSections(in collectionView: UICollectionView) -> Int {
            return 2
        }
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return section == 0 ? 1 : officials.count
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: self.view.frame.width * 0.8, height: 70)
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TeamCell", for: indexPath) as! TeamCell
            if let official = Official.currentOfficial {
                if indexPath.section == 0 {
                    cell.officialName.textColor = .white
                    cell.config(backGroundView: .standr, image: leader?.gender == .male ? #imageLiteral(resourceName: "man.svg") : #imageLiteral(resourceName: "women.svg"), name: leader?.name ?? "")
                } else {
                    cell.config(backGroundView: .systemGray5, image: officials[indexPath.row].gender == .male ? #imageLiteral(resourceName: "man.svg") : #imageLiteral(resourceName: "women.svg"), name: officials[indexPath.row].name)
                }
            }
            
            return cell
        }
        
        func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
            if kind == UICollectionView.elementKindSectionHeader {
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "RankHeaderView", for: indexPath) as! RankHeaderView
                
                if indexPath.section == 0 {
                    headerView.titleLabel.text = "القائد"
                } else {
                    headerView.titleLabel.text = "الأعضاء"
                }
                return headerView
            }
            return UICollectionReusableView()
        }
        
    }
