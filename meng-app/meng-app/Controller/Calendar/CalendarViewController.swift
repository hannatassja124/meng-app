//
//  CalendarViewController.swift
//  meng-app
//
//  Created by Hannatassja Hardjadinata on 27/07/21.
//

import UIKit
import CoreData


class CalendarViewController: UIViewController {

    let activitiesCellId = "ActivitiesTableViewCell"

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var calendarUIView: UIView!

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var activities = [Activity()]
    var cats = [Cats()]
    let calendar = Calendar.current
    let dateFormatter = DateFormatter()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.tableView.register(UINib.init(nibName: activitiesCellId, bundle: nil), forCellReuseIdentifier: activitiesCellId)
        tableView.separatorColor =  .clear
        
        tableView.backgroundColor = .clear
        
        //save()
        
        let year = calendar.component(.year, from: Date())
        let month = calendar.component(.month, from: Date())
        let day = calendar.component(.day, from: Date())
        
        let combinedDate = "\(year)-\(month)-\(day) 00:00:00 +0700"
        
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss Z"
        
        retrieveData(activityDate: dateFormatter.date(from: combinedDate)!)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        let year = calendar.component(.year, from: Date())
//        let month = calendar.component(.month, from: Date())
//        let day = calendar.component(.day, from: Date())
//
//        let combinedDate = "\(year)-\(month)-\(day) 00:00:00 +0700"
//
//        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss Z"
//
//        retrieveData(activityDate: dateFormatter.date(from: combinedDate)!)
        
        self.tableView.reloadData()

    }
    
    override func viewDidLayoutSubviews() {
        
        if Core.shared.isNewUser(){
            let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "getStartedStoryboard") as! GetStartedViewController
            vc.modalPresentationStyle =  .fullScreen
            present(vc, animated: true)
        }
        
        let shadowPath = UIBezierPath(roundedRect: calendarUIView.bounds, cornerRadius: 13)
        
        calendarUIView.layer.masksToBounds = false
        calendarUIView.layer.shadowColor = UIColor.black.cgColor
        calendarUIView.layer.shadowOffset = .zero
        calendarUIView.layer.shadowOpacity = 0.15
        calendarUIView.layer.shadowRadius = 60
        calendarUIView.layer.shadowPath = shadowPath.cgPath
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let storyboard = UIStoryboard(name: "ActivityLog", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "ActivityLogStoryboard") as! ActivityLogTableViewController
        if segue.identifier == "activityLogSegue" {
            let vc = segue.destination as! UINavigationController
            let target = vc.topViewController as! ActivityLogTableViewController
            
            let year = calendar.component(.year, from: Date())
            let month = calendar.component(.month, from: Date())
            let day = calendar.component(.day, from: Date())
            let combinedDate = "\(year)-\(month)-\(day) 00:00:00 +0700"
            dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss Z"
            
            target.onViewWillDisappear = {
                self.retrieveData(activityDate: self.dateFormatter.date(from: combinedDate)!)
            }
        }
    }
    
    // MARK: - Function
    
    func retrieveData(activityDate : Date) {
        do {
            print("retrieve data")
            
            let fr: NSFetchRequest<Activity>
            fr = Activity.fetchRequest()
            print()
            fr.predicate = NSPredicate(format: "activityDateTime >= %@ && activityDateTime <= %@", activityDate as CVarArg, activityDate+86400 as CVarArg)
            
            activities = try context.fetch(fr)
            print("jumlah", activities.count)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            print("error")
        }
        
    }
    
    func save() {

        let activity = Activity(context: context)
        activity.activityTitle = "Test"
        activity.activityDateTime = Date()
        activity.activityDetail = "Help"
        activity.activityType = "1"
        activity.activityReminder = 60
        
        
        let cats = Cats(context: context)
        cats.name = "Tulul"
        cats.colorTags = 1
        
        activity.addToCats(cats)
        
        
        do {
            try context.save()
        } catch {
            print("error")
        }
        
    }
    
    // MARK: calendar - ACTION
    
    @IBAction func addActivityPage(_ sender: Any) {
        
    }

}

// MARK: - Data Source & Delegate

extension CalendarViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.activities.count == 0 {
            self.tableView.setEmptyMessage("Tap the + button to add activity log!")
        } else {
            self.tableView.restore()
        }
        
        return self.activities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: activitiesCellId, for: indexPath) as! ActivitiesTableViewCell
        
        let data = activities[indexPath.row]
        
        dateFormatter.dateFormat = "hh:mm a"
        
        //catname
        let name = data.cats!.value(forKey: "name") //NSSet
        let catName = (name as AnyObject).allObjects //Swift Array
        
        //color tag
        let color = data.cats!.value(forKey: "colorTags") //NSSet
        let colorTag = (color as AnyObject).allObjects //Swift Array
        
        cell.activityTitleLabel.text = data.activityTitle
        cell.activityTimeLabel.text = dateFormatter.string(from: data.activityDateTime!)
        cell.activityCatNameLabel.text = "\(catName![0])"
        cell.activityTypeImage.image = UIImage(named: data.activityType!)
        cell.activitiesColorTagImage.tintColor = TagsHelper.checkColor(tagsNumber: colorTag![0] as! Int16)
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "ActivityDetail", bundle: nil)
       
        let vc = storyboard.instantiateViewController(withIdentifier: "ActivityDetailStoryboard") as! ActivityDetailViewController
        
        vc.details =  activities[indexPath.row]
        
        let nc = UINavigationController(rootViewController: vc)
        nc.navigationBar.isTranslucent = false
        nc.navigationBar.barTintColor = #colorLiteral(red: 0.1036602035, green: 0.2654651999, blue: 0.3154058456, alpha: 1)
        nc.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.init(cgColor: #colorLiteral(red: 0.9914727807, green: 0.9720076919, blue: 0.9678100944, alpha: 1))]
        
        
        self.present(nc, animated: true, completion: nil)
        
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

        //self.backgroundView?.addSubview(messageLabel)
        self.backgroundView = messageLabel
        self.separatorStyle = .none
        
        var bgImage: UIImageView?
        let image: UIImage = UIImage(named: "Meng-3")!
        bgImage = UIImageView(image: image)
        bgImage!.frame = CGRect(x: 95, y: 12, width: 160, height: 100)
        //bgImage?.center = self.backgroundView!.center
        
        
        self.backgroundView?.addSubview(bgImage!)
        
        let constraints = [
            bgImage!.centerXAnchor.constraint(equalTo: superview!.centerXAnchor),
            bgImage!.centerYAnchor.constraint(equalTo: superview!.centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }

    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}
