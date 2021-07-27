//
//  CatProfileCollectionViewCell.swift
//  meng-app
//
//  Created by Arya Ilham on 27/07/21.
//

import UIKit

class CatProfileCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var petImage: UIImageView!
    @IBOutlet weak var petGenderIcon: UIImageView!
    @IBOutlet weak var petTagsColor: UIImageView!
    @IBOutlet weak var petNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupView(){
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = petImage.frame
        gradient.colors = [UIColor.black.cgColor, UIColor.clear
                            .cgColor]
        gradient.locations = [0.0, 0.1]
        petImage.layer.insertSublayer(gradient, at: 0)
        
    }

}
