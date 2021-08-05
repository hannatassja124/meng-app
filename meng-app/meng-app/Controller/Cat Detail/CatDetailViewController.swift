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
    
    func assignDatatoPage() {
        if let image = currCat?.image {
            catImage.image = UIImage(data: image)
        }
        catName.text = currCat?.name ?? "Cat"
        catGenderIcon.image = UIImage(named: (currCat!.gender == 0 ? "Male" : "Female"))
        catColorTags.tintColor = TagsHelper.checkColor(tagsNumber: currCat!.colorTags)
        let neuteredString = currCat!.isNeutered ? "neutered" : "not neutered"
        catBreedAndNeutered.text = "\(currCat!.breed) , \(neuteredString)"
        catAge.text = "2 years"
        catWeight.text = "\(currCat!.weight) KG"
        catFood.text = "\(currCat?.feeding ?? "no data")"
        catMedicalNotes.text = "\(currCat?.notes ?? "no data")"
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
