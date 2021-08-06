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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.tableView.register(UINib.init(nibName: activitiesCellId, bundle: nil), forCellReuseIdentifier: activitiesCellId)
        tableView.separatorColor =  .clear
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        tableView.backgroundColor = .clear
        
        
        //save()
        
//        activities.removeAll()
//        cats.removeAll()
        
        retrieveData()
        
        tableView.reloadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        

    }
    
    func retrieveData() {
        do {
            activities = try context.fetch(Activity.fetchRequest())
            cats = try context.fetch(Cats.fetchRequest())
            
            print("acti", activities)
            print("cat", cats)
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
        
        let cats = Cats(context: context)
        cats.name = "Tulul"
        cats.notes = "i want to sleep ksfjkldsjflkjsfklsjflkjskldfjlskjdflksjklfjsklfjlksdjfkljsfjklsjlkfjskljflksjlkf"
        
        activity.addToCats(cats)
        
        
        do {
            try context.save()
        } catch {
            print("error")
        }
        
    }
    
    
    @IBAction func addActivityPage(_ sender: Any) {
  
        
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
    
//    func prepareForSegue(segue: UIStoryboardSegue, sender: UITableView) {
//        print("")
//    if segue.identifier == "showActivityDetail" {
//
//        let indexPath:NSIndexPath = self.tableView.indexPathForSelectedRow! as NSIndexPath
//
//        print("test", activities[0])
//        let detailVC = segue.destination as! ActivityDetailViewController
//        detailVC.details = activities[indexPath.row]
//        }
//    }
//


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
        
        let data = activities[indexPath.row]
        let time = calendar.dateComponents([.hour, .minute], from: data.value(forKey: "activityDateTime") as! Date)
        
        let cats = data.cats!.value(forKey: "name") //NSSet
        let catname = (cats as AnyObject).allObjects //Swift Array
        
        cell.activityTitleLabel.text = data.value(forKey: "activityTitle") as? String
        cell.activityTimeLabel.text = "10.00 PM"
        cell.activityCatNameLabel.text = "\(catname![0])"
        cell.activityTypeImage.image = UIImage(systemName: "stethoscope")
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "ActivityDetail", bundle: nil)
       
        let vc = storyboard.instantiateViewController(withIdentifier: "ActivityDetailStoryboard") as! ActivityDetailViewController
        let nc = UINavigationController(rootViewController: vc)
        nc.navigationBar.isTranslucent = false
        nc.navigationBar.barTintColor = #colorLiteral(red: 0.1036602035, green: 0.2654651999, blue: 0.3154058456, alpha: 1)
        
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
