//
//  HistoryViewController.swift
//  meng-app
//
//  Created by Arya Ilham on 07/08/21.
//

import UIKit

class HistoryViewController: UIViewController {
    
    var selectedCat = Cats()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(selectedCat.name)
        // Do any additional setup after loading the view.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
