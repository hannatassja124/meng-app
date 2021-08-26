//
//  CatProfileCollectionViewCell.swift
//  meng-app
//
//  Created by Arya Ilham on 27/07/21.
//

import UIKit

class CatProfileCollectionViewCell: UICollectionViewCell {
    //MARK: - Outlets
    @IBOutlet weak var petImage: UIImageView!
    @IBOutlet weak var petGenderIcon: UIImageView!
    @IBOutlet weak var petTagsColor: UIImageView!
    @IBOutlet weak var petNameLabel: UILabel!
    
    //MARK: - Variables
    var data:Cats?{
        didSet{
            cellConfig()
        }
    }
    
    //MARK: - Functions
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
    
    private func cellConfig(){
        guard let catData = data else {
            return
        }
        
        if let image = catData.image {
            petImage.image = UIImage(data: image)
        }
        //name
        if let name = catData.name {
            petNameLabel.text = "\(name)"
        }
        //gender icon
        petGenderIcon.image = UIImage(named: (catData.gender == 0 ? "Male" : "Female"))
        //tint color
        petTagsColor.tintColor = TagsHelper.checkColor(tagsNumber: catData.colorTags)
    }

}
