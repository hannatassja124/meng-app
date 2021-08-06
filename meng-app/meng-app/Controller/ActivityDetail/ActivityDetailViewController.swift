//
//  ActivityDetailViewController.swift
//  meng-app
//
//  Created by Hannatassja Hardjadinata on 02/08/21.
//

import UIKit

class ActivityDetailViewController: UIViewController {
    
    var details = Activity()

    @IBOutlet weak var detailTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.detailTableView.delegate = self
        self.detailTableView.dataSource = self
        
        print("test2", details)

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backToPrevious(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

}

class detailTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
}


extension ActivityDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        } else if section == 1{
            return 1
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = detailTableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath) as! detailTableViewCell
        
        if indexPath.section == 0 && indexPath.row == 0 {
            
            cell.titleLabel.text = "Date"
            cell.detailLabel.text = "June 20, 2027"
            
        } else if indexPath.section == 0 && indexPath.row == 1 {
            
            cell.titleLabel.text = "Time"
            cell.detailLabel.text = "10.00 PM"
            
        } else if indexPath.section == 1 && indexPath.row == 0 {
            cell.titleLabel.text = "Reminder"
            cell.detailLabel.text = "1 Hour Before"
        }
        
        
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
}
