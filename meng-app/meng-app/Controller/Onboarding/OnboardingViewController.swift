//
//  OnboardingViewController.swift
//  meng-app
//
//  Created by Hannatassja Hardjadinata on 16/08/21.
//

import UIKit

class OnboardingViewController: UIViewController {
    
    // MARK: - Outlet

    @IBOutlet weak var onboardingPageControl: UIPageControl!
    @IBOutlet weak var onboardingCollectionView: UICollectionView!
    @IBOutlet weak var nextButton: UIButton!
    
    // MARK: - Variables
    
    var slides: [OnboardingModel] = []
    var currPage = 0 {
        didSet {
            onboardingPageControl.currentPage = currPage
        }
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        slides = [
        OnboardingModel(title: "Activities Tracked!", desc: "Stay on track about your cat’s behavior \nand activities with activity log.", image: #imageLiteral(resourceName: "Meng-2")),
        OnboardingModel(title: "Manage Multiple Cats", desc: "Got multiple cats? No worries! Meng supports multiple cat profiles so you can log their  activities altogether.", image: #imageLiteral(resourceName: "Meng-2")),
        OnboardingModel(title: "Cat’s Health First!", desc: "Add your vet number for easy access in \ncase of emergency.", image: #imageLiteral(resourceName: "Meng-2"))
        ]
        
    }
    
    // MARK: - ACTION
    
    @IBAction func nextPage(_ sender: Any) {
        var ip:IndexPath
        currPage += 1
        if currPage > 2 {
            Core.shared.setIsNotNewUser()
            self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
            return
        }
        ip = IndexPath(item: currPage, section: 0)
        onboardingCollectionView.scrollToItem(at: ip, at: .centeredHorizontally, animated: true)
    }

    @IBAction func skipPage(_ sender: Any) {
        Core.shared.setIsNotNewUser()
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }

}

    // MARK: - Data Source & Delegate

extension OnboardingViewController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return slides.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "onboardingCell", for: indexPath) as? OnboardingCollectionViewCell else {
            fatalError("no cell")
        }
        cell.setup(slides[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: onboardingCollectionView.frame.width, height: onboardingCollectionView.frame.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currPage = Int(scrollView.contentOffset.x / width)
        onboardingPageControl.currentPage = currPage
    }
    
}
