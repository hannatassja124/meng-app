//
//  CalendarCollectionViewController.swift
//  meng-app
//
//  Created by Hannatassja Hardjadinata on 29/07/21.
//

import UIKit

class CalendarCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var selectedDate = Date()
    var totalSquares = [String]()
    let calendar = Calendar.current
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var activities = [Activity()]
    var activityModel = [String]()
    var arrayActivityHasEvent = 0
    var selectedIndex = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCellsView()
        setMonthView()
        
        retrieveData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        retrieveData()
        print("view will appear")
    }
    
    func retrieveData() {
        do {
            activities = try context.fetch(Activity.fetchRequest())
//            print("test", activities[0].activityDateTime)
            if activities.count != 0 {
                let dateFormater = DateFormatter()
                dateFormater.dateFormat = "dd"
                for (index, item) in activities.enumerated() {
                    let numberInInt = Int(dateFormater.string(from: activities[index].activityDateTime ?? Date()))
                    activityModel.append("\(numberInInt ?? 0)")
                }
                arrayActivityHasEvent = activityModel.count
//                collectionView.reloadData()
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
        
        monthLabel.text = CalendarHelper().monthString(date: selectedDate)
            + " " + CalendarHelper().yearString(date: selectedDate)
        collectionView.reloadData()
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
        
        if activityModel.contains("\(indexPath.row+1)") {
            print("tanggal")
            cell.markImage.isHidden = false
        }

//        if activityModel.contains("\(indexPath.row+1)") {
//            cell.dayOfMonth.textColor = #colorLiteral(red: 0.9946215749, green: 0.5330578685, blue: 0.5085751414, alpha: 1)
//            if activityModel.count > arrayActivityHasEvent {
//                if "\(indexPath.row + 1)" == activityModel.last {
//                    cell.contentView.backgroundColor =  #colorLiteral(red: 0.9946215749, green: 0.5330578685, blue: 0.5085751414, alpha: 1)
//                    cell.dayOfMonth.textColor = .white
//                }
//            }
//        } else {
//            cell.dayOfMonth.textColor = UIColor.black
//        }
//
        return cell
    }
    
    @IBAction func previousMonth(_ sender: Any) {
        selectedDate = CalendarHelper().minusMonth(date: selectedDate)
        setMonthView()
    }
    
    
    @IBAction func nextMonth(_ sender: Any) {
        selectedDate = CalendarHelper().plusMonth(date: selectedDate)
        setMonthView()
    }
    
    override open var shouldAutorotate: Bool
    {
            return false
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
//        if activityModel.contains("\(indexPath.row+1)") {
////            activityModel.removeLast()
////            activityModel.append("\(indexPath.row+1)")
////            let indexObject = activityModel.firstIndex(of: "\(indexPath.row+1)")
////            guard let index = indexObject else { return }
////            activityModel.remove(at: index)
//        } else {
//            if activityModel.count == arrayActivityHasEvent {
//                activityModel.append("\(indexPath.row+1)")
//            } else {
//                activityModel.removeLast()
//                activityModel.append("\(indexPath.row+1)")
//            }
//        }
        
        let selectedDateCell = CalendarHelper().yearString(date: selectedDate) + "-" + CalendarHelper().monthNumber(date: selectedDate) + "-" + totalSquares[indexPath.item] + " 00:00:00 +0700"
        
        //collectionView.reloadData()
        
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

