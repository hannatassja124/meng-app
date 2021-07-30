//
//  AddNewCatTableView.swift
//  meng-app
//
//  Created by Adinda Puji Rahmawaty on 29/07/21.
//

import UIKit

class AddNewCatTableView: UITableViewController, UIPickerViewDelegate {
    
    // Image
    @IBOutlet weak var ncCatPhotoImage: UIImageView!
    @IBOutlet weak var ncCatColorTagsIcon: UIImageView!
    
    // Label
    @IBOutlet weak var ncCatColorTagsLabel: UILabel!
    @IBOutlet weak var ncCatGenderLabel: UILabel!
    @IBOutlet weak var ncCatDOBLabel: UILabel!
    @IBOutlet weak var ncCatBreedLabel: UILabel!
    @IBOutlet weak var ncCatNeuteredLabel: UILabel!
    
    // TextInput
    @IBOutlet weak var ncCatNameTF: UITextField!
    @IBOutlet weak var ncCatWeightTF: UITextField!
    @IBOutlet weak var ncCatFeedingTF: UITextField!
    @IBOutlet weak var ncCatNotesTV: UITextView!
    
    // Pickers
    @IBOutlet weak var ncCatColorTagsPicker: UIPickerView!
    @IBOutlet weak var ncCatGenderPicker: UIPickerView!
    @IBOutlet weak var ncCatDOBPicker: UIDatePicker!
    @IBOutlet weak var ncCatBreedPicker: UIPickerView!
    @IBOutlet weak var ncCatNeuteredPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameField()
        ncCatDOBDate()
        hiddenPickers(fieldName: "init", indexPath: [-1])
    }
    
    // Untuk Name Text Field
    
    func nameField() {
        
        // Placeholder di tengah
        let centeredParagraphStyle = NSMutableParagraphStyle()
        centeredParagraphStyle.alignment = .center
        let attributedPlaceholder = NSAttributedString(string: "Name", attributes: [NSAttributedString.Key.paragraphStyle:centeredParagraphStyle])
        ncCatNameTF.attributedPlaceholder = attributedPlaceholder
        
        // Input mulai dari tengah
        ncCatNameTF.textAlignment = .center
    }
    
    // Picker Data
    var pickerData:[String] = [String]()
    
    func pickerDataFill() {
        
        self.ncCatBreedPicker.delegate = self
//        self.ncCatBreedPicker.dataSource = self
//
        pickerData = ["Abyssinian", "American Bobtail", "American Curl", "American Shorthair", "American Wirehair", "Balinese-Javanese", "Bengal", "Birman", "Bombay", "British Shorthair", "Burmese", "Chartreux", "Cornish Rex", "Devon Rex", "Egyptian Mau", "European Burmese", "Exotic Shorthair", "Havana Brown", "Himalayan", "Japanese Bobtail", "Korat", "LaPerm", "Maine Coon", "Manx", "Munchkin", "Norwegian Forest", "Ocicat", "Oriental", "Persian", "Peterbald", "Pixiebob", "Ragamuffin", "Ragdoll", "Russian Blue", "Savannah", "Scottish Fold", "Selkirk Rex", "Siamese", "Siberian", "Singapura", "Somali", "Sphynx", "Tonkinese", "Toyger", "Turkish Angora", "Turkish Van"]
    }
    
    // Format Date to String untuk ditampilkan ke Date Label
    @IBAction func ncCatDOBPickerAction(_ sender: Any) {
        ncCatDOBLabel.text = dateFormat(date: ncCatDOBPicker.date, formatDate: dateFormatTemp)
    }
    
    func ncCatDOBDate () {
        ncCatDOBLabel.text = dateFormat(date: ncCatDOBPicker.date, formatDate: dateFormatTemp)
    }
    
    let dateFormatTemp =  "MMMM dd, yyyy"
    
    func dateFormat(date: Date, formatDate: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatDate
        return dateFormatter.string(from: date)
    }
    
    
    // Table View Display
    
    func hiddenPickers(fieldName: String, indexPath: IndexPath) {
        ncCatColorTagsPicker.isHidden = fieldName == "catColorTags" ? !ncCatColorTagsPicker.isHidden : true
        ncCatGenderPicker.isHidden = fieldName == "catGender" ? !ncCatGenderPicker.isHidden : true
        ncCatDOBPicker.isHidden = fieldName == "catDOB" ? !ncCatDOBPicker.isHidden : true
        ncCatBreedPicker.isHidden = fieldName == "catBreed" ? !ncCatBreedPicker.isHidden : true
        ncCatNeuteredPicker.isHidden = fieldName == "catNeutered" ? !ncCatNeuteredPicker.isHidden : true
        
        animation(oniP: indexPath)
    }
    
    func animation (oniP : IndexPath){
        UIView.animate(withDuration:0.3, animations: { () -> Void in
        self.tableView.beginUpdates()
        self.tableView.deselectRow(at: oniP, animated: true)
        self.tableView.endUpdates()
        })
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellCatColorTagsPicker = indexPath.section == 1 && indexPath.row == 1
        let cellCatGenderPicker = indexPath.section == 2 && indexPath.row == 1
        let cellCatDOBPicker = indexPath.section == 3 && indexPath.row == 1
        let cellCatBreedPicker = indexPath.section == 4 && indexPath.row == 1
        let cellCatNeuteredPicker = indexPath.section == 5 && indexPath.row == 1
        
        var ncHeight: CGFloat = 43.5
        
        if (cellCatColorTagsPicker && ncCatColorTagsPicker.isHidden) || (cellCatGenderPicker && ncCatGenderPicker.isHidden) || (cellCatDOBPicker && ncCatDOBPicker.isHidden) || (cellCatBreedPicker && ncCatBreedPicker.isHidden) || (cellCatNeuteredPicker && ncCatNeuteredPicker.isHidden) {
            ncHeight = 0.0
        }
        if (cellCatColorTagsPicker && !ncCatColorTagsPicker.isHidden) || (cellCatGenderPicker && !ncCatGenderPicker.isHidden) || (cellCatBreedPicker && !ncCatBreedPicker.isHidden) || (cellCatNeuteredPicker && !ncCatNeuteredPicker.isHidden) {
            ncHeight = 150.0
        }
        if (cellCatDOBPicker && !ncCatDOBPicker.isHidden) {
            ncHeight = 320.0
        }
        return ncHeight
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ncCatColorTagsIP = NSIndexPath (row: 0, section: 1)
        let ncCatGenderIP = NSIndexPath (row: 0, section: 2)
        let ncCatDOBIP = NSIndexPath (row: 0, section: 3)
        let ncCatBreedIP = NSIndexPath (row: 0, section: 4)
        let ncCatNeuteredIP = NSIndexPath (row: 0, section: 5)
        
        if ncCatColorTagsIP as IndexPath == indexPath {
            hiddenPickers(fieldName: "catColorTags", indexPath: indexPath)
        }
        else if ncCatGenderIP as IndexPath == indexPath {
            hiddenPickers(fieldName: "catGender", indexPath: indexPath)
        }
        else if ncCatDOBIP as IndexPath == indexPath {
            hiddenPickers(fieldName: "catDOB", indexPath: indexPath)
        }
        else if ncCatBreedIP as IndexPath == indexPath {
            hiddenPickers(fieldName: "catBreed", indexPath: indexPath)
        }
        else if ncCatNeuteredIP as IndexPath == indexPath {
            hiddenPickers(fieldName: "catNeutered", indexPath: indexPath)
        }
    }
    
}

//extension AddNewCatTableView: UIPickerViewDataSource {
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//
//    }
//
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//
//    }
//
//}
