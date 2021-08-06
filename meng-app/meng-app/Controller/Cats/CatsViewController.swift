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
    var originalCats:[Cats] = []
    let searchController = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //retrieveData()
        
        catsCollectionView.delegate = self
        catsCollectionView.dataSource = self
        
        initNib()
        initSearchController()
        print(cats.count)
    }

//    private func genDummyData(){
//        let cat = Cats(context: context)
//
//        cat.name = "Jeff"
//        cat.image = UIImage(named: "Meng-2")?.jpegData(compressionQuality: 1.0)
//        cat.colorTags = 1
//        cat.gender = 0
//        cat.vetName = "drh. Rafi Zhafransyah"
//        cat.vetPhoneNo = "087875087058"
//        cat.feeding = "Nasi Goreng"
//        cat.notes = "drank coffee a lot"
//        cat.breed = "Husky"
//        cat.isNeutered = true
//        cat.weight = 3.5
//        cat.dateOfBirth = Date()
//        do {
//            try context.save()
//        } catch {
//            //error
//        }
//    }

    private func initNib(){
        
        let addCatNib = UINib(nibName: "\(AddNewCatCollectionViewCell.self)", bundle: nil)
        catsCollectionView.register(addCatNib, forCellWithReuseIdentifier: "AddNewCatCell")
        
        let catProfileNib = UINib(nibName: "\(CatProfileCollectionViewCell.self)", bundle: nil)
        catsCollectionView.register(catProfileNib, forCellWithReuseIdentifier: "CatProfileCell")

    }
    
    func initSearchController(){
        searchController.loadViewIfNeeded()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.enablesReturnKeyAutomatically = false
        searchController.searchBar.returnKeyType = UIReturnKeyType.done
        definesPresentationContext = true
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.delegate = self
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
        originalCats = cats
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.retrieveData()
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
            
//          assign data ke CollectionView cell
            if let image = cats[indexPath.row - 1].image {
                cell.petImage.image = UIImage(data: image)
            }
            cell.petNameLabel.text = "\(cats[indexPath.row - 1].name!)"
            cell.petGenderIcon.image = UIImage(named: (cats[indexPath.row - 1].gender == 0 ? "Male" : "Female"))
            cell.petTagsColor.tintColor = TagsHelper.checkColor(tagsNumber: cats[indexPath.row-1].colorTags)
                        
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
        if indexPath.row == 0{
            //bakal buka Add New Cat Page
//            print("add new cat")
//            let vc = storyboard!.instantiateViewController(identifier: "addNewCat") as! AddNewCatTableView
//            present(vc, animated: true)
            
            let storyboard = UIStoryboard(name: "AddNewCat", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "addNewCat") as! AddNewCatTableView
            
            vc.onViewWillDisappear = {
                self.retrieveData()
            }
            
            let nc = UINavigationController(rootViewController: vc)
            nc.navigationBar.isTranslucent = false
            nc.navigationBar.barTintColor = #colorLiteral(red: 0.1036602035, green: 0.2654651999, blue: 0.3154058456, alpha: 1)
            nc.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            self.present(nc, animated: true, completion: nil)
        }
        else{
            print("cat detail")
            //bakal buka Cat Profile Detail
            let vc = storyboard!.instantiateViewController(identifier: "CatDetail") as! CatDetailViewController
            
            
            vc.currCat = cats[indexPath.row - 1]
            navigationController?.pushViewController(vc, animated: true)
            
            self.retrieveData()
        }
    }
    
    
}

extension CatsViewController: UISearchResultsUpdating, UISearchBarDelegate{
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            return
        }
        print(text)
       
        if text != ""{
            cats = originalCats.filter{ (cats: Cats) -> Bool in
                return (cats.name?.lowercased().contains(text.lowercased()))!
            }
        }
        else{
            cats = originalCats
        }
        catsCollectionView.reloadData()
    }
}

