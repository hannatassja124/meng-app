//
//  HistoryViewController.swift
//  meng-app
//
//  Created by Arya Ilham on 07/08/21.
//

import UIKit

class HistoryViewController: UIViewController {
    //MARK: - Constant id
    let activitiesCellId = "ActivitiesTableViewCell"

    //MARK: - Variables
    var selectedCat = Cats()
    var groupedActivties:[GroupedActivities] = []
    
    //MARK: - Outlets
    @IBOutlet weak var activitiesTableView: UITableView!
    
    //MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        for view in self.navigationController?.navigationBar.subviews ?? [] {
            let subview = view.subviews
            if subview.count > 0, let label = subview[0] as? UILabel {
                label.textColor = UIColor(named: "MidnightGreen") ?? UIColor.black
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfActivitiesEmptyOrNot()
        initiateTableView()

    }
    
    //MARK: - Function
    private func setupUI() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "MidnightGreen") ?? UIColor.black]
    }
    
    private func initiateTableView(){
        self.activitiesTableView.register(UINib.init(nibName: activitiesCellId, bundle: nil), forCellReuseIdentifier: activitiesCellId)
        activitiesTableView.separatorColor = .clear
    }
    
    private func checkIfActivitiesEmptyOrNot(){
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
    
    private func sortActivitiesByDate(){
        //sort and filter data descending by date
        guard let catActivites = selectedCat.activities?.allObjects as? [Activity] else {
            return
        }
        
        var convertedCatActivities:[Activity] = []
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MMMM dd, YYYY"
        
        for data in catActivites {
            guard let activityDate = data.activityDateTime else { return }
            if activityDate < Date() && activityDate >= Calendar.current.date(byAdding: .day, value: -30, to: Date())! {
                convertedCatActivities.append(data)
            }
        }
        
        let sortedCatActivites = convertedCatActivities.sorted(by: {$0.activityDateTime?.compare($1.activityDateTime ?? Date()) == .orderedDescending})
        if sortedCatActivites.count == 0 {
            return
        }
        //count sections by date
        var sectionIndex = 0;
        var lastDate = sortedCatActivites[sectionIndex].activityDateTime!
        groupedActivties.append(GroupedActivities(sectionTitle: dateformatter.string(from: lastDate)))
        for act in sortedCatActivites {
            guard let currActivityDate = act.activityDateTime else {
                continue
            }
            if dateformatter.string(from: currActivityDate) == dateformatter.string(from: lastDate) {
                groupedActivties[sectionIndex].activities.append(act)
                print("tanggal sama")
            }
            else{
                groupedActivties.append(GroupedActivities(sectionTitle: dateformatter.string(from: currActivityDate)))
                sectionIndex += 1
                groupedActivties[sectionIndex].activities.append(act)
                lastDate = currActivityDate
                print("tanggal beda")
            }
        }
    }
    
    //MARK: - Action Function
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

//MARK: - TableView
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
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: activitiesCellId, for: indexPath) as? ActivitiesTableViewCell else {
            fatalError("ActivitiesTableViewCell not found")
        }
        cell.object = groupedActivties[indexPath.section].activities[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "ActivityDetail", bundle: nil)
       
        guard let vc = storyboard.instantiateViewController(withIdentifier: "ActivityDetailStoryboard") as? ActivityDetailViewController else {
            fatalError("ActivityDetailViewController not found")
        }
        
        vc.details = groupedActivties[indexPath.section].activities[indexPath.row]
        
        let nc = UINavigationController(rootViewController: vc)
        nc.setNav(root: nc)
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
