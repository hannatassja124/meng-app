//
//  ActivityLogTableViewController.swift
//  meng-app
//
//  Created by William Giovanni Kambuno on 28/07/21.
//
//MARK: - !!To-Do!!
//HELPER CODE TO CLEAN THE FOLLOWING: Reminder to Minutes & Activities Type to Integer
//Edit
//Delete
//Reminder Switch to hide Reminder Cell & NOT save data

import UIKit

protocol ActivityLogTableViewControllerProtocol: AnyObject {
    func updateReloadData()
}

class ActivityLogTableViewController: UITableViewController, UIPickerViewDelegate, UITextViewDelegate {

//MARK: - Outlets
    
    //NavBar
    @IBOutlet weak var NavBarButtonBack: UIBarButtonItem!
    @IBOutlet weak var NavBarButtonSave: UIBarButtonItem!
    
    
    //Section 1 - Select Cat
    @IBOutlet weak var LabelCat: UILabel!
    @IBOutlet weak var ImageCatColour: UIImageView!
    
    //Section 2 - Activities
    @IBOutlet weak var CollectionViewActivities: UICollectionView!
    
    //Section 3 - Form
    @IBOutlet weak var TextFieldTitle: UITextField!
    @IBOutlet weak var TextFieldDetails: UITextField!
    
    //Section 4 - Date and Time
    @IBOutlet weak var LabelDate: UILabel!
    @IBOutlet weak var DatePickerDate: UIDatePicker!
    
    @IBOutlet weak var DatePickerTime: UIDatePicker!
    
    //Section 5 - Reminder
    @IBOutlet weak var LabelReminderBefore: UILabel!
    @IBOutlet weak var PickerViewReminder: UIPickerView!

    
//MARK: - Variables
    var RemindBeforeData:[String] = [String]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var EditedActivity:Activity? = nil
    let dateFormatTemp =  "MMMM dd, yyyy"
    var ReminderChosen: Int = 0
    var SelectedActivitiesIndex: Int = 0
    var ActivityList = [ActivitiesTypeStruct(name: "Vaccine", iconName: "Vaccine"), ActivitiesTypeStruct(name: "Appointment", iconName: "Appointment"), ActivitiesTypeStruct(name: "Treatment", iconName: "Treatment"), ActivitiesTypeStruct(name: "Symptoms", iconName: "Symptoms"), ActivitiesTypeStruct(name: "Others", iconName: "Others")]
    var selectedCat = [CatData]() //unused?
    var cats = [Cats]()
    var selectedCatIndex: Int = -1
    var dateFormatter = DateFormatter()
    let calendar = Calendar.current
    
    var onViewWillDisappear: (()->())?
    
    weak var delegate: ActivityLogTableViewControllerProtocol?
    

//MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        retrieveData()
        
        PickerReminderFill()
        DatePickerDateDisplay()
        
        
        CollectionViewActivities.register(UINib(nibName: "ActivitiesCVC", bundle: nil), forCellWithReuseIdentifier: "ActivitiesCVCID")
        CollectionViewActivities.delegate = self
        CollectionViewActivities.dataSource = self
        
