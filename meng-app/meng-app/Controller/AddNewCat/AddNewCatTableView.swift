//
//  AddNewCatTableView.swift
//  meng-app
//
//  Created by Adinda Puji Rahmawaty on 29/07/21.
//

import UIKit

protocol AddNewCatTableViewProtocol: AnyObject {
    func backToRoot()
}

class AddNewCatTableView: UITableViewController, UIPickerViewDelegate, UITextViewDelegate {
    
    // MARK: - IBOutlets
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
    @IBOutlet weak var ncCatVetsName: UITextField!
    @IBOutlet weak var ncCatVetsPhoneNumber: UITextField!
    @IBOutlet weak var ncCatNotesTV: UITextView!
    
// Pickers
    @IBOutlet weak var ncCatColorTagsPicker: UIPickerView!
    @IBOutlet weak var ncCatGenderPicker: UIPickerView!
    @IBOutlet weak var ncCatDOBPicker: UIDatePicker!
    @IBOutlet weak var ncCatBreedPicker: UIPickerView!
    @IBOutlet weak var ncCatNeuteredPicker: UIPickerView!
    
// TableView
    @IBOutlet var catProfileDataTableView: UITableView!
    @IBOutlet weak var catProfileDataDeleteTableView: UITableViewCell!
    
    //MARK: - Variables
    
    var colorTagsPickerData:[String] = [String]()
    var genderPickerData:[String] = [String]()
    var breedPickerData:[String] = [String]()
    var neuteredPickerData:[String] = [String]()
    var onViewWillDisappear: (()->())?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var editedCat:Cats? = nil
    weak var delegate: AddNewCatTableViewProtocol?
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ncCatNotesTV.text = "Medical Notes"
        ncCatNotesTV.textColor = .lightGray
        checkIfEditOrNot()
        
        nameField()
//        ncCatWeightTF.keyboardType = .decimalPad
        ncCatColorTagsPicker.tag = 1
        ncCatGenderPicker.tag = 2
        ncCatBreedPicker.tag = 3
        ncCatNeuteredPicker.tag = 4
        pickerCatColorTagsFill()
        pickerCatGenderFill()
        ncCatDOBDate()
        pickerCatBreedFill()
        pickerDataNeuteredFill()
        ncCatNameTF.delegate = self
        ncCatWeightTF.delegate = self
        ncCatFeedingTF.delegate = self
        ncCatVetsName.delegate = self
        ncCatVetsPhoneNumber.delegate = self
        ncCatNotesTV.delegate = self
        hiddenPickers(fieldName: "init", indexPath: [-1])
        if editedCat == nil {
            catProfileDataDeleteTableView.isHidden = true
        }
        else {
            catProfileDataDeleteTableView.isHidden = false
        }
    }
    
    //MARK: - IBActions
// Buttons
    @IBAction func saveButton(_ sender: Any) {
        if ncCatPhotoImage.image == nil {
            let alertNCImage = UIAlertController(title: "You have not insert your cat's image", message: "You must insert your cat's image before saving", preferredStyle: .alert)

            alertNCImage.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
//            alertNCImage.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = UIColor.white
//
//            alertNCImage.view.tintColor = UIColor.black

            self.present(alertNCImage, animated: true)
        
        }
        else if ncCatNameTF.text == "" {
            let alertNCName = UIAlertController(title: "You have not insert your cat's name", message: "You must insert your cat's name before saving", preferredStyle: .alert)

            alertNCName.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
//            alertNCName.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = UIColor.white
//
//            alertNCName.view.tintColor = UIColor.black

            self.present(alertNCName, animated: true)
        }
        else if ncCatPhotoImage.image != nil && ncCatNameTF.text != nil {
            saveCatProfileData()
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func catPhotoButton(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        let actionsheet = UIAlertController(title: "Browse Attachment", message: "Choose A Source", preferredStyle: .alert)
        actionsheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction)in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true, completion: nil)
            } else {
                print("Camera is Not Available")
            }
        }))
        actionsheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action:UIAlertAction)in
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.mediaTypes = ["public.image"]
            self.present(imagePicker, animated: true, completion: nil)
        }))
        actionsheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(actionsheet, animated: true, completion: nil)
    }
    
    @IBAction func deleteProfileButton(_ sender: Any) {
        let alert = UIAlertController(title: "Delete Cat Profile", message: "Are you sure you want to permanently delete this profile?", preferredStyle: .actionSheet)
                 
        let DeleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: deleteConfirm)
        let CancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler:deleteCancel)

        alert.addAction(DeleteAction)
        alert.addAction(CancelAction)

        self.present(alert, animated: true, completion: nil)
        
    }
    //MARK: - Functions
    
