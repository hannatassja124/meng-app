//
//  CatsViewController.swift
//  meng-app
//
//  Created by Arya Ilham on 27/07/21.
//

import UIKit

class CatsViewController: UIViewController, UICollectionViewDelegate {
    @IBOutlet weak var catsCollectionView: UICollectionView!
    
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
//            cell.petImage.image = UIImage(named: "Meng-3")
            cell.petTagsColor.tintColor = .red
            return cell
        }
    }
    
    
}