        hiddenPickers(fieldName: "init", indexPath: [-1])
        self.tableView.register(UINib(nibName: "ActivityLogDatePickerHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "ActivityLogDatePickerHeader")
        self.tableView.register(UINib(nibName: "ActivityLogActivitiesHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "ActivityLogActivitiesHeader")
        self.tableView.register(UINib(nibName: "ActivityLogDateTimeHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "ActivityLogDateTimeHeader")
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
//MARK: - Select Cat Data Pass
//Selected Cat Refresh after Data Pass from Modal
    
    func SelectedCatRefresh() {
        LabelCat.text = selectedCat[selectedCatIndex].cat.name!
        ImageCatColour.tintColor = TagsHelper.checkColor(tagsNumber: selectedCat[selectedCatIndex].cat.colorTags)
    }
    
    private func retrieveData(){
        do {
            cats = try context.fetch(Cats.fetchRequest())
        } catch {
            //error
            print("Error when retrieving data from CoreData")
        }
        for cat in cats {
            selectedCat.append(CatData(cat: cat))
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let SelectCatModal = segue.destination as! SelectCatViewController
        SelectCatModal.selectedCat = selectedCat
        SelectCatModal.onCatSelectedModal = {(index:Int) -> Void in
            self.selectedCat[index].isSelected = !self.selectedCat[index].isSelected
            if self.selectedCatIndex != index && self.selectedCatIndex != -1 {
                self.selectedCat[self.selectedCatIndex].isSelected = false
            }
            self.selectedCatIndex = index
            self.SelectedCatRefresh()
            print(self.selectedCatIndex)
        }
    }
    

//MARK: - NavBar
    @IBAction func SaveButtonAction(_ sender: Any) {
        SaveActivityLog()
        onViewWillDisappear!()
        self.dismiss(animated: true) {
            self.delegate?.updateReloadData()
        }

    }

    @IBAction func BackButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

//MARK: - Expandable/Collapsable Cells
    func hiddenPickers(fieldName: String, indexPath: IndexPath) {
        DatePickerDate.isHidden = fieldName == "ActivityDate" ? !DatePickerDate.isHidden : true
        PickerViewReminder.isHidden = fieldName == "ActivityReminder" ? !PickerViewReminder.isHidden : true
        
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
        let cellDatePickerDate = indexPath.section == 3 && indexPath.row == 1
        let cellActivities = indexPath.section == 1 && indexPath.row == 0
        let cellFormTitle = indexPath.section == 2 && indexPath.row == 0
        let cellFormDetails = indexPath.section == 2 && indexPath.row == 1
        let cellPickerReminder = indexPath.section == 4 && indexPath.row == 1
        
        var ncHeight: CGFloat = 43.5
        
        if (cellDatePickerDate) {
            ncHeight = 340.0
        }
        
        if (cellPickerReminder) {
            ncHeight = 160.0
        }
        
        if (cellDatePickerDate && DatePickerDate.isHidden) || (cellPickerReminder && PickerViewReminder.isHidden) {
            ncHeight = 0.0
        }
        
        if (cellActivities) {
            ncHeight = 100.0
        }
        
        if (cellFormTitle) {
            ncHeight = 48.0
        }
        
        if (cellFormDetails) {
            ncHeight = 112.0
        }
        
        return ncHeight
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let DatePickerDateIP = NSIndexPath (row: 0, section: 3)
        let PickerViewReminderIP = NSIndexPath (row: 0, section: 4)
        
        if DatePickerDateIP as IndexPath == indexPath {
            hiddenPickers(fieldName: "ActivityDate", indexPath: indexPath)
        }
        else if PickerViewReminderIP as IndexPath == indexPath {
            hiddenPickers(fieldName: "ActivityReminder", indexPath: indexPath)
        }
    }
    
    
// MARK: - TableView SectionHeader
// UITableViewSectionHeader Custom (Using XIB)
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 1 {
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ActivityLogActivitiesHeader") as? ActivityLogActivitiesHeader
            
            return headerView!
        }
        else if section == 3 {
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ActivityLogDateTimeHeader") as? ActivityLogDateTimeHeader
            
            return headerView!
        }
        else if section == 4 {
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ActivityLogDatePickerHeader") as? ActivityLogDatePickerHeader
            
            return headerView!
        } else {
            return UIView()
        }
    }
     
     
//MARK: - Save Activity Log
    // Save New Data
        func SaveActivityLog(){
            if EditedActivity == nil {
                let NewActivityLog = Activity(context: context)
                
                //Section 1 DONE
                if LabelCat.text == "" {
                    //Display Alert to Select a Cat
                }
                else{
                    NewActivityLog.addToCats(cats[selectedCatIndex])
                }
                
                //Section 2 DONE
                if SelectedActivitiesIndex == 0 {
                    NewActivityLog.activityType = "Vaccine"
                }
                else if SelectedActivitiesIndex == 1 {
                    NewActivityLog.activityType = "Appointment"
                }
                else if SelectedActivitiesIndex == 2 {
                    NewActivityLog.activityType = "Treatment"
                }
                else if SelectedActivitiesIndex == 3 {
                    NewActivityLog.activityType = "Symptoms"
                }
                else if SelectedActivitiesIndex == 4 {
                    NewActivityLog.activityType = "Others"
                }
                
                //Section 3 DONE
                if TextFieldTitle.text == nil{
                    //display Alert
                }
                else{
                    NewActivityLog.activityTitle = "\(TextFieldTitle.text ?? "")"
                }
                
                if TextFieldDetails.text == nil{
                    //display Alert
                }
                else{
                    NewActivityLog.activityDetail = "\(TextFieldDetails.text ?? "")"
                }
                
                //Section 4 DONE
                
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let DateDay = dateFormatter.string(from: DatePickerDate.date)
                dateFormatter.dateFormat = "hh:mm:ss a Z"
                let TimeDay = dateFormatter.string(from: DatePickerTime.date)
                let ActualDateTime = DateDay + " " + TimeDay
                
                dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss a Z"

                let ActualActualActualDate = dateFormatter.date(from: ActualDateTime)!
                
                NewActivityLog.activityDateTime = ActualActualActualDate
                
                
                
                //Section 5 DONE
                NewActivityLog.activityReminder = self.ReminderToMinutes()
                
                do {
                    try context.save()
                } catch {
                    print("Ga kesave")
                }
                /*if SwitchOff {
                 
                    
                }
                else{
                    NewActivityLog.activityReminder = self.ReminderToMinutes()
                }*/
               
//MARK: - Edit
    // Edit Existing Data
            /*
            else if EditedActivity != nil {
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
            }
            do {
                try context.save()
            } catch {
                print("Ga kesave")
            }
            */
            //onViewWillDisappear!() dunno what this is used for
        }
        
    // Set data pas mau edit
            /*
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
            }*/
        }
    
    
//MARK: - Picker Reminder Choices
        func PickerReminderFill(){
            self.PickerViewReminder.delegate = self
            self.PickerViewReminder.dataSource = self
            
            RemindBeforeData = ["5 minutes before", "10 minutes before", "15 minutes before", "30 minutes before", "1 hour before", "2 hours before", "1 day before", "2 days before", "1 week before"]
        }

//MARK: - Format Date to String
    @IBAction func DatePickerDateAction(_ sender: Any) {
        LabelDate.text = dateFormat(date: DatePickerDate.date, formatDate: dateFormatTemp)
    }
    
    // 2 functions, one for ViewDidLoad (user did not change default date (today)) and one for PickerAction (User Chose Date)
    func DatePickerDateDisplay() {
        LabelDate.text = dateFormat(date: DatePickerDate.date, formatDate: dateFormatTemp)
    }
        
    func dateFormat(date: Date, formatDate: String) -> String {
        dateFormatter.dateFormat = formatDate
        return dateFormatter.string(from: date)
    }
    
//MARK: - Format Reminder to Minutes
    func ReminderToMinutes() -> Int64 {
        if ReminderChosen == 0 {return 5} //5m
        else if ReminderChosen == 1 {return 10} //10m
        else if ReminderChosen == 2 {return 15} //15m
        else if ReminderChosen == 3 {return 30} //30m
        else if ReminderChosen == 4 {return 60} //1 hour
        else if ReminderChosen == 5 {return 120} //2 hours
        else if ReminderChosen == 6 {return 1440} //1 day
        else if ReminderChosen == 7 {return 2880} //2 days
        else if ReminderChosen == 8 {return 10080} //1 week
        else {return 0} //No reminder Set
    }
    
//MARK: - PickerView Settings
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            print(RemindBeforeData[row])
            LabelReminderBefore.text = RemindBeforeData[row]
            ReminderChosen = row
        }
    
    
    /*
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }*/

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    

}


//MARK: - PickerView DataSource
extension ActivityLogTableViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return RemindBeforeData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(RemindBeforeData[row])"
    }
}

//MARK: - CollectionView Delegate/DataSource
extension ActivityLogTableViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = (CollectionViewActivities.dequeueReusableCell(withReuseIdentifier: "ActivitiesCVCID", for: indexPath) as? ActivitiesCVC)!
        cell.LabelActivity.text = ActivityList[indexPath.row].name
        cell.ImageBackground.image = UIImage(named: ActivityList[indexPath.row].iconName)
        if ActivityList[indexPath.row].isSelected {
            cell.ViewBackground.backgroundColor = #colorLiteral(red: 1, green: 0.7445316911, blue: 0.7005677223, alpha: 1)
            cell.ImageBackground.tintColor = #colorLiteral(red: 0.4296851158, green: 0.1989070773, blue: 0.1972613335, alpha: 1)
            cell.LabelActivity.textColor = #colorLiteral(red: 0.4296851158, green: 0.1989070773, blue: 0.1972613335, alpha: 1)
        }
        else {
            cell.ViewBackground.backgroundColor = #colorLiteral(red: 0.8373829722, green: 0.9012431502, blue: 0.8903146386, alpha: 1)
            cell.ImageBackground.tintColor = #colorLiteral(red: 0.6278990507, green: 0.7064616084, blue: 0.7296723127, alpha: 1)
            cell.LabelActivity.textColor = #colorLiteral(red: 0.6278990507, green: 0.7064616084, blue: 0.7296723127, alpha: 1)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        SelectedActivitiesIndex = indexPath.row
        
        for i in 0...4 {
            ActivityList[i].isSelected = false
        }
        ActivityList[indexPath.row].isSelected = true
        CollectionViewActivities.reloadData()
    }
}
