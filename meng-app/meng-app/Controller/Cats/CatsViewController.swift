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
        
        retrieveData()
        
        catsCollectionView.delegate = self
        catsCollectionView.dataSource = self
        
        initNib()
        
        print(cats.count)
    }
//
//    private func genDummyData(){
//        let cat = Cats(context: context)
//
//        cat.name = "udin"
//        cat.image = UIImage(named: "Meng-2")?.jpegData(compressionQuality: 1.0)
//
//        do {
//            try context.save()
//        } catch {
//            //error
//        }
//    }
//
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
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cats.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            return collectionView.dequeueReusableCell(withReuseIdentifier: "AddNewCatCell", for: indexPath) as! AddNewCatCollectionViewCell
        }
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CatProfileCell", for: indexPath) as! CatProfileCollectionViewCell
            
//             assign data ke CollectionView
            if let image = cats[indexPath.row - 1].image {
                cell.petImage.image = UIImage(data: image)
            }
            cell.petNameLabel.text = "\(cats[indexPath.row - 1].name!)"
            cell.petGenderIcon.image = UIImage(named: (cats[indexPath.row - 1].gender == 0 ? "Male" : "Female"))
            cell.petTagsColor.tintColor = .red
            
//            cell.petNameLabel.text = "test"
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
        if indexPath.row == 0{
            //bakal buka Add New Cat Page
            print("add new cat")
        }
        else{
            print("cat detail")
            //bakal buka Cat Profile Detail
            let CatDetailViewController = CatDetailViewController()
            self.navigationController?.pushViewController(CatDetailViewController, animated: true)
        }
    }
    
    
}
