//
//  CatsViewController.swift
//  meng-app
//
//  Created by Arya Ilham on 27/07/21.
//

import UIKit

class CatsViewController: UIViewController, UICollectionViewDelegate {
    //MARK: - Outlets
    @IBOutlet weak var catsCollectionView: UICollectionView!
    
    //MARK: - Variables
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var cats:[Cats] = [Cats()]
    var originalCats:[Cats] = []
    let searchController = UISearchController()

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initNib()
        initSearchController()
        print(cats.count)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.barTintColor = UIColor(named: "MidnightGreen")
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "NeutralLight") ?? UIColor.black]

        self.retrieveData()
    }
    
    //MARK: - Function
    private func initNib(){
        catsCollectionView.register(UINib(nibName: "\(AddNewCatCollectionViewCell.self)", bundle: nil), forCellWithReuseIdentifier: "AddNewCatCell")
        catsCollectionView.register(UINib(nibName: "\(CatProfileCollectionViewCell.self)", bundle: nil), forCellWithReuseIdentifier: "CatProfileCell")
    }
    
    private func initSearchController(){
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
    
    
}

//MARK: - CollectionView
extension CatsViewController: UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cats.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddNewCatCell", for: indexPath) as? AddNewCatCollectionViewCell else {
                fatalError("add new cat cell not found")
            }
            
            return cell
        }
        else{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CatProfileCell", for: indexPath) as? CatProfileCollectionViewCell else {
                fatalError("cat profile cell not found")
            }
//          assign data ke CollectionView cell
            //image
            if let image = cats[indexPath.row - 1].image {
                cell.petImage.image = UIImage(data: image)
            }
            //name
            if let name = cats[indexPath.row - 1].name {
                cell.petNameLabel.text = "\(name)"
            }
            //gender icon
            cell.petGenderIcon.image = UIImage(named: (cats[indexPath.row - 1].gender == 0 ? "Male" : "Female"))
            //tint color
            cell.petTagsColor.tintColor = TagsHelper.checkColor(tagsNumber: cats[indexPath.row-1].colorTags)
                        
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
        if indexPath.row == 0{
            let storyboard = UIStoryboard(name: "AddNewCat", bundle: nil)
            guard let vc  = storyboard.instantiateViewController(withIdentifier: "addNewCat") as? AddNewCatTableView else {
                fatalError("vc not found")
            }
            
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
            //bakal buka Cat Profile Detail
            guard let vc = storyboard?.instantiateViewController(identifier: "CatDetail") as? CatDetailViewController else {
                fatalError("vc not found")
            }
            vc.currCat = cats[indexPath.row - 1]
            navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
}

//MARK: - SearchBar
extension CatsViewController: UISearchResultsUpdating, UISearchBarDelegate{
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            return
        }
        print(text)
       
        if text != ""{
            cats = originalCats.filter{ (cats: Cats) -> Bool in
                if let filtered = cats.name?.lowercased().contains(text.lowercased()) {
                    return filtered
                }
                return false
            }
        }
        else{
            cats = originalCats
        }
        DispatchQueue.main.async {
            self.catsCollectionView.reloadData()
        }
    }
}

