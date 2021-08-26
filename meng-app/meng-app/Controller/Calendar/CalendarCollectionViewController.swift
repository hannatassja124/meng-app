//
//  CalendarCollectionViewController.swift
//  meng-app
//
//  Created by Hannatassja Hardjadinata on 29/07/21.
//

import UIKit
import CoreData

var objchildVc = CalendarCollectionViewController()

class CalendarCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, parentDelegate {
    
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var selectedDate = Date()
    var totalSquares = [String]()
    let calendar = Calendar.current
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var activities = [Activity()]
    //var activityModel = Set<String>()
    var activityModel = [String]()
    var arrayActivityHasEvent = 0
    var selectedIndex = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCellsView()
        setMonthView()
        
        retrieveData()
        print(activityModel)
    }
    
    func retrieveData() {
        do {
            activities = try context.fetch(Activity.fetchRequest())
            let monthFilter = activities.filter(){$0.activityDateTime!.month == selectedDate.month}
            if monthFilter.count != 0 {
                let dateFormater = DateFormatter()
                dateFormater.dateFormat = "dd"
                for (index, _) in monthFilter.enumerated() {
                    let numberInInt = Int(dateFormater.string(from: monthFilter[index].activityDateTime ?? Date()))
                    activityModel.append("\(numberInInt ?? 0)")
                }
                arrayActivityHasEvent = activityModel.count
                print("count", arrayActivityHasEvent)
            }
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
            
        } catch {
            print("error")
        }
        
    }
    
    func setCellsView() {
        let width = (collectionView.frame.size.width - 2)/8
        let heigth = (collectionView.frame.size.height - 2)/8
        
        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.itemSize = CGSize(width: width, height: heigth)
    }
    
    func setMonthView()
    {
        totalSquares.removeAll()
        
        let daysInMonth = CalendarHelper().daysInMonth(date: selectedDate)
        let firstDayOfMonth = CalendarHelper().firstOfMonth(date: selectedDate)
        let startingSpaces = CalendarHelper().weekDay(date: firstDayOfMonth)
        
        var count: Int = 1
        
        while(count <= 42)
        {
            if(count <= startingSpaces || count - startingSpaces > daysInMonth)
            {
                totalSquares.append("")
            }
            else
            {
                totalSquares.append(String(count - startingSpaces))
            }
            count += 1
        }
        print("nil", selectedDate)
        monthLabel.text = CalendarHelper().monthString(date: selectedDate)
            + " " + CalendarHelper().yearString(date: selectedDate)
        collectionView.reloadData()
    }
    
    func setMark(){
        //selectedDate = Date()
        activityModel.removeAll()
        setMonthView()
        retrieveData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        totalSquares.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "calCell", for: indexPath) as! CalendarCell
        
        cell.dayOfMonth.text = totalSquares[indexPath.item]

        let defaultDate = "\(calendar.component(.day, from: selectedDate))"

        if totalSquares[indexPath.item] ==  defaultDate {
            collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .left)
            cell.isSelected = true
        }
        
        cell.markImage.isHidden = true
        if activityModel.contains(totalSquares[indexPath.item]){
            print("total", totalSquares[indexPath.item])
            cell.markImage.isHidden = false
        }
        
        cell.isUserInteractionEnabled = true
        if totalSquares[indexPath.item].isEmpty {
            cell.isUserInteractionEnabled = false
        }
        
        return cell
    }
    
    @IBAction func previousMonth(_ sender: Any) {
        selectedDate = CalendarHelper().minusMonth(date: selectedDate)
        setMark()
    }
    
    
    @IBAction func nextMonth(_ sender: Any) {
        selectedDate = CalendarHelper().plusMonth(date: selectedDate)
        setMark()
    }
    
    override open var shouldAutorotate: Bool
    {
            return false
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selectedDateCell = CalendarHelper().yearString(date: selectedDate) + "-" + CalendarHelper().monthNumber(date: selectedDate) + "-" + totalSquares[indexPath.item] + " 00:00:00 +0700"
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss Z"
        
        let vc = parent as! CalendarViewController
        print("selected date", dateFormatter.date(from: selectedDateCell)!)
        vc.retrieveData(activityDate: dateFormatter.date(from: selectedDateCell)!)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        collectionView.allowsMultipleSelection = false
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {

    }
    
}

extension Date {
    var month: Int {
        return NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!.component(.month, from: self as Date)
    }
    var year: Int {
        return NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!.component(.year, from: self as Date)
    }
}
