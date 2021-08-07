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
    @IBOutlet weak var vetName: UILabel!
    @IBOutlet weak var vetNo: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assignDatatoPage()
//        addActivityDummy()

        // Do any additional setup after loading the view.
    }
    
    func addActivityDummy(){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        let activity = Activity(context: context)
        activity.activityTitle = "Test"
        activity.activityDateTime = Date()
        activity.activityDetail = "Help"
        activity.activityType = "1"
        currCat?.addToActivities(activity)
        do {
            try context.save()
        } catch  {
            
        }
    }
    
    func setupUI() {
        //navigationBar
        self.navigationController?.navigationBar.prefersLargeTitles = true
        //tabBar
        self.tabBarController?.tabBar.isHidden = true
        self.tabBarController?.tabBar.isTranslucent = true
        
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
    
    
    func assignDatatoPage() {
        if let image = currCat?.image {
            catImage.image = UIImage(data: image)
        }
        catName.text = currCat?.name ?? "Cat Name"
        catGenderIcon.image = UIImage(named: (currCat!.gender == 0 ? "Male" : "Female"))
        catColorTags.tintColor = TagsHelper.checkColor(tagsNumber: currCat!.colorTags)
        let neuteredString = currCat!.isNeutered ? "Neutered" : "Not neutered"
        catBreedAndNeutered.text = "\(currCat!.breed ?? "no data"), \(neuteredString)"
        if let date = currCat?.dateOfBirth{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM dd, YYYY"
            catAge.text = "\(dateFormatter.string(from: date))"

        }
        catWeight.text = "\(currCat!.weight) KG"
        catFood.text = "\(currCat?.feeding ?? "No Data")"
        catMedicalNotes.text = "\(currCat?.notes ?? "No Data")"
        vetName.text = "\(currCat?.vetName ?? "No Data")"
        vetNo.text = "\(currCat?.vetPhoneNo ?? "No Data")"
    }

    @IBAction func goToLogActivityHistory(_ sender: Any) {
        let storyboard = UIStoryboard(name: "History", bundle: nil)
        
        let MainVC = storyboard.instantiateViewController(identifier: "HistoryNC") as! UINavigationController
        let target = MainVC.topViewController as! HistoryViewController
        target.selectedCat = currCat!
        navigationController?.pushViewController(target, animated: true)
    }
    
    @IBAction func goToEditPage(_ sender: Any) {
        let storyboard = UIStoryboard(name: "AddNewCat", bundle: nil)
       
        let vc = storyboard.instantiateViewController(withIdentifier: "addNewCat") as! AddNewCatTableView
        vc.editedCat = currCat
        
        vc.onViewWillDisappear = {
            self.assignDatatoPage()
        }
        
        let nc = UINavigationController(rootViewController: vc)
        nc.navigationBar.isTranslucent = false
        nc.navigationBar.barTintColor = #colorLiteral(red: 0.1036602035, green: 0.2654651999, blue: 0.3154058456, alpha: 1)
        nc.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.present(nc, animated: true, completion: nil)
    }
    
    
    @IBAction func back(_ sender: Any) {
        self.tabBarController?.tabBar.isHidden = false
        self.tabBarController?.tabBar.isTranslucent = false
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func contactVet(_ sender: Any) {
        guard ((currCat?.vetPhoneNo) != nil) else {
            return
        }
        
        let vetNo = currCat?.vetPhoneNo!
        
        let actionsheet = UIAlertController()
        
        actionsheet.addAction(UIAlertAction(title: "Call \(vetNo!)", style: .default, handler: {_ in
            if let url = URL(string: "tel://\(vetNo!)"){
                UIApplication.shared.canOpenURL(url)
                UIApplication.shared.open(url, options: [:], completionHandler: nil)

            }
        }))
        
        actionsheet.addAction(UIAlertAction(title: "Message \(vetNo!)", style: .default, handler: {_ in
            if let url = URL(string: "sms://\(vetNo!)"){
                UIApplication.shared.canOpenURL(url)
                UIApplication.shared.open(url, options: [:], completionHandler: nil)

            }
        }))
        
        actionsheet.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        
        present(actionsheet, animated: true)
    }
    
}


