//
//  SelectCatViewController.swift
//  meng-app
//
//  Created by William Giovanni Kambuno on 28/07/21.
//

import UIKit

class selectCatCell: UITableViewCell {

    @IBOutlet weak var labelCatName: UILabel!
    @IBOutlet weak var imageCatColor: UIImageView!
}

class SelectCatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

//MARK: - Outlets
    @IBOutlet weak var NavBarButtonBack: UIBarButtonItem!
    @IBOutlet weak var TableView: UITableView!
    
    var selectedCat = [CatData]()
    var onCatSelectedModal: ((_ index:Int)-> Void)?

    
//MARK: - NavBar
    @IBAction func BackButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
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
        return selectedCat.count // Replace this with ActualDataArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let Cell = tableView.dequeueReusableCell(withIdentifier: "SelectCatCell", for: indexPath) as! selectCatCell
        
        Cell.labelCatName.text = selectedCat[indexPath.row].cat.name
        Cell.imageCatColor.tintColor = TagsHelper.checkColor(tagsNumber: selectedCat[indexPath.row].cat.colorTags)
        return Cell
    }

    
//MARK: - Pass Data
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.onCatSelectedModal!(indexPath.row)
        self.dismiss(animated: true, completion: nil) //Dismiss Modal on Cell Click
    }
}
