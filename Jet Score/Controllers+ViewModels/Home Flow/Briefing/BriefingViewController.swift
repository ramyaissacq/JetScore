//
//  BriefingViewController.swift
//  775775Sports
//
//  Created by Remya on 9/14/22.
//

import UIKit

class BriefingViewController: UIViewController {
    @IBOutlet weak var textView:UITextView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var lblBriefing: UILabel!
    
    @IBOutlet weak var lblDescription: UILabel!
    
    @IBOutlet weak var lblConfidence: UILabel!
    
    
    @IBOutlet weak var lblMatchTrack: UILabel!
    
    
    @IBOutlet weak var collectionViewHome1: UICollectionView!
    
    @IBOutlet weak var collectionViewAway1: UICollectionView!
    
    @IBOutlet weak var collectionViewHome2: UICollectionView!
    
    @IBOutlet weak var collectionViewAway2: UICollectionView!
    
    @IBOutlet weak var collectionViewHome3: UICollectionView!
    
    @IBOutlet weak var collectionViewAway3: UICollectionView!
    
    //MARK: - Variables
    var viewModel = BreifingViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()

    }
    
    func initialSetup(){
        viewModel.delegate = self
        if HomeCategoryViewController.selectedSport == .soccer{
            scrollView.isHidden = true
        viewModel.getBriefingDetails()
        }
        else{
            collectionViewAway1.registerCell(identifier: "ResultCollectionViewCell")
            collectionViewAway2.registerCell(identifier: "ResultCollectionViewCell")
            collectionViewAway3.registerCell(identifier: "ResultCollectionViewCell")
            collectionViewHome1.registerCell(identifier: "ResultCollectionViewCell")
            collectionViewHome2.registerCell(identifier: "ResultCollectionViewCell")
            collectionViewHome3.registerCell(identifier: "ResultCollectionViewCell")
            
            viewModel.getBasketballBriefing()
        }
    }
    
    func setupBasketballBriefing(){
        lblBriefing.text = viewModel.basketballBriefing?.analyseEn?.htmlToString
        lblConfidence.text = viewModel.basketballBriefing?.confidenceEn?.htmlToString
        lblMatchTrack.text = viewModel.basketballBriefing?.headToHeadEn?.htmlToString
        lblDescription.text = viewModel.basketballBriefing?.explainEn?.htmlToString
        collectionViewHome1.reloadData()
        collectionViewHome2.reloadData()
        collectionViewHome3.reloadData()
        collectionViewAway1.reloadData()
        collectionViewAway2.reloadData()
        collectionViewAway3.reloadData()
        
    }
    
}

extension BriefingViewController:BreifingViewModelDelegate{
    func didFinishFetchBriefing() {
        setupBasketballBriefing()
        
    }
    
    func didFinishFetch() {
        textView.attributedText = viewModel.briefingData?.recommendEn?.htmlToAttributedString
    }
    
    
}


extension BriefingViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionViewHome1{
            return viewModel.home1.count
        }
        else if collectionView == collectionViewHome2{
            return viewModel.home2.count
        }
        else if collectionView == collectionViewHome3{
            return viewModel.home3.count
        }
        else if collectionView == collectionViewAway1{
            return viewModel.away1.count
        }
        else if collectionView == collectionViewAway2{
            return viewModel.away2.count
        }
        else if collectionView == collectionViewAway3{
            return viewModel.away3.count
        }
        return  0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ResultCollectionViewCell", for: indexPath) as! ResultCollectionViewCell
        var status = ""
        if collectionView == collectionViewHome1{
            status = viewModel.home1[indexPath.row]
        }
       else if collectionView == collectionViewHome2{
           status = viewModel.home2[indexPath.row]
       }
        else if collectionView == collectionViewHome3{
            status = viewModel.home3[indexPath.row]
        }
        else if collectionView == collectionViewAway1{
            status = viewModel.away1[indexPath.row]
        }
        else if collectionView == collectionViewAway2{
            status = viewModel.away2[indexPath.row]
        }
        else if collectionView == collectionViewAway3{
            status = viewModel.away3[indexPath.row]
        }
        cell.configureWithBriefing(status: status)
        return cell
        
    }
    
    
    
    
}
