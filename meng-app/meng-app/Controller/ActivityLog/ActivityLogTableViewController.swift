//
//  ActivityLogTableViewController.swift
//  meng-app
//
//  Created by William Giovanni Kambuno on 28/07/21.
//
//MARK: - !!To-Do!!
//HELPER CODE TO CLEAN THE FOLLOWING: Reminder to Minutes & Activities Type to Integer
//Delete
//Reminder Switch to hide Reminder Cell & NOT save data

//NEW STUFF
//Lines: 17 71 78 151 458

import UIKit

protocol ActivityLogTableViewProtocol: AnyObject {
    func backToRoot()
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
    
    //Section 6 - Delete
    @IBOutlet weak var TableViewCellDelete: UITableViewCell!

    
//MARK: - Variables
    var RemindBeforeData:[String] = [String]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var EditedActivity:Activity? = nil
    let dateFormatTemp =  "MMMM dd, yyyy"
    var ReminderChosen: Int64 = 0
    var SelectedActivitiesIndex: Int = -1
    var ActivityList = [ActivitiesTypeStruct(name: "Vaccine", iconName: "Vaccine"), ActivitiesTypeStruct(name: "Appointment", iconName: "Appointment"), ActivitiesTypeStruct(name: "Treatment", iconName: "Treatment"), ActivitiesTypeStruct(name: "Symptoms", iconName: "Symptoms"), ActivitiesTypeStruct(name: "Others", iconName: "Others")]
    var selectedCat = [CatData]()
    var cats = [Cats]()
    var selectedCatIndex: Int = -1
    //var previouslySelectedCatIndex: Int = -1  //unused?
    var dateFormatter = DateFormatter()
    let calendar = Calendar.current
    //var SaveSuccess = false   //unused?
    var onViewWillDisappear: (()->())?
    var EmptyState = false
    weak var Delegate: ActivityLogTableViewProtocol?
    
    //IDK if this works; Switch Delegating stuff
    let ReminderHeader = ActivityLogDatePickerHeader()
    var SwitchInt = -1 //For Testing switch delegate; DELETE ONCE DONE

    

//MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        retrieveData()
        
        PickerReminderFill()
        DatePickerDateDisplay()
        //DatePickerTime.textColor = .white //Doesn't work
        //DatePickerTime.tintColor = .yellow //this works though; only on Highlight
        
        LoadExistingData()
        
        if EditedActivity == nil {
            TableViewCellDelete.isHidden = true
        }
        else {
            TableViewCellDelete.isHidden = false
        }
        
        CollectionViewActivities.register(UINib(nibName: "ActivitiesCVC", bundle: nil), forCellWithReuseIdentifier: "ActivitiesCVCID")
        CollectionViewActivities.delegate = self
        CollectionViewActivities.dataSource = self
        
        DispatchQueue.main.async {
            self.hiddenPickers(fieldName: "init", indexPath: [-1])
        }
        
