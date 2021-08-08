//
//  HistoryViewController.swift
//  meng-app
//
//  Created by Arya Ilham on 07/08/21.
//

import UIKit

struct GroupedActivities {
    var sectionTitle:String
    var activities = [Activity]()
    
    init(sectionTitle:String) {
        self.sectionTitle = sectionTitle
    }
}

class HistoryViewController: UIViewController {
    
    let activitiesCellId = "ActivitiesTableViewCell"

    
    var selectedCat = Cats()
    var groupedActivties:[GroupedActivities] = []
    @IBOutlet weak var activitiesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        checkIfActivitiesEmptyOrNot()
        initiateTableView()

    }
    
    func setupUI() {
        UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "MidnightGreen")!]
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "MidnightGreen")!]

    }
    
    func initiateTableView(){
        activitiesTableView.delegate = self
        activitiesTableView.dataSource = self
        
        self.activitiesTableView.register(UINib.init(nibName: activitiesCellId, bundle: nil), forCellReuseIdentifier: activitiesCellId)
        activitiesTableView.separatorColor = .clear
        
    }
    
    func checkIfActivitiesEmptyOrNot(){
        if(selectedCat.activities?.count == 0){
            activitiesTableView.isHidden = true
        }
        else{
            sortActivitiesByDate()
            if groupedActivties.count == 0 {
                activitiesTableView.isHidden = true
            }
        }
    }
    
    func sortActivitiesByDate(){
        //sort and filter data descending by date
        let catActivites = selectedCat.activities?.allObjects as! [Activity]
        
        var convertedCatActivities:[Activity] = []
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MMMM dd, YYYY"
        
        for data in catActivites {
            if data.activityDateTime! < Date() && data.activityDateTime! >= Calendar.current.date(byAdding: .day, value: -30, to: Date())! {
                convertedCatActivities.append(data)
            }
        }
        
        var sortedCatActivites = convertedCatActivities.sorted(by: {$0.activityDateTime?.compare($1.activityDateTime!) == .orderedDescending})
        if sortedCatActivites.count == 0 {
            return
        }
        //count sections by date
        var sectionIndex = 0;
        var lastDate = sortedCatActivites[sectionIndex].activityDateTime!
        groupedActivties.append(GroupedActivities(sectionTitle: dateformatter.string(from: lastDate)))
        for act in sortedCatActivites {
            print(dateformatter.string(from: act.activityDateTime!) == dateformatter.string(from: lastDate))
            if dateformatter.string(from: act.activityDateTime!) == dateformatter.string(from: lastDate) {
                groupedActivties[sectionIndex].activities.append(act)
                print("tanggal sama")
            }
            else{
                groupedActivties.append(GroupedActivities(sectionTitle: dateformatter.string(from: act.activityDateTime!)))
                sectionIndex += 1
                groupedActivties[sectionIndex].activities.append(act)
                lastDate = act.activityDateTime!
                print("tanggal beda")
            }
        }
    }
    
    
    @IBAction func back(_ sender: Any) {
        if let navController = self.navigationController {
            for controller in navController.viewControllers {
                if controller is CatDetailViewController { // Change to suit your menu view controller subclass
                    navController.popToViewController(controller, animated:true)
                    break
                }
            }
        }
    }
    
}

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return groupedActivties.count    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupedActivties[section].activities.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return groupedActivties[section].sectionTitle
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: activitiesCellId, for: indexPath) as! ActivitiesTableViewCell
        
        cell.activityTitleLabel.text = "\(groupedActivties[indexPath.section].activities[indexPath.row].activityTitle!)"
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "HH:MM"
        cell.activityTimeLabel.text = "\(dateformatter.string(from: groupedActivties[indexPath.section].activities[indexPath.row].activityDateTime!))"
        
        cell.activityCatNameLabel.text = "\(selectedCat.name!)"
        cell.activityTypeImage.image = UIImage(named: "\(groupedActivties[indexPath.section].activities[indexPath.row].activityType!)")
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 24))
        view.backgroundColor = UIColor(named: "NeutralLight")

        let sectionLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 24))
        sectionLabel.text = groupedActivties[section].sectionTitle
        sectionLabel.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.caption2)
        sectionLabel.textColor = UIColor(named: "MidnightGreen")
        view.addSubview(sectionLabel)
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 24
    }
}
