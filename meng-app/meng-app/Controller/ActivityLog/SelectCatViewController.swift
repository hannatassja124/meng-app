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
    
    var onCatSelectedModal: ((_ catSelected:Cats)-> Void)?
    var cats = [Cats]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
//MARK: - NavBar
    @IBAction func BackButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        retrieveData()
        TableView.delegate = self
        TableView.dataSource = self

        // Do any additional setup after loading the view.
    }
    
    private func retrieveData(){
        do {
            cats = try context.fetch(Cats.fetchRequest())
        } catch {
            //error
            print("Error when retrieving data from CoreData")
        }
        
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
        return cats.count // Replace this with ActualDataArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let Cell = tableView.dequeueReusableCell(withIdentifier: "SelectCatCell", for: indexPath) as! selectCatCell
        
        Cell.labelCatName.text = cats[indexPath.row].name
        Cell.imageCatColor.tintColor = TagsHelper.checkColor(tagsNumber: cats[indexPath.row].colorTags)
        return Cell
    }

    
//MARK: - Pass Data
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.onCatSelectedModal!(cats[indexPath.row])
        self.dismiss(animated: true, completion: nil) //Dismiss Modal on Cell Click
    }
}
