//
//  ActivitiesTVC.swift
//  meng-app
//
//  Created by William Giovanni Kambuno on 07/08/21.
//

import UIKit

class ActivitiesTVC: UITableViewCell {

    @IBOutlet weak var CollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        CollectionView.register(UINib(nibName: "ActivitiesCVC", bundle: nil), forCellWithReuseIdentifier: "ActivitiesCVCID")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
