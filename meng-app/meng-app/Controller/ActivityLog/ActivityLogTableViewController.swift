//
//  ActivityLogTableViewController.swift
//  meng-app
//
//  Created by William Giovanni Kambuno on 28/07/21.
//

import UIKit

class ActivityLogTableViewController: UITableViewController, UIPickerViewDelegate, UITextViewDelegate {

//MARK: - Outlets
    //NavBar
    @IBOutlet weak var NavBarButtonBack: UIBarButtonItem!
    @IBOutlet weak var NavBarButtonSave: UIBarButtonItem!
    
    
    //Section 1 - Select Cat
    @IBOutlet weak var LabelCat: UILabel!
    @IBOutlet weak var ImageCatColour: UIImageView!
    
    //Section 2 - Activities
    
    //Section 3 - Form
    @IBOutlet weak var TextFieldTitle: UITextField!
    @IBOutlet weak var TextFieldDetails: UITextField!
    
    //Section 4 - Date and Time
    @IBOutlet weak var LabelDate: UILabel!
    @IBOutlet weak var DatePickerDate: UIDatePicker!
    
    @IBOutlet weak var LabelTime: UILabel!
    @IBOutlet weak var DatePickerTime: UIDatePicker!
    
    //Section 5 - Reminder
    @IBOutlet weak var LabelReminderBefore: UILabel!
    @IBOutlet weak var PickerViewReminder: UIPickerView!
    

//MARK: - Variables
    var RemindBeforeData:[String] = [String]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var EditedActivity:Activity? = nil
    let dateFormatTemp =  "MMMM dd, yyyy"

//MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PickerReminderFill()
        DatePickerDateDisplay()
        DatePickerTimeDisplay()
        
        hiddenPickers(fieldName: "init", indexPath: [-1])
        self.tableView.register(UINib(nibName: "ActivityLogDatePickerHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "ActivityLogDatePickerHeader")

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

//MARK: - NavBar
    @IBAction func SaveButtonAction(_ sender: Any) {
        SaveActivityLog()
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func BackButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

//MARK: - Expandable/Collapsable Cells
    func hiddenPickers(fieldName: String, indexPath: IndexPath) {
        DatePickerDate.isHidden = fieldName == "ActivityDate" ? !DatePickerDate.isHidden : true
        DatePickerTime.isHidden = fieldName == "ActivityTime" ? !DatePickerTime.isHidden : true
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
        let cellDatePickerTime = indexPath.section == 3 && indexPath.row == 3
        let cellActivities = indexPath.section == 1 && indexPath.row == 0
        let cellFormTitle = indexPath.section == 2 && indexPath.row == 0
        let cellFormDetails = indexPath.section == 2 && indexPath.row == 1
        let cellPickerReminder = indexPath.section == 4 && indexPath.row == 1
        
        var ncHeight: CGFloat = 43.5
        
        if (cellDatePickerDate) {
            ncHeight = 360.0
        }
        
        if (cellDatePickerTime) {
            ncHeight = 64.0
        }
        
        if (cellPickerReminder) {
            ncHeight = 160.0
        }
        
        if (cellDatePickerDate && DatePickerDate.isHidden) || (cellDatePickerTime && DatePickerTime.isHidden) || (cellPickerReminder && PickerViewReminder.isHidden) {
            ncHeight = 0.0
        }
        
        if (cellActivities) {
            ncHeight = 96.0
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
        let DatePickerTimeIP = NSIndexPath (row: 2, section: 3)
        let PickerViewReminderIP = NSIndexPath (row: 0, section: 4)
        
        if DatePickerDateIP as IndexPath == indexPath {
            hiddenPickers(fieldName: "ActivityDate", indexPath: indexPath)
        }
        else if DatePickerTimeIP as IndexPath == indexPath {
            hiddenPickers(fieldName: "ActivityTime", indexPath: indexPath)
        }
        else if PickerViewReminderIP as IndexPath == indexPath {
            hiddenPickers(fieldName: "ActivityReminder", indexPath: indexPath)
        }
    }
    
    
// MARK: - TableView SectionHeader
// UITableViewSectionHeader Custom (Using XIB)
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 4 {
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ActivityLogDatePickerHeader") as? ActivityLogDatePickerHeader
            
            return headerView!
        } else {
            return UIView()
        }
    }
    
//MARK: - NOTDONE Save Activity Log
        func SaveActivityLog(){
            let NewActivityLog = Activity(context: context)
            
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
            
            NewActivityLog.activityDateTime = DatePickerDate.date //COMBINE DATE PICKER AND TIME PICKER; USE FUNCTION TO COMBINE Date Picker and Time Picker Strings and send it here.
            
            
            /*
            NewActivityLog.cats = //Selected Cat
            NewActivityLog.activityType = //Activity Type as String
            NewActivityLog.activityTitle = "\(TextFieldTitle.text)" //Activity Title as String
            NewActivityLog.activityDetail = //Activity Detail as String
            NewActivityLog.activityDateTime = //Activity Date & Time as Date
 */
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
    @IBAction func DatePickerTimeAction(_ sender: Any) {
        LabelTime.text = dateFormat(date: DatePickerTime.date, formatDate: dateFormatTemp)
    }
    
    // 2 functions, one for ViewDidLoad (user did not change default date (today)) and one for PickerAction (User Chose Date)
    func DatePickerDateDisplay() {
        LabelDate.text = dateFormat(date: DatePickerDate.date, formatDate: dateFormatTemp)
    }
    func DatePickerTimeDisplay() {
        LabelTime.text = dateFormat(date: DatePickerTime.date, formatDate: dateFormatTemp)
    }
        
    func dateFormat(date: Date, formatDate: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatDate
        return dateFormatter.string(from: date)
    }
    
//MARK: - PickerView Settings [DISPLAY PICKER CHOICES ARRAY INTO PICKER]
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            print(RemindBeforeData[row])
            LabelReminderBefore.text = RemindBeforeData[row]
        }
    
    
    /*
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
