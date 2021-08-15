//
//  OnboardingCollectionViewCell.swift
//  meng-app
//
//  Created by Hannatassja Hardjadinata on 16/08/21.
//

import UIKit

class OnboardingCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var onboardingImageView: UIImageView!
    @IBOutlet weak var onboardingHeadline: UILabel!
    @IBOutlet weak var onboardingDetail: UILabel!
    
    func setup (_ slide: OnboardingModel){
        onboardingImageView.image = slide.image
        onboardingHeadline.text = slide.title
        onboardingDetail.text = slide.desc
    }
}
