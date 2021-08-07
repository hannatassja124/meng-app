//
//  HistoryViewController.swift
//  meng-app
//
//  Created by Arya Ilham on 07/08/21.
//

import UIKit

class HistoryViewController: UIViewController {
    
    let activitiesCellId = "ActivitiesTableViewCell"

    
    var selectedCat = Cats()
    var sortedCatActivites = [Activity()]
    @IBOutlet weak var activitiesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfActivitiesEmptyOrNot()
        
        initiateTableView()

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
        }
    }
    
    func sortActivitiesByDate(){
        let catActivites = selectedCat.activities?.allObjects as! [Activity]
        print(catActivites)
        sortedCatActivites = catActivites
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedCatActivites.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: activitiesCellId, for: indexPath) as! ActivitiesTableViewCell
        
        let act = sortedCatActivites[indexPath.row]
        cell.activityTitleLabel.text = "\(act.activityTitle!)"
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MMMM dd, YYYY"
        cell.activityTimeLabel.text = "\(dateformatter.string(from: act.activityDateTime!))"
        
        cell.activityCatNameLabel.text = "\(selectedCat.name!)"
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
