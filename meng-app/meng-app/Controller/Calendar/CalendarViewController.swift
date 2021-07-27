//
//  CalendarViewController.swift
//  meng-app
//
//  Created by Hannatassja Hardjadinata on 27/07/21.
//

import UIKit


class CalendarViewController: UIViewController {

    let activitiesCellId = "ActivitiesTableViewCell"

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var calendarUIView: UIView!
    
    
    
    var activities_more = [Activities]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.tableView.register(UINib.init(nibName: activitiesCellId, bundle: nil), forCellReuseIdentifier: activitiesCellId)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorColor =  .clear
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        tableView.backgroundColor = .clear
        
        for i in 1...25 {
            let activity = Activities()
            activity.title = "Macbook appointment"
            activity.catName = "Meh"
            activity.time = "11.00 AM"
            activity.id = i
            activities_more.append(activity)
            
        }
        
        tableView.reloadData()
        
    }
    
    override func viewDidLayoutSubviews() {
        let shadowPath = UIBezierPath(roundedRect: calendarUIView.bounds, cornerRadius: 13)
        
        calendarUIView.layer.masksToBounds = false
        calendarUIView.layer.shadowColor = UIColor.black.cgColor
        calendarUIView.layer.shadowOffset = .zero
        calendarUIView.layer.shadowOpacity = 0.15
        calendarUIView.layer.shadowRadius = 60
        calendarUIView.layer.shadowPath = shadowPath.cgPath
    }


}

extension CalendarViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.activities_more.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: activitiesCellId, for: indexPath) as! ActivitiesTableViewCell
        
        let activity = activities_more[indexPath.row]
        
        cell.activityTitleLabel.text = activity.title
        cell.activityCatNameLabel.text = activity.catName
        cell.selectionStyle = .none
        
        return cell
    }
    
}
