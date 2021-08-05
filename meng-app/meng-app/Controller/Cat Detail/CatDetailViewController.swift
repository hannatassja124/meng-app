//
//  CatDetailViewController.swift
//  meng-app
//
//  Created by Arya Ilham on 28/07/21.
//

import UIKit

class CatDetailViewController: UIViewController {
    //selected cat model
    var currCat: Cats?
    
    //IBOutlet
    @IBOutlet weak var catImage: UIImageView!
    @IBOutlet weak var catName: UILabel!
    @IBOutlet weak var catGenderIcon: UIImageView!
    @IBOutlet weak var catColorTags: UIImageView!
    @IBOutlet weak var catBreedAndNeutered: UILabel!
    @IBOutlet weak var catAge: UILabel!
    @IBOutlet weak var catWeight: UILabel!
    @IBOutlet weak var catFood: UILabel!
    @IBOutlet weak var catMedicalNotes: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assignDatatoPage()
        
        // Do any additional setup after loading the view.
    }
    
    func setupUI() {
        //navigationBar
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        //tabBar
        self.tabBarController?.tabBar.isHidden = true
        
        //ImageGradient
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = catImage.frame
        gradient.colors = [UIColor.white.cgColor, UIColor.clear.cgColor]
        gradient.locations = [0.01, 0.4]
        catImage.layer.insertSublayer(gradient, at: 0)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func assignDatatoPage() {
        if let image = currCat?.image {
            catImage.image = UIImage(data: image)
        }
        catName.text = currCat?.name ?? "Cat Name"
        catGenderIcon.image = UIImage(named: (currCat!.gender == 0 ? "Male" : "Female"))
        catColorTags.tintColor = TagsHelper.checkColor(tagsNumber: currCat!.colorTags)
        let neuteredString = currCat!.isNeutered ? "neutered" : "not neutered"
        catBreedAndNeutered.text = "\(currCat!.breed ?? "no data") , \(neuteredString)"
        if let date = currCat?.dateOfBirth{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "DD/MM/YYYY"
            catAge.text = "\(dateFormatter.string(from: date))"

        }
        catWeight.text = "\(currCat!.weight) KG"
        catFood.text = "\(currCat?.feeding ?? "No Data")"
        catMedicalNotes.text = "\(currCat?.notes ?? "No Data")"
    }

    @IBAction func goToLogActivityHistory(_ sender: Any) {
        print("go to log activity history")
    }
    
    @IBAction func goToVetContact(_ sender: Any) {
        print("go to vet contact")
    }
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}
