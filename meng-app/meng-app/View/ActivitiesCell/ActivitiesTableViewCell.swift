//
//  ActivitiesTableViewCell.swift
//  meng-app
//
//  Created by Hannatassja Hardjadinata on 27/07/21.
//

import UIKit

class ActivitiesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var activityTypeImage: UIImageView!
    @IBOutlet weak var activityTitleLabel: UILabel!
    @IBOutlet weak var activityCatNameLabel: UILabel!
    @IBOutlet weak var activityTimeLabel: UILabel!
    @IBOutlet weak var activitiesColorTagImage: UIImageView!
    @IBOutlet weak var backgroundCell: UIView!
    
    var objDashboard: Activity? {
        didSet {
            cellConfigDashboard()
        }
    }
    
    var object: Activity? {
        didSet {
            cellConfig()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func cellConfig() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"

        guard let obj = object else { return }

        if let catName = obj.cats!.allObjects as? [Cats], !catName.isEmpty{
            activitiesColorTagImage.tintColor = TagsHelper.checkColor(tagsNumber: catName[0].colorTags)
            activityCatNameLabel.text = "\(catName[0].name ?? "no cat name")"
        }
        
        activityTitleLabel.text = obj.activityTitle
        if let time =  obj.activityDateTime {
            activityTimeLabel.text = dateFormatter.string(from: time)
        }
        if let image = obj.activityType {
            activityTypeImage.image = UIImage(named: image)
        }
        selectionStyle = .none
    }
    
    func cellConfigDashboard() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd yyyy, hh:mm a"

        guard let obj = objDashboard else { return }
    
        if let catName = obj.cats!.allObjects as? [Cats], !catName.isEmpty{
            activitiesColorTagImage.tintColor = TagsHelper.checkColor(tagsNumber: catName[0].colorTags)
            activityCatNameLabel.text = "\(catName[0].name ?? "no cat name")"
        }
        
        activityTitleLabel.text = obj.activityTitle
        if let time =  obj.activityDateTime {
            activityTimeLabel.text = dateFormatter.string(from: time)
        }
        if let image = obj.activityType {
            activityTypeImage.image = UIImage(named: image)
        }
        selectionStyle = .none
    }
}
