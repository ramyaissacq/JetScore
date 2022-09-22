//
//  NewsDetailsViewController.swift
//  775775Sports
//
//  Created by Remya on 9/2/22.
//

import UIKit

class NewsDetailsViewController: BaseViewController {
    //MARK: - IBOutlets
    @IBOutlet weak var imgNews: UIImageView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var collectionViewTypes:UICollectionView!
    
    @IBOutlet weak var emptyView: UIView!
    
    //MARK: - Variables
    var collectionViewTypesObserver: NSKeyValueObservation?
    var newsID:Int?
    var viewModel = NewsDetailsViewModel()
    var cellWidths = [CGFloat]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSettings()

        // Do any additional setup after loading the view.
    }
    
    func initialSettings(){
        setBackButton()
        let shareBtn = getButton(image: UIImage(named: "share")!)
        shareBtn.addTarget(self, action: #selector(actionShare), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: shareBtn)
        collectionViewTypes.registerCell(identifier: "TypesCollectionViewCell")
        collectionViewTypesObserver = collectionViewTypes.observe(\.contentSize, options: .new) { (_, change) in
            guard let height = change.newValue?.height else { return }
            self.collectionViewHeight.constant = height
        }
        viewModel.delegate = self
        viewModel.getNewsDetails(newsID: newsID!)
        
    }
    
    @objc func actionShare(){
        
    }
    
    func setupDetails(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Utility.dateFormat.ddMMyyyyWithTimeZone.rawValue
        lblDate.text = Utility.formatDate(date: dateFormatter.date(from: viewModel.newsDetails?.createTime ?? ""), with: .ddMMMyyyy)
        imgNews.setImage(with: viewModel.newsDetails?.path, placeholder: Utility.getPlaceHolder())
        lblDescription.text = viewModel.newsDetails?.description
        for m in viewModel.newsDetails?.keywords?.components(separatedBy: ",") ?? []{
            let w = m.width(forHeight: 19, font: UIFont(name: "Poppins-Regular", size: 13)!) + 20
            //m.size(withAttributes:[.font: UIFont(name: "Poppins-Regular", size: 13)!])
            cellWidths.append(w)
        }
        collectionViewTypes.reloadData()
        if viewModel.newsDetails?.description?.isEmpty ?? false{
            emptyView.isHidden = false
        }
        else{
            emptyView.isHidden = true
        }
        
    }

    

}

extension NewsDetailsViewController:NewsDetailsViewModelDelegates{
    
    func didFinishFetch() {
        self.setupDetails()
    }
   
}

extension NewsDetailsViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.newsDetails?.keywords?.components(separatedBy: ",").count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TypesCollectionViewCell", for: indexPath) as! TypesCollectionViewCell
        let arr = viewModel.newsDetails?.keywords?.components(separatedBy: ",")
        cell.lblTitle.text = arr?[indexPath.row]
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidths[indexPath.row], height: 35)
    }
    
    
}
