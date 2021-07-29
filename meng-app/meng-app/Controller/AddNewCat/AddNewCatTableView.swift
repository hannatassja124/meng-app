//
//  AddNewCatTableView.swift
//  meng-app
//
//  Created by Adinda Puji Rahmawaty on 29/07/21.
//

import UIKit

class AddNewCatTableView: UITableViewController {
    
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

    }
    
    func nameField() {
        
        // Placeholder di tengah
        let centeredParagraphStyle = NSMutableParagraphStyle()
        centeredParagraphStyle.alignment = .center
        let attributedPlaceholder = NSAttributedString(string: "Name", attributes: [NSAttributedString.Key.paragraphStyle:centeredParagraphStyle])
        ncCatNameTF.attributedPlaceholder = attributedPlaceholder
        
        // Input mulai dari tengah
        ncCatNameTF.textAlignment = .center
    }
    
    
}