// Delete Cat Data
    func deleteConfirm(alertAction: UIAlertAction!) {
        context.delete(editedCat!)
        do {
            try context.save()
            DispatchQueue.main.async {
                self.delegate?.backToRoot()
                self.dismiss(animated: true, completion: nil)
            }
        }
        catch{
            print("Ga kedelete")
        }
    }
    
    func deleteCancel(alertAction: UIAlertAction!){
        editedCat = nil
    }
    
// Save New Cat Data
    func saveCatProfileData(){
        if editedCat == nil {
            let newCatProfile = Cats(context: context)
            
                newCatProfile.image = ncCatPhotoImage.image?.jpegData(compressionQuality: 1.0) ?? nil
                newCatProfile.name =  "\(ncCatNameTF.text ?? "")"
            newCatProfile.colorTags = Int16(TagsHelper.convertColorToNumber(color: ncCatColorTagsLabel.text!))
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
            if let weight = Double(ncCatWeightTF.text!){
                newCatProfile.weight = weight
            }
            newCatProfile.feeding = "\(ncCatFeedingTF.text ?? "")"
            newCatProfile.vetName = "\(ncCatVetsName.text ?? "")"
            newCatProfile.vetPhoneNo = "\(ncCatVetsPhoneNumber.text ?? "")"
            newCatProfile.notes = "\(ncCatNotesTV.text ?? "")"
            print(ncCatNotesTV.text!)
            }
        
        // edited data
        else if editedCat != nil {
            editedCat!.image = ncCatPhotoImage.image?.jpegData(compressionQuality: 1.0) ?? nil
            editedCat!.name = "\(ncCatNameTF.text ?? "")"
            editedCat!.colorTags = Int16(TagsHelper.convertColorToNumber(color: ncCatColorTagsLabel.text!))
                if ncCatGenderLabel.text == "Male" {
                    editedCat!.gender = 0
                }
                else if ncCatGenderLabel.text == "Female"  {
                    editedCat!.gender = 1
                }
            editedCat!.dateOfBirth = ncCatDOBPicker.date
            editedCat!.breed = "\(ncCatBreedLabel.text ?? "")"
                if ncCatNeuteredLabel.text == "Yes" {
                    editedCat!.isNeutered = true
                }
                else if ncCatNeuteredLabel.text == "No" {
                    editedCat!.isNeutered = false
                }
            if let weightEdit = Double(ncCatWeightTF.text!){
                editedCat!.weight = weightEdit
            }
            editedCat!.feeding = "\(ncCatFeedingTF.text ?? "")"
            editedCat!.vetName = "\(ncCatVetsName.text ?? "")"
            editedCat!.vetPhoneNo = "\(ncCatVetsPhoneNumber.text ?? "")"
            editedCat!.notes = "\(ncCatNotesTV.text ?? "")"
            print(ncCatNotesTV.text!)
        }
        do {
            try context.save()
        } catch {
            print("Ga kesave")
        }
        
        onViewWillDisappear!()
    }
    
