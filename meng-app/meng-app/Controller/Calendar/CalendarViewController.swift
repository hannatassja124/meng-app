//
//  CalendarViewController.swift
//  meng-app
//
//  Created by Hannatassja Hardjadinata on 27/07/21.
//

import UIKit
import CoreData

protocol parentDelegate: AnyObject {
    func setMark()
}

class CalendarViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var calendarUIView: UIView!
    
    // MARK: - Delegate
    
    weak var delegate: parentDelegate? = nil

    // MARK: - Variables
    
    let activitiesCellId = "ActivitiesTableViewCell"
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var activities = [Activity()]
    var cats = [Cats()]
    let calendar = Calendar.current
    let dateFormatter = DateFormatter()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        retrieveData(activityDate: CalendarHelper().formatDate())
    }
    
    override func viewDidLayoutSubviews() {
        if Core.shared.isNewUser(){
            let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
            
            guard let vc = storyboard.instantiateViewController(identifier: "getStartedStoryboard") as? GetStartedViewController else {
                fatalError("no vc")
            }
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
        if segue.identifier == "activityLogSegue" {
            
            guard let vc = segue.destination as? UINavigationController else {
                fatalError("no vc")
            }
            
            guard let target = vc.topViewController as? ActivityLogTableViewController else {
                fatalError("no target")
            }
            
            target.onViewWillDisappear = {
                objchildVc.setMark()
                self.retrieveData(activityDate: CalendarHelper().formatDate())
            }
        }
    }
    
    // MARK: - Function
    
    func initView(){
        self.tableView.register(UINib.init(nibName: activitiesCellId, bundle: nil), forCellReuseIdentifier: activitiesCellId)
        self.tableView.separatorColor = .clear
        self.tableView.backgroundColor = .clear
    }
    
    func retrieveData(activityDate : Date) {
        do {
            let fr: NSFetchRequest<Activity>
            fr = Activity.fetchRequest()
            print()
            fr.predicate = NSPredicate(format: "activityDateTime >= %@ && activityDateTime <= %@", activityDate as CVarArg, activityDate+86400 as CVarArg)
            activities = try context.fetch(fr)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            print("error")
        }
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: activitiesCellId, for: indexPath) as? ActivitiesTableViewCell else {
            fatalError("no cell")
        }
        cell.object = activities[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "ActivityDetail", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "ActivityDetailStoryboard") as? ActivityDetailViewController else {
            fatalError("no vc")
        }
        vc.details =  activities[indexPath.row]
        let nc = UINavigationController(rootViewController: vc)
        nc.setNav(root: nc)
        self.present(nc, animated: true, completion: nil)
    }
    
}
