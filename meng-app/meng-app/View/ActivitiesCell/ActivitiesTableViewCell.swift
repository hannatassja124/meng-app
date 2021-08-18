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
    
    var object: Activity? {
        didSet {
            cellConfig()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func cellConfig() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"

        guard let obj = object else { return }
        let name = obj.cats?.value(forKey: "name")
//        let name = object.cats.value(forKey: "name") //NSSet
        let catName = (name as AnyObject).allObjects //Swift Array

        //color tag
        let color = obj.cats?.value(forKey: "colorTags") //NSSet
        let colorTag = (color as AnyObject).allObjects //Swift Array

        activityTitleLabel.text = obj.activityTitle
        activityTimeLabel.text = dateFormatter.string(from: obj.activityDateTime ?? Date())
        
//        activityCatNameLabel.text = "\(catName?[0] ?? "")"
        activityTypeImage.image = UIImage(named: obj.activityType!)
//        activitiesColorTagImage.tintColor = TagsHelper.checkColor(tagsNumber: colorTag![0] as! Int16)
        selectionStyle = .none
    }
}
