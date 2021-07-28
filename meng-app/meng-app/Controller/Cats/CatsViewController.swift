//
//  CatsViewController.swift
//  meng-app
//
//  Created by Arya Ilham on 27/07/21.
//

import UIKit

class CatsViewController: UIViewController, UICollectionViewDelegate {
    //outlets
    @IBOutlet weak var catsCollectionView: UICollectionView!
    
    //variables
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var cats:[Cats] = [Cats()]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        catsCollectionView.delegate = self
        catsCollectionView.dataSource = self
        
        initNib()
    }
    
    private func initNib(){
        
        let addCatNib = UINib(nibName: "\(AddNewCatCollectionViewCell.self)", bundle: nil)
        catsCollectionView.register(addCatNib, forCellWithReuseIdentifier: "AddNewCatCell")
        
        let catProfileNib = UINib(nibName: "\(CatProfileCollectionViewCell.self)", bundle: nil)
        catsCollectionView.register(catProfileNib, forCellWithReuseIdentifier: "CatProfileCell")

    }

    private func retrieveData(){
        do {
            cats = try context.fetch(Cats.fetchRequest())
            DispatchQueue.main.async {
                self.catsCollectionView.reloadData()
            }
        } catch {
            //error
            print("Error when retrieving data from CoreData")
        }
    }
}

extension CatsViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == 0 {
            return collectionView.dequeueReusableCell(withReuseIdentifier: "AddNewCatCell", for: indexPath) as! AddNewCatCollectionViewCell
        }
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CatProfileCell", for: indexPath) as! CatProfileCollectionViewCell
            
            /* assign data ke CollectionView
            if let image = cats[indexPath.row].image {
                cell.petImage.image = UIImage(data: image)
            }
            cell.petNameLabel.text = "\(cats[indexPath.row].name!)"
            cell.petGenderIcon.image =
            cell.petTagsColor.tintColor = .red

            */
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if indexPath.row == 0{
            //bakal buka Add New Cat Page
        }
        else{
            //bakal buka Cat Profile Detail
        }
    }
    
    
}
