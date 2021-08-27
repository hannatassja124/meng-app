//
//  ActivityDetailViewController.swift
//  meng-app
//
//  Created by Hannatassja Hardjadinata on 02/08/21.
//

import UIKit

class ActivityDetailViewController: UIViewController {
    
    
    // MARK: - Outlet
    
    @IBOutlet weak var detailTableView: UITableView!
    @IBOutlet weak var catNameLabel: UILabel!
    @IBOutlet weak var colorTagImage: UIImageView!
    @IBOutlet weak var activityTypeImage: UIImageView!
    @IBOutlet weak var activityTitleLabel: UILabel!
    @IBOutlet weak var activityDetailLabel: UILabel!
    
    // MARK: - Variables
    
    let calendar = Calendar.current
    let dateFormatter = DateFormatter()
    var details = Activity()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    // MARK: - Function
    
    func initView() {
        if let catName = details.cats!.allObjects as? [Cats], !catName.isEmpty{
            colorTagImage.tintColor = TagsHelper.checkColor(tagsNumber: catName[0].colorTags)
            catNameLabel.text = "\(catName[0].name ?? "no cat name")"
        }
        activityTitleLabel.text = details.activityTitle
        activityDetailLabel.text = details.activityDetail
        
        if let activityImage = details.activityType {
            activityTypeImage.image = UIImage(named: activityImage)
        }
    }
    
    // MARK: - Action
    
    @IBAction func backToPrevious(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func goToEditActivityPage(_ sender: Any) {
        let storyboard = UIStoryboard(name: "ActivityLog", bundle: nil)
        
        guard let vc = storyboard.instantiateViewController(withIdentifier: "ActivityLogStoryboard") as? ActivityLogTableViewController
        else {
            fatalError("no vc")
        }
        vc.EditedActivity = details
        let nc = UINavigationController(rootViewController: vc)
        nc.setNav(root:nc)
        self.present(nc, animated: true, completion: nil)
    }
    
}

    // MARK: - Class Cell

class detailTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
}

    // MARK: - Delegate & Data Source

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
        guard let cell = detailTableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath) as? detailTableViewCell else {
            fatalError("no cell")
        }
        if indexPath.section == 0 && indexPath.row == 0 {
            dateFormatter.dateFormat = "MMM dd, yyyy"
            cell.titleLabel.text = "Date"
            if let dateTime = details.activityDateTime {
                cell.detailLabel.text = dateFormatter.string(from: dateTime)
            }
        } else if indexPath.section == 0 && indexPath.row == 1 {
            dateFormatter.dateFormat = "hh:mm a"
            cell.titleLabel.text = "Time"
            if let dateTime = details.activityDateTime {
                cell.detailLabel.text = dateFormatter.string(from: dateTime)
            }
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
