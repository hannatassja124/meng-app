//
//  GetStartedViewController.swift
//  meng-app
//
//  Created by Hannatassja Hardjadinata on 16/08/21.
//

import UIKit

class GetStartedViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func onboardingPage(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "onboardingStoryboad") as! OnboardingViewController
        
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
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
