//
//  TeamCell.swift
//  Tatawei Organisation
//
//  Created by omar alzhrani on 13/05/1446 AH.
//

import UIKit

class TeamCell: UICollectionViewCell {
    
    @IBOutlet weak var backGroundView: UIView!
    @IBOutlet weak var officialImage: UIImageView!
    @IBOutlet weak var officialName: UILabel!
    
    func config(backGroundView: UIColor, image: UIImage, name: String){
        self.backGroundView.backgroundColor = backGroundView
        officialImage.image = image
        officialName.text = name
        
    }
}