        self.tableView.register(UINib(nibName: "ActivityLogDatePickerHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "ActivityLogDatePickerHeader")
        self.tableView.register(UINib(nibName: "ActivityLogActivitiesHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "ActivityLogActivitiesHeader")
        self.tableView.register(UINib(nibName: "ActivityLogDateTimeHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "ActivityLogDateTimeHeader")
        
        //IDK if this works; Switch Delegating stuff
        ReminderHeader.Delegate = self
        print(SwitchInt)
        
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
        }
    }
    

//MARK: - Button Functions
    @IBAction func SaveButtonAction(_ sender: Any) {
        EmptyCheck()
        if (EmptyState == false) {
            SaveActivityLog()
            self.dismiss(animated: true, completion: nil)
        }
        EmptyState = false
    }

    @IBAction func BackButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func ButtonDeleteActivity(_ sender: Any) {
        let alert = UIAlertController(title: "Delete Activity Log", message: "Are you sure you want to permanently delete this Log?", preferredStyle: .actionSheet)
        let DeleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: deleteConfirm)
        let CancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler:deleteCancel)
        alert.addAction(DeleteAction)
        alert.addAction(CancelAction)
        self.present(alert, animated: true, completion: nil)
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
     
     
//MARK: - Save
    //Check if Empty
    func EmptyCheck() {
        if selectedCatIndex == -1 {
            let Alert = UIAlertController(title: "Error", message: "Please select a Cat.", preferredStyle: .alert)
            Alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in NSLog("The \"OK\" alert occured.")}))
            self.present(Alert, animated: true, completion: nil)
            EmptyState = true
        }
        else if (SelectedActivitiesIndex > 4 || SelectedActivitiesIndex < 0) {
            let Alert = UIAlertController(title: "Error", message: "Please select an Activity Type.", preferredStyle: .alert)
            Alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in NSLog("The \"OK\" alert occured.")}))
            self.present(Alert, animated: true, completion: nil)
            EmptyState = true
        }
        else if TextFieldTitle.text == ""{
            let Alert = UIAlertController(title: "Error", message: "Please enter a Title.", preferredStyle: .alert)
            Alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in NSLog("The \"OK\" alert occured.")}))
            self.present(Alert, animated: true, completion: nil)
            EmptyState = true
        }
        else if TextFieldDetails.text == ""{
            let Alert = UIAlertController(title: "Error", message: "Please enter a Description.", preferredStyle: .alert)
            Alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in NSLog("The \"OK\" alert occured.")}))
            self.present(Alert, animated: true, completion: nil)
            EmptyState = true
        }
    }
    
    // Save New Data
    func SaveActivityLog(){
        if EditedActivity == nil {//Actually starts saving
            let NewActivityLog = Activity(context: context)
            
            //Section 1
            NewActivityLog.addToCats(cats[selectedCatIndex])
            
            //Section 2
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
            
            //Section 3
            NewActivityLog.activityTitle = "\(TextFieldTitle.text ?? "")"
            NewActivityLog.activityDetail = "\(TextFieldDetails.text ?? "")"
            
            //Section 4
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let DateDay = dateFormatter.string(from: DatePickerDate.date)
            dateFormatter.dateFormat = "hh:mm:ss a Z"
            let TimeDay = dateFormatter.string(from: DatePickerTime.date)
            let ActualDateTime = DateDay + " " + TimeDay
            dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss a Z"
            let ActualActualActualDate = dateFormatter.date(from: ActualDateTime)!
            
            NewActivityLog.activityDateTime = ActualActualActualDate
            
            //Section 5
            NewActivityLog.activityReminder = self.ReminderToMinutes()
            /*if SwitchOff {
             
             }
             else{
             NewActivityLog.activityReminder = self.ReminderToMinutes()
             }*/
        }
        
        
        //MARK: - Edit
        // Edit (Save into) Existing Data
        else if EditedActivity != nil {
            //Section 1
            guard let cat = EditedActivity?.cats?.allObjects as? [Cats] else {
                return
            }
            EditedActivity?.removeFromCats(cat[cat.count - 1])
            EditedActivity?.addToCats(cats[selectedCatIndex])
            
            //Section 2
            if SelectedActivitiesIndex == 0 {
                EditedActivity!.activityType = "Vaccine"
            }
            else if SelectedActivitiesIndex == 1 {
                EditedActivity!.activityType = "Appointment"
            }
            else if SelectedActivitiesIndex == 2 {
                EditedActivity!.activityType = "Treatment"
            }
            else if SelectedActivitiesIndex == 3 {
                EditedActivity!.activityType = "Symptoms"
            }
            else if SelectedActivitiesIndex == 4 {
                EditedActivity!.activityType = "Others"
            }
            
            //Section 3
            EditedActivity!.activityTitle = "\(TextFieldTitle.text ?? "")"
            EditedActivity!.activityDetail = "\(TextFieldDetails.text ?? "")"
            
            //Section 4
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let DateDay = dateFormatter.string(from: DatePickerDate.date)
            dateFormatter.dateFormat = "hh:mm:ss a Z"
            let TimeDay = dateFormatter.string(from: DatePickerTime.date)
            let ActualDateTime = DateDay + " " + TimeDay
            
            dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss a Z"
            
            let ActualActualActualDate = dateFormatter.date(from: ActualDateTime)!
            
            EditedActivity!.activityDateTime = ActualActualActualDate
            
            //Section 5
            EditedActivity!.activityReminder = self.ReminderToMinutes()
            /*if SwitchOff {
             
             }
             else{
             NewActivityLog.activityReminder = self.ReminderToMinutes()
             }*/
        }
        do {
            try context.save()
        } catch {
            print("Ga kesave")
        }
    }
    
    
    // Load Saved data during Edit
    
    func LoadExistingData() {
        if EditedActivity != nil {
            //Section 1
            guard let cat = EditedActivity?.cats?.allObjects as? [Cats] else {
                return
            }
            
            LabelCat.text = cat[cat.count - 1].name
            ImageCatColour.tintColor = TagsHelper.checkColor(tagsNumber: cat[cat.count - 1].colorTags)
            
            //Section 2
            if EditedActivity!.activityType == "Vaccine"
            {
                SelectedActivitiesIndex = 0
            }
            else if EditedActivity!.activityType == "Appointment"
            {
                SelectedActivitiesIndex = 1
            }
            else if EditedActivity!.activityType == "Treatment"
            {
                SelectedActivitiesIndex = 2
            }
            else if EditedActivity!.activityType == "Symptoms"
            {
                SelectedActivitiesIndex = 3
            }
            else if EditedActivity!.activityType == "Others"
            {
                SelectedActivitiesIndex = 4
            }
            ActivityList[SelectedActivitiesIndex].isSelected = true
            CollectionViewActivities.reloadData()
            
            //Section 3
            TextFieldTitle.text = EditedActivity!.activityTitle
            TextFieldDetails.text = EditedActivity!.activityDetail
            
            //Section 4
            DatePickerDate.date = (EditedActivity?.activityDateTime)!
            DatePickerTime.date = (EditedActivity?.activityDateTime)!
            
            LabelDate.text = dateFormat(date: DatePickerDate.date, formatDate: dateFormatTemp)
            
            //Section 5
            ReminderChosen = EditedActivity!.activityReminder
            
            PickerViewReminder.selectRow(Int(self.MinutesToReminder()), inComponent: 0, animated: true)
            LabelReminderBefore.text = RemindBeforeData[Int(self.MinutesToReminder())]
        }
    }
    
