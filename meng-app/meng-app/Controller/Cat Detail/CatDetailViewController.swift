//
//  CatDetailViewController.swift
//  meng-app
//
//  Created by Arya Ilham on 28/07/21.
//

import UIKit

class CatDetailViewController: UIViewController {
    //MARK: - Variables
    var currCat: Cats?
    
    //MARK: - Outlets
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
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        assignDatatoPage()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupUI()
    }
    
    //MARK: - Function
    private func addActivityDummy(){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        let activity = Activity(context: context)
        activity.activityTitle = "cukur rambut"
        
        var dayComponent    = DateComponents()
        dayComponent.day    = -45 // For removing one day (yesterday): -1
        let theCalendar     = Calendar.current
        let prevDate        = theCalendar.date(byAdding: dayComponent, to: Date())
        activity.activityDateTime = prevDate
        
        activity.activityDetail = "pake salep"
        activity.activityType = "Treatment"
        currCat?.addToActivities(activity)
        do {
            try context.save()
        } catch  {
            
        }
    }
    
    private func setupUI() {
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

    private func assignDatatoPage() {
        //unwrap currCat
        guard let cat = currCat else {
            return
        }
        //cat image
        if let image = cat.image {
            catImage.image = UIImage(data: image)
        }
        //cat name
        catName.text = cat.name ?? "Cat Name"
        //cat gender icon
        catGenderIcon.image = UIImage(named: (cat.gender == 0 ? "Male" : "Female"))
        //cat tint color
        catColorTags.tintColor = TagsHelper.checkColor(tagsNumber: cat.colorTags)
        //cat neutered
        let neuteredString = cat.isNeutered ? "Neutered" : "Not neutered"
        catBreedAndNeutered.text = "\(cat.breed ?? "no data"), \(neuteredString)"
        //cat DOB
        if let date = cat.dateOfBirth{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM dd, YYYY"
            catAge.text = "\(dateFormatter.string(from: date))"

        }
        //cat weight
        catWeight.text = "\(cat.weight) KG"
        //cat food
        catFood.text = "\(cat.feeding ?? "No Data")"
        //cat medical notes
        catMedicalNotes.text = "\(currCat?.notes ?? "No Data")"
        //cat vet name
        vetName.text = "\(cat.vetName ?? "No Data")"
        //cat vet phoneNo
        vetNo.text = "\(cat.vetPhoneNo ?? "No Data")"
    }

    //MARK: - Action function
    @IBAction func goToLogActivityHistory(_ sender: Any) {
        let storyboard = UIStoryboard(name: "History", bundle: nil)
        
        if let MainVC = storyboard.instantiateViewController(identifier: "HistoryNC") as? HistoryViewController {
            if let selectedCat = currCat {
                MainVC.selectedCat = selectedCat
                navigationController?.pushViewController(MainVC, animated: true)
            }
        }
    }
    
    @IBAction func goToEditPage(_ sender: Any) {
        let storyboard = UIStoryboard(name: "AddNewCat", bundle: nil)
       
        
        guard let vc = storyboard.instantiateViewController(withIdentifier: "addNewCat") as? AddNewCatTableView else {
            fatalError("no vc found")
        }
        vc.editedCat = currCat
        vc.delegate = self
        
        
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
        guard let cat = currCat, let vetNo = cat.vetPhoneNo , cat.vetPhoneNo != nil else {
            return
        }
        
        let actionsheet = UIAlertController()
        
        actionsheet.addAction(UIAlertAction(title: "Call \(vetNo)", style: .default, handler: {_ in
            if let url = URL(string: "tel://\(vetNo)"){
                UIApplication.shared.canOpenURL(url)
                UIApplication.shared.open(url, options: [:], completionHandler: nil)

            }
        }))
        
        actionsheet.addAction(UIAlertAction(title: "Message \(vetNo)", style: .default, handler: {_ in
            if let url = URL(string: "sms://\(vetNo)"){
                UIApplication.shared.canOpenURL(url)
                UIApplication.shared.open(url, options: [:], completionHandler: nil)

            }
        }))
        
        actionsheet.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        
        present(actionsheet, animated: true)
    }
    
}


extension CatDetailViewController: AddNewCatTableViewProtocol {
    func backToRoot() {
        self.navigationController?.popViewController(animated: true)
    }
}
