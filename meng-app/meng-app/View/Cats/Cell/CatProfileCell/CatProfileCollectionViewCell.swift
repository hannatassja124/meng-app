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
        setupView()
    }
    
    func setupView(){
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = petImage.frame
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradient.locations = [0.8, 1.1]
        petImage.layer.insertSublayer(gradient, at: 0)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        petImage.image = UIImage(named: "CatProfileDefault")
        petGenderIcon.image = UIImage(named: "Male")
        petNameLabel.text = "CatName"
    }

}
