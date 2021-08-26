//
//  GetStartedViewController.swift
//  meng-app
//
//  Created by Hannatassja Hardjadinata on 16/08/21.
//

import UIKit

class GetStartedViewController: UIViewController {

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - ACTION
    
    @IBAction func onboardingPage(_ sender: Any) {
        guard let vc = storyboard?.instantiateViewController(identifier: "onboardingStoryboad") as? OnboardingViewController
        else {
            fatalError("no vc")
        }
        
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }

}
