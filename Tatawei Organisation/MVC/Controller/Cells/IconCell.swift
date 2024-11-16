//
//  IconCell.swift
//  Tatawei Organisation
//
//  Created by omar alzhrani on 14/05/1446 AH.
//

import UIKit

class IconCell: UICollectionViewCell {
    
    @IBOutlet weak var backGroundView: UIView!
    @IBOutlet weak var iconImage: UIImageView!
    
    func config(backGroundView: UIColor, image: UIImage){
        self.backGroundView.backgroundColor = backGroundView
        iconImage.image = image
    }
}
