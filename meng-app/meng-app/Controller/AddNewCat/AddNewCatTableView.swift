//
//  AddNewCatTableView.swift
//  meng-app
//
//  Created by Adinda Puji Rahmawaty on 29/07/21.
//

import UIKit

class AddNewCatTableView: UITableViewController, UIPickerViewDelegate, UITextViewDelegate {
    
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

    var colorTagsPickerData:[String] = [String]()
    var genderPickerData:[String] = [String]()
    var breedPickerData:[String] = [String]()
    var neuteredPickerData:[String] = [String]()
    var onViewWillDisappear: (()->())?
    var placeholderNotes = "Notes"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameField()
        ncCatColorTagsPicker.tag = 1
        ncCatGenderPicker.tag = 2
        ncCatBreedPicker.tag = 3
        ncCatNeuteredPicker.tag = 4
        pickerCatColorTagsFill()
        pickerCatGenderFill()
        ncCatDOBDate()
        pickerCatBreedFill()
        pickerDataNeuteredFill()
        ncCatNotesTV.text = placeholderNotes
        ncCatNotesTV.textColor = .lightGray
        ncCatNotesTV.delegate = self
        hiddenPickers(fieldName: "init", indexPath: [-1])
//        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
//                view.addGestureRecognizer(tap)
    }
    
// Button NavBar
    @IBAction func saveButton(_ sender: Any) {
    saveCatProfileData()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
// Save New Cat Data
    func saveCatProfileData(){
        let newCatProfile = Cats()
        
        newCatProfile.name =  "\(ncCatNameTF.text ?? "")"
        if ncCatGenderLabel.text == "Male" {
            newCatProfile.gender = 0
        }
        else if ncCatGenderLabel.text == "Female" {
            newCatProfile.gender = 1
        }
        newCatProfile.dateOfBirth = ncCatDOBPicker.date
        newCatProfile.breed = "\(ncCatBreedLabel.text ?? "")"
        if ncCatNeuteredLabel.text == "Yes" {
            newCatProfile.isNeutered = true
        }
        else if ncCatNeuteredLabel.text == "No"{
            newCatProfile.isNeutered = false
        }
        newCatProfile.weight = Double("\(ncCatWeightTF.text ?? "")")!
        newCatProfile.feeding = "\(ncCatFeedingTF.text ?? "")"
        newCatProfile.notes = "\(ncCatNotesTV.text ?? "")"
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
    
// Picker Color Tags
    func pickerCatColorTagsFill(){
        self.ncCatColorTagsPicker.delegate = self
        self.ncCatColorTagsPicker.dataSource = self
        
        colorTagsPickerData = ["Green", "Yellow", "Orange", "Red", "Blue", "Teal", "Indigo","Purple", "Pink", "White", "Brown", "Black"]
    }

// Picker Cat Gender
    func pickerCatGenderFill(){
        self.ncCatGenderPicker.delegate = self
        self.ncCatGenderPicker.dataSource = self
        
        genderPickerData = ["Male", "Female"]
    }
    
// Picker Data Breed
    func pickerCatBreedFill() {
        
        self.ncCatBreedPicker.delegate = self
        self.ncCatBreedPicker.dataSource = self
        
        breedPickerData = ["Abyssinian", "American Bobtail", "American Curl", "American Shorthair", "American Wirehair", "Balinese-Javanese", "Bengal", "Birman", "Bombay", "British Shorthair", "Burmese", "Chartreux", "Cornish Rex", "Devon Rex", "Egyptian Mau", "European Burmese", "Exotic Shorthair", "Havana Brown", "Himalayan", "Japanese Bobtail", "Korat", "LaPerm", "Maine Coon", "Manx", "Munchkin", "Norwegian Forest", "Ocicat", "Oriental", "Persian", "Peterbald", "Pixiebob", "Ragamuffin", "Ragdoll", "Russian Blue", "Savannah", "Scottish Fold", "Selkirk Rex", "Siamese", "Siberian", "Singapura", "Somali", "Sphynx", "Tonkinese", "Toyger", "Turkish Angora", "Turkish Van"]
    }
    
// Picker Neutered
    func pickerDataNeuteredFill() {
        self.ncCatNeuteredPicker.delegate = self
        self.ncCatNeuteredPicker.dataSource = self
        
        neuteredPickerData = ["Yes", "No"]
    }
    
// pickerView Settings
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            print(colorTagsPickerData[row])
            ncCatColorTagsLabel.text = colorTagsPickerData[row]
            
            ncCatColorTagsIcon.tintColor = TagsHelper.checkColor(tagsNumber: Int16(row+1))
        }
        else if pickerView.tag == 2 {
            print(genderPickerData[row])
            ncCatGenderLabel.text = genderPickerData[row]
        }
        else if pickerView.tag == 3 {
            print(breedPickerData[row])
            ncCatBreedLabel.text = breedPickerData[row]
        }
        else {
            print(neuteredPickerData[row])
            ncCatNeuteredLabel.text = neuteredPickerData[row]
        }
    }
    
// Notes Placeholder
    func textViewDidBeginEditing(_ textView: UITextView){
//        if ncCatNotesTV.textColor == .lightGray {
//            ncCatNotesTV.text = ""
//            ncCatNotesTV.textColor = .black
//        }
        if placeholderNotes == "Notes" {
            print("Text View Did Begin Editing")
            ncCatNotesTV.text = ""
            placeholderNotes = ""
            ncCatNotesTV.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
//        if ncCatNotesTV.text.isEmpty {
//            ncCatNotesTV.text = "Notes"
//            ncCatNotesTV.textColor = .lightGray
//            placeholderNotes = ""
//        }
//        else {
//            placeholderNotes = ncCatNotesTV.text
//        }
        if placeholderNotes != "" {
            placeholderNotes = ncCatNotesTV.text
        }
    }
    
    func textViewDidChange() {
        placeholderNotes = ncCatNotesTV.text
        
    }
    
    func textView( _ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            if text == "\n"{
                ncCatNotesTV.resignFirstResponder()
            }
            return true
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
        let cellCatPhoto = indexPath.section == 0 && indexPath.row == 0
        let cellCatColorTagsPicker = indexPath.section == 1 && indexPath.row == 1
        let cellCatGenderPicker = indexPath.section == 2 && indexPath.row == 1
        let cellCatDOBPicker = indexPath.section == 3 && indexPath.row == 1
        let cellCatBreedPicker = indexPath.section == 4 && indexPath.row == 1
        let cellCatNeuteredPicker = indexPath.section == 5 && indexPath.row == 1
        let cellCatNote =  indexPath.section == 8 && indexPath.row == 0
        
        var ncHeight: CGFloat = 43.5
        
        if (cellCatPhoto) {
            ncHeight = 200.0
        }
        if (cellCatNote) {
            ncHeight = 200.0
        }
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

extension AddNewCatTableView: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return colorTagsPickerData.count
        }
        else if pickerView.tag == 2 {
            return genderPickerData.count
        }
        else if pickerView.tag == 3 {
            return breedPickerData.count
        }
        else {
            return neuteredPickerData.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            return "\(colorTagsPickerData[row])"
        }
        else if pickerView.tag == 2 {
            return "\(genderPickerData[row])"
        }
        else if pickerView.tag == 3 {
            return "\(breedPickerData[row])"
        }
        else {
            return "\(neuteredPickerData[row])"
        }
    }

}
