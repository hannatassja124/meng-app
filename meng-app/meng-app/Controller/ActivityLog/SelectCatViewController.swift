//
//  SelectCatViewController.swift
//  meng-app
//
//  Created by William Giovanni Kambuno on 28/07/21.
//

import UIKit

class SelectCatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

//MARK: - Outlets
    @IBOutlet weak var NavBarButtonBack: UIBarButtonItem!
    @IBOutlet weak var TableView: UITableView!
    
//MARK: - NavBar
    @IBAction func BackButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
//MARK: - CoreData Call
    let DummyArray = ["Dummy1", "Dummy2", "Dummy3", "Dummy4", "Dummy5"]
    //let CatsArray = // This is where the registered Cat Data gets called
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TableView.delegate = self
        TableView.dataSource = self

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
// MARK: - DataSource & Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DummyArray.count // Replace this with ActualDataArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let Cell = tableView.dequeueReusableCell(withIdentifier: "SelectCatCell", for: indexPath)
        Cell.textLabel!.text = DummyArray[indexPath.row]
        return Cell
    }
    
}
