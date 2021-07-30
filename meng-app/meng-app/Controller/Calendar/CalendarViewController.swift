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

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var activities:[Activity] = [Activity()]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.tableView.register(UINib.init(nibName: activitiesCellId, bundle: nil), forCellReuseIdentifier: activitiesCellId)
        tableView.separatorColor =  .clear
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        tableView.backgroundColor = .clear
        
        let activity = Activity(context: context)
        activity.activityTitle = "Test"
        activity.activityType = "Meng"
        activity.activityDetail = "Bah"
        
        do {
            try context.save()
        } catch {
            //error
        }
        
//        for i in 1...3 {
//            let activity = Activity()
//            activity.activityTitle = "Test"
//            activities.append(activity)
//
//        }
        
        tableView.reloadData()
        
    }
    
    
    @IBAction func addActivityPage(_ sender: Any) {
//        let vc = self.storyboard!.instantiateViewController(identifier: "activityLog") as! ActivityLogViewController
//    
//        
//        self.navigationController?.pushViewController(vc, animated: true)
//        
//        
        
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
        if self.activities.count == 0 {
            self.tableView.setEmptyMessage("Tap the + button to add activity log!")
        } else  {
            self.tableView.restore()
        }
        
        return self.activities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: activitiesCellId, for: indexPath) as! ActivitiesTableViewCell
        
        cell.selectionStyle = .none
        
        return cell
    }
    
}

extension UITableView {
    func setEmptyMessage(_ message: String) {
        
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = #colorLiteral(red: 0.108859323, green: 0.3016951084, blue: 0.3573893309, alpha: 0.4)
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont.systemFont(ofSize: 13.0)
        messageLabel.sizeToFit()

        self.backgroundView = messageLabel
        self.separatorStyle = .none
    }

    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}