//MARK: Delete
    func deleteConfirm(alertAction: UIAlertAction!) {
        context.delete(EditedActivity!) // Force Unwrapping causes crash. Happens when User DeleteButton -> Cancel -> DeleteButton -> Confirm; Thread 1: Fatal error: Unexpectedly found nil while unwrapping an Optional value.
        do {
            try context.save()
            DispatchQueue.main.async {
                self.Delegate?.backToRoot()
                self.dismiss(animated: true, completion: nil)
            }
        }
        catch{
            print("Ga kedelete")
        }
    }

    func deleteCancel(alertAction: UIAlertAction!){
        EditedActivity = nil
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
    
    
//MARK: - Reminder Formatting
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
    
    func MinutesToReminder() -> Int64 {
        if ReminderChosen == 5 {return 0} //5m
        else if ReminderChosen == 10 {return 1} //10m
        else if ReminderChosen == 15 {return 2} //15m
        else if ReminderChosen == 30 {return 3} //30m
        else if ReminderChosen == 60 {return 4} //1 hour
        else if ReminderChosen == 120 {return 5} //2 hours
        else if ReminderChosen == 1440 {return 6} //1 day
        else if ReminderChosen == 2880 {return 7} //2 days
        else if ReminderChosen == 10080 {return 8} //1 week
        else {return 0} //No reminder Set
    }
    
    
//MARK: - PickerView Settings
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            LabelReminderBefore.text = RemindBeforeData[row]
            ReminderChosen = Int64(row)
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

//Doesn't work; TimePicker Idle Colour stuff
extension UIDatePicker {

var textColor: UIColor? {
    set {
        setValue(newValue, forKeyPath: "textColor")
    }
    get {
        return value(forKeyPath: "textColor") as? UIColor
    }
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


//MARK: - Reminder Switch Delegate
//NOTE: Might need xx.delegate = self to catch data from Switch (?)
extension ActivityLogTableViewController: ActivityLogDatePickerHeaderProtocol {
    func DidToggleSwitch(SwitchStatus: Int) {
        SwitchInt = SwitchStatus
        print("Delegate Works")// This Doesn't print :(
    }
}
