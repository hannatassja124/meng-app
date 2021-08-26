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
    @IBOutlet weak var emptyImage: UIImageView!
    @IBOutlet weak var addActivityButton: UIButton!
    @IBOutlet weak var emptyTextLabel: UILabel!
    
    
    
    var sections = ["Upcoming Activities", "Recent Activities"]
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var upcoming = [Activity()]
    var recent = [Activity()]
    let calendar = Calendar.current
    let dateFormatter = DateFormatter()
    var data = Activity()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
        retrieveDate(activityDate: dateFormat())
        checkIfEmptyOrNot()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        retrieveDate(activityDate: dateFormat())
        checkIfEmptyOrNot()
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
          
            fr_upcoming.predicate = NSPredicate(format: "activityDateTime >= %@ && activityDateTime <= %@", activityDate as CVarArg, activityDate+(2592000) as CVarArg)
            
            print("date awal", activityDate)
            print("date akhir", activityDate+(2592000))
            
            upcoming = try context.fetch(fr_upcoming)
            
            upcoming = upcoming.sorted(by: {$0.activityDateTime?.compare($1.activityDateTime!) == .orderedAscending})
            
            
            let fr_recent: NSFetchRequest<Activity>
            fr_recent = Activity.fetchRequest()
            fr_recent.predicate = NSPredicate(format: "activityDateTime <= %@ && activityDateTime >= %@", activityDate as CVarArg, activityDate-(2592000) as CVarArg)
            
            recent = try context.fetch(fr_recent)
            
            recent = recent.sorted(by: {$0.activityDateTime?.compare($1.activityDateTime!) == .orderedDescending})
            
            print("upcoming", upcoming.count)
            print("recent", recent.count)
            
            
//            if indexPath.section == 0 {
//                data = upcoming[indexPath.row]
//            } else {
//                data = recent[indexPath.row]
//            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            print("error")
        }
    }
    
    func checkIfEmptyOrNot(){
        if self.upcoming.count == 0 && self.recent.count == 0 {
            emptyImage.isHidden = false
            emptyTextLabel.isHidden = false
            addActivityButton.isHidden = false
            tableView.isHidden = true
        } else {
            emptyImage.isHidden = true
            emptyTextLabel.isHidden = true
            addActivityButton.isHidden = true
            tableView.isHidden = false
            tableView.backgroundColor = #colorLiteral(red: 0.9945624471, green: 0.9800158143, blue: 0.9757309556, alpha: 1)
        }
    }
    
    
    @IBAction func moveToPageAddActivity(_ sender: Any) {
        print("test")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "activityLogSegue" {
            let vc = segue.destination as! UINavigationController
            let target = vc.topViewController as! ActivityLogTableViewController
            
            let year = calendar.component(.year, from: Date())
            let month = calendar.component(.month, from: Date())
            let day = calendar.component(.day, from: Date())
            let combinedDate = "\(year)-\(month)-\(day) 00:00:00 +0700"
            dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss Z"
            
            target.onViewWillDisappear = {
                self.retrieveDate(activityDate: self.dateFormatter.date(from: combinedDate)!)
                self.checkIfEmptyOrNot()
                
            }
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
        
        if indexPath.section == 0 {
            cell.object = upcoming[indexPath.row]
            cell.backgroundCell.backgroundColor = #colorLiteral(red: 0.1036602035, green: 0.2654651999, blue: 0.3154058456, alpha: 1)
        } else {
            cell.object = recent[indexPath.row]
            cell.backgroundCell.backgroundColor = #colorLiteral(red: 0.0880939886, green: 0.2219112515, blue: 0.2635231912, alpha: 0.7)
        }
        
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