// Set data pas mau edit
    func checkIfEditOrNot() {
        
        if editedCat != nil {
            let colorEdit = ["Green", "Yellow", "Orange", "Red", "Blue", "Teal", "Indigo","Purple", "Pink", "White", "Brown", "Black"]
            
            if let image = editedCat?.image{
                ncCatPhotoImage?.image = UIImage(data: image)
            }
            ncCatNameTF.text = editedCat?.name
            ncCatColorTagsLabel.text = colorEdit[Int(editedCat!.colorTags)-1]
            ncCatColorTagsIcon.tintColor = TagsHelper.checkColor(tagsNumber: editedCat!.colorTags)
                if editedCat?.gender == 0 {
                    ncCatGenderLabel.text = "Male"
                }
                else if editedCat?.gender == 1  {
                    ncCatGenderLabel.text = "Female"
                }
            ncCatDOBPicker.date = (editedCat?.dateOfBirth)!
            ncCatDOBLabel.text = dateFormat(date: ncCatDOBPicker.date, formatDate: dateFormatTemp)
            ncCatBreedLabel.text = editedCat?.breed
                if editedCat!.isNeutered == true {
                    ncCatNeuteredLabel.text = "Yes"
                }
                else if editedCat!.isNeutered == false {
                    ncCatNeuteredLabel.text = "No"
                }
            ncCatWeightTF.text = "\(editedCat?.weight ?? 0)"
            ncCatFeedingTF.text = editedCat?.feeding
            ncCatVetsName.text = editedCat?.vetName
            ncCatVetsPhoneNumber.text = editedCat?.vetPhoneNo
            ncCatNotesTV.text = editedCat?.notes
            if ncCatNotesTV.text == "Medical Notes" {
                ncCatNotesTV.textColor = .lightGray
            }
            else {
                ncCatNotesTV.textColor = .black
            }
            print(ncCatNotesTV.text!)
        }
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
        if ncCatNotesTV.text == "Medical Notes" {
            print("Text View Did Begin Editing")
            ncCatNotesTV.text = ""
            ncCatNotesTV.textColor = .black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if ncCatNotesTV.text == "" {
            ncCatNotesTV.text = "Medical Notes"
            ncCatNotesTV.textColor = .lightGray
        }
    }

    func textViewDidChange() {
    }

    func textView( _ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            if text == "\n"{
                ncCatNotesTV.resignFirstResponder()
            }
            return true
        }
   
    //MARK: Data in Pickers
// Format Date to String untuk ditampilkan ke Date Label
    @IBAction func ncCatDOBPickerAction(_ sender: Any) {
        ncCatDOBLabel.text = dateFormat(date: ncCatDOBPicker.date, formatDate: dateFormatTemp)
    }
    
    func ncCatDOBDate() {
        ncCatDOBLabel.text = dateFormat(date: ncCatDOBPicker.date, formatDate: dateFormatTemp)
    }
    
    let dateFormatTemp =  "MMMM dd, yyyy"
    
    func dateFormat(date: Date, formatDate: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatDate
        return dateFormatter.string(from: date)
    }
    
    //MARK: Table View Display and Functions
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
        let cellCatNote =  indexPath.section == 9 && indexPath.row == 0
        
        var ncHeight: CGFloat = 54.0
        
        if (cellCatPhoto) {
            ncHeight = 250.0
        }
        if (cellCatNote) {
            ncHeight = 150.0
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

extension AddNewCatTableView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == ncCatNameTF {
            textField.resignFirstResponder()
        }
        else if textField == ncCatWeightTF {
            textField.resignFirstResponder()
        }
        else if textField == ncCatFeedingTF {
            textField.resignFirstResponder()
        }
        else if textField == ncCatVetsName {
            textField.resignFirstResponder()
        }
        else if textField == ncCatVetsPhoneNumber {
            textField.resignFirstResponder()
        }
        else if textField == ncCatNotesTV {
            textField.resignFirstResponder()
        }
        return true
    }
}

//MARK: - Extensions
extension AddNewCatTableView: UIPickerViewDataSource {
    
    //Pickers
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

extension AddNewCatTableView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //Image
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let catPhotoImage = info[UIImagePickerController.InfoKey.originalImage] as?UIImage
        else {
            return
        }
        print("Cek didFinishPickingMediaWithInfo")
        
        ncCatPhotoImage.image = catPhotoImage
        
        tableView.reloadData()
        }
    }
