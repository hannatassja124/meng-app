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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        print("jumlah", activities.count)
        // Do any additional setup after loading the view.
        
        self.tableView.register(UINib.init(nibName: activitiesCellId, bundle: nil), forCellReuseIdentifier: activitiesCellId)
        tableView.separatorColor =  .clear
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        tableView.backgroundColor = .clear
        
        //deleteAllData("Activity")
        
        print("jumlah2", activities.count)
        
        
        retrieveData()
        
        print("jumlah3", activities.count)
        
        tableView.reloadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("test", activities)
        print(activities.isEmpty)

    }
    
    func retrieveData() {
        do {
            activities = try context.fetch(Activity.fetchRequest())
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
        
        do {
            try context.save()
        } catch {
            print("error")
        }
        
    }
    
    
    @IBAction func addActivityPage(_ sender: Any) {
  
        
    }
    
    func deleteAllData(_ entity:String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(fetchRequest)
            for object in results {
                guard let objectData = object as? NSManagedObject else {continue}
                context.delete(objectData)
            }
        } catch let error {
            print("Detele all data in \(entity) error :", error)
        }
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
    
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
    if segue.identifier == "showActivityDetail" {
        let indexPath:NSIndexPath = self.tableView.indexPathForSelectedRow! as NSIndexPath
        let detailVC:ActivityDetailViewController = segue.destination as! ActivityDetailViewController
//        detailVC.item = items[indexPath.row] as Item
        }
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
        
        //let data = activities[indexPath.row]
        
//        cell.activityTitleLabel.text = data.value(forKey: "activityTitle") as? String
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showActivityDetail", sender: tableView)
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
