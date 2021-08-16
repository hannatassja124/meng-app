//
//  DashboardViewController.swift
//  meng-app
//
//  Created by Hannatassja Hardjadinata on 22/07/21.
//

import UIKit
import CoreData

class DashboardViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    
    var sections = ["Upcoming Activities", "Recent Activities"]
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var upcoming = [Activity()]
    var recent = [Activity()]
    let calendar = Calendar.current
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
        retrieveDate(activityDate: dateFormat())
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        retrieveDate(activityDate: dateFormat())
    }
    
    func initView() {
        self.tableView.register(UINib.init(nibName: "ActivitiesTableViewCell", bundle: nil), forCellReuseIdentifier: "ActivitiesTableViewCell")
        tableView.separatorColor =  .clear
        tableView.backgroundColor = .clear
        
        //self.tableView.reloadData()
    }
    
    func dateFormat() -> Date {
        let year = calendar.component(.year, from: Date())
        let month = calendar.component(.month, from: Date())
        let day = calendar.component(.day, from: Date())
        
        let combinedDate = "\(year)-\(month)-\(day) 00:00:00 +0700"
        
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss Z"
        
        return dateFormatter.date(from: combinedDate)!
    }
    
    func retrieveDate(activityDate : Date) {
        do {
            print("retrieve data")
            
            let fr_upcoming: NSFetchRequest<Activity>
            fr_upcoming = Activity.fetchRequest()
          
            fr_upcoming.predicate = NSPredicate(format: "activityDateTime >= %@ && activityDateTime <= %@", activityDate as CVarArg, activityDate+604800 as CVarArg)
            
            upcoming = try context.fetch(fr_upcoming)
            
            upcoming = upcoming.sorted(by: {$0.activityDateTime?.compare($1.activityDateTime!) == .orderedAscending})
            
            
            let fr_recent: NSFetchRequest<Activity>
            fr_recent = Activity.fetchRequest()
            fr_recent.predicate = NSPredicate(format: "activityDateTime <= %@ && activityDateTime >= %@", activityDate as CVarArg, activityDate-604800 as CVarArg)
            
            recent = try context.fetch(fr_recent)
            
            recent = recent.sorted(by: {$0.activityDateTime?.compare($1.activityDateTime!) == .orderedDescending})
            
            print("upcoming", upcoming.count)
            print("recent", recent.count)
            
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            print("error")
        }
    }
    

}

extension DashboardViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.upcoming.count
        } else if section == 1 {
            return self.recent.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActivitiesTableViewCell", for: indexPath) as! ActivitiesTableViewCell
        
        let data:Activity
        
        if indexPath.section == 0 {
            data = upcoming[indexPath.row]
        } else {
            data = recent[indexPath.row]
        }

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
        
        if indexPath.section == 0 {
            vc.details =  upcoming[indexPath.row]
        } else {
            vc.details = recent[indexPath.row]
        }
        let nc = UINavigationController(rootViewController: vc)
        nc.navigationBar.isTranslucent = false
        nc.navigationBar.barTintColor = #colorLiteral(red: 0.1036602035, green: 0.2654651999, blue: 0.3154058456, alpha: 1)
        nc.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.init(cgColor: #colorLiteral(red: 0.9914727807, green: 0.9720076919, blue: 0.9678100944, alpha: 1))]
        self.present(nc, animated: true, completion: nil)
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    
}
