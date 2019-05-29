//
//  DetailViewController.swift
//  KineduTest
//
//  Created by Vicente Cantu Garcia on 5/27/19.
//  Copyright © 2019 Vicente Cantu Garcia. All rights reserved.
//

import UIKit
import UPCarouselFlowLayout

class DetailViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var babyCollectionView: UICollectionView!
    
    @IBOutlet weak var premiumUsers: UILabel!
    @IBOutlet weak var freemiumUsers: UILabel!
    @IBOutlet weak var detailActivities: UILabel!
    
    var currentIndex = 0
    var version: String!
    var nps: NPSProcessed!
    
    fileprivate var pageSize: CGSize {
        let layout = babyCollectionView.collectionViewLayout as! UPCarouselFlowLayout
        var pageSize = layout.itemSize
        if layout.scrollDirection == .horizontal {
            pageSize.width += layout.minimumLineSpacing
        } else {
            pageSize.height += layout.minimumLineSpacing
        }
        return pageSize
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        title = "NPS Detail \(version ?? "")"
        updateNPSDetailText(index: 0)
        updateNPSDetailUserPlan(index: 0)
    }

    
    fileprivate func setupCollectionView() {
        let layout = babyCollectionView.collectionViewLayout as! UPCarouselFlowLayout
        layout.spacingMode = UPCarouselFlowLayoutSpacingMode.fixed(spacing: 20)
    }

}

// MARK: - UICollectionViewController

extension DetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BABY_CELL", for: indexPath) as! BabyCollectionViewCell
        
        cell.babyImage.image = UIImage(named: "baby_" + String(indexPath.item))
        cell.babyNumber.text = String(indexPath.item + 1)
        
        return cell
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let layout = babyCollectionView.collectionViewLayout as! UPCarouselFlowLayout
        let pageSide = (layout.scrollDirection == .horizontal) ? pageSize.width : pageSize.height
        let offset = (layout.scrollDirection == .horizontal) ? scrollView.contentOffset.x : scrollView.contentOffset.y
        currentIndex = Int(floor((offset - pageSide / 2) / pageSide) + 1)
        updateNPSDetailText(index: currentIndex)
        updateNPSDetailUserPlan(index: currentIndex)
    }
    
    // MARK: - Function Helpers
    
    func updateNPSDetailText(index: Int)  {
        
        let userActivity = nps.activityViews[index + 1]
        
        let valueBigger = userActivity.max { (arg0, arg1) -> Bool in
            return arg0.countOfUsers < arg1.countOfUsers
        }
        
        let totalOfUsers = userActivity.reduce(0) { result, tuple in
            let (countOfUsers, _) = tuple
            return result + countOfUsers
        }
        
        let percentageOfUsers = Int((Double(valueBigger!.countOfUsers) / Double(totalOfUsers)) * 100)
        let activityViews = valueBigger!.activityViews
        
        let allString = "\(percentageOfUsers)% of the users that answered \(currentIndex + 1) in their NPS score saw \(activityViews) activities"
        
        let firstWord = "\(percentageOfUsers)%"
        let firstRange = (allString as NSString).range(of: firstWord)
        
        let secondWord = "\(activityViews) activities"
        let secondRange = (allString as NSString).range(of: secondWord)
        
        let attributedText = NSMutableAttributedString.init(string: allString)
        attributedText.addAttributes([NSAttributedString.Key.font: UIFont(name: "GothamRounded-Bold", size: 18)!,
                                            NSAttributedString.Key.foregroundColor: UIColor(named: "Green")!], range: firstRange)
        
        attributedText.addAttributes([NSAttributedString.Key.font: UIFont(name: "GothamRounded-Bold", size: 18)!,
                                            NSAttributedString.Key.foregroundColor: UIColor(named: "BlueLigth")!], range: secondRange)
        
        detailActivities.text = allString
        detailActivities.attributedText = attributedText
        
    }
    
    func updateNPSDetailUserPlan(index: Int) {
        
        let premium = nps.premium[index + 1]
        let freemium = nps.freemium[index + 1]
        
        premium < 10 ? (premiumUsers.text = "0\(premium)") : (premiumUsers.text = String(premium))
        
        freemium < 10 ? (freemiumUsers.text = "0\(freemium)") : (freemiumUsers.text = String(freemium))
    }
    
    
}
