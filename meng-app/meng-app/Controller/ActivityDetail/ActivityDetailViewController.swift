//
//  ActivityDetailViewController.swift
//  meng-app
//
//  Created by Hannatassja Hardjadinata on 02/08/21.
//

import UIKit

class ActivityDetailViewController: UIViewController {
    
    let calendar = Calendar.current
    let dateFormatter = DateFormatter()
    var details = Activity()
    
    @IBOutlet weak var detailTableView: UITableView!
    @IBOutlet weak var catNameLabel: UILabel!
    @IBOutlet weak var colorTagImage: UIImageView!
    @IBOutlet weak var activityTypeImage: UIImageView!
    @IBOutlet weak var activityTitleLabel: UILabel!
    @IBOutlet weak var activityDetailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.detailTableView.delegate = self
        self.detailTableView.dataSource = self

        
        initView()
        // Do any additional setup after loading the view.
    }
    
    func initView() {
        
        let name = details.cats!.value(forKey: "name")
        let catName = (name as AnyObject).allObjects
        
        //color tag
        let color = details.cats!.value(forKey: "colorTags") //NSSet
        let colorTag = (color as AnyObject).allObjects //Swift Array
        
        catNameLabel.text = "\(catName![0])"
        colorTagImage.tintColor = TagsHelper.checkColor(tagsNumber: colorTag![0] as! Int16)
        activityTitleLabel.text = details.activityTitle
        activityDetailLabel.text = details.activityDetail
        activityTypeImage.image = UIImage(named: details.activityType!)
        
    }
    
    @IBAction func backToPrevious(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func goToEditActivityPage(_ sender: Any) {
        let storyboard = UIStoryboard(name: "ActivityLog", bundle: nil)
       
        let vc = storyboard.instantiateViewController(withIdentifier: "ActivityLogStoryboard") as! ActivityLogTableViewController
        
        vc.EditedActivity = details
        
        
        let nc = UINavigationController(rootViewController: vc)
        nc.navigationBar.isTranslucent = false
        nc.navigationBar.barTintColor = #colorLiteral(red: 0.1036602035, green: 0.2654651999, blue: 0.3154058456, alpha: 1)
        nc.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        
        
        self.present(nc, animated: true, completion: nil)
    }
    
}

class detailTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
}


extension ActivityDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        } else if section == 1{
            return 1
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = detailTableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath) as! detailTableViewCell
        
        if indexPath.section == 0 && indexPath.row == 0 {
            
            dateFormatter.dateFormat = "MMM dd, yyyy"
            cell.titleLabel.text = "Date"
            cell.detailLabel.text = dateFormatter.string(from: details.activityDateTime!)
            
        } else if indexPath.section == 0 && indexPath.row == 1 {
            
            dateFormatter.dateFormat = "hh:mm a"
            cell.titleLabel.text = "Time"
            cell.detailLabel.text = dateFormatter.string(from: details.activityDateTime!)
            
        } else if indexPath.section == 1 && indexPath.row == 0 {
            cell.titleLabel.text = "Reminder"
            cell.detailLabel.text = ReminderHelper.checkReminder(typeNumber: details.activityReminder)
        }
        
        
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
}
