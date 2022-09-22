//
//  IndexViewController.swift
//  775775Sports
//
//  Created by Remya on 9/7/22.
//

import UIKit

class IndexViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var collectionViewCategory: UICollectionView!
    
    @IBOutlet weak var collectionViewHeader: UICollectionView!
    
    @IBOutlet weak var tableViewIndex: UITableView!
    
    @IBOutlet weak var indexTableHeight: NSLayoutConstraint!
    
    //MARK: - Variables
    var tableViewIndexObserver: NSKeyValueObservation?
    var categories = ["Asia (Full)","1x2 (Full)","Over/Under(Full)","Asia(1st half)","Over/Under(1st half)"]
    var headers = ["Company","Home","Live Hand icap","Away","Home","Live Hand icap","Away"]
    var headerSizes = [CGFloat]()
    var categorySizes = [CGFloat]()
    var viewModel = IndexViewModel()
    var selectedCategoryIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()

    }
    
    func initialSetup(){
        collectionViewCategory.registerCell(identifier: "RoundSelectionCollectionViewCell")
        collectionViewHeader.registerCell(identifier: "TitleCollectionViewCell")
        collectionViewCategory.selectItem(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .left)
        tableViewIndex.register(UINib(nibName: "GeneralRowTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        tableViewIndexObserver = tableViewIndex.observe(\.contentSize, options: .new) { (_, change) in
            guard let height = change.newValue?.height else { return }
            self.indexTableHeight.constant = height
        }
        
        //Calculating cell widths for headings
        headerSizes = [85,15,15,15,15,15,15]
        let itemSpacing:CGFloat = CGFloat((headers.count - 1) * 5)
        let total_widths:CGFloat = headerSizes.reduce(0, +)
        let totalSpace:CGFloat = total_widths + itemSpacing
        let balance = (UIScreen.main.bounds.width - totalSpace)/CGFloat(headers.count)
        headerSizes = headerSizes.map{$0+balance}
        
        //calculating categorySizes
        for m in categories{
        let w = m.width(forHeight: 14, font: UIFont(name: "Poppins-Regular", size: 12)!) + 16
            categorySizes.append(w)
    
        }
        
        viewModel.delegate = self
        viewModel.getIndexData()
        
    }
    
    
    


}


extension IndexViewController:IndexViewModelDelgate{
    func didFinishFetch() {
        viewModel.filterData(index: selectedCategoryIndex)
        self.tableViewIndex.reloadData()
    }
    
    
}

extension IndexViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionViewCategory{
            return categories.count
        }
        else{
            return headers.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionViewCategory{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RoundSelectionCollectionViewCell", for: indexPath) as! RoundSelectionCollectionViewCell
            cell.lblTite.text = categories[indexPath.row]
        return cell
        }
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TitleCollectionViewCell", for: indexPath) as! TitleCollectionViewCell
            cell.titleType = .GrayHeader
            cell.lblTitle.text = headers[indexPath.row]
            return cell
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collectionViewCategory{
            selectedCategoryIndex = indexPath.row
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            viewModel.filterData(index: selectedCategoryIndex)
            self.tableViewIndex.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collectionViewHeader{
            return CGSize(width: headerSizes[indexPath.row], height: 55)
        }
        else{
            if categorySizes.count > indexPath.row{
            return CGSize(width: categorySizes[indexPath.row], height: 55)
            }
            else{
                return CGSize(width: 137, height: 55)
                
            }
        }
    }
    
    
}

extension IndexViewController:UITableViewDelegate,UITableViewDataSource{
    
func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.currentScores.count
}

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! GeneralRowTableViewCell
    cell.headerSizes = headerSizes
    cell.values = viewModel.currentScores[indexPath.row].getArrayValue()
    return cell
}
}

