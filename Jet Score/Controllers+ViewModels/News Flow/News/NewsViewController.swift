//
//  NewsViewController.swift
//  775775Sports
//
//  Created by Remya on 9/2/22.
//

import UIKit

class NewsViewController: BaseViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var collectionViewHeader: UICollectionView!
    
    @IBOutlet weak var collectionViewNews: UICollectionView!
    
    @IBOutlet weak var tableViewNews: UITableView!
    
    @IBOutlet weak var tableViewNewsHeight: NSLayoutConstraint!
    
    @IBOutlet weak var collectionViewNewsHeight: NSLayoutConstraint!
    
    @IBOutlet weak var headerView1: UIView!
    
    @IBOutlet weak var headerView2: UIView!
    @IBOutlet weak var lblHeader1: UILabel!
    @IBOutlet weak var lblHeader2: UILabel!
    
    @IBOutlet weak var emptyView: UIView!
    //MARK: - Variables
    var tableViewNewsObserver: NSKeyValueObservation?
    var collectionViewNewsObserver: NSKeyValueObservation?
    var headers = ["News","Video"]
    var selectedHeaderIndex = 0
    var viewModel = NewsViewModel()
    var newsPage = 1
    var videoPage = 1
    var refreshControl:UIRefreshControl?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        intialSettings()
    }

    func setupNavBar(){
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        btn.setImage(UIImage(named: "menu"), for: .normal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btn)
        
    }
    
    func intialSettings(){
        setupNavBar()
        collectionViewHeader.registerCell(identifier: "SelectionCollectionViewCell")
        collectionViewNews.registerCell(identifier: "VideoHeighlightsCollectionViewCell")
        collectionViewNews.registerCell(identifier: "NewsGamesCollectionViewCell")
        
        tableViewNews.register(UINib(nibName: "NewsTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        tableViewNews.register(UINib(nibName: "HeighlightsTableViewCell", bundle: nil), forCellReuseIdentifier: "cell1")
        
        tableViewNewsObserver = tableViewNews.observe(\.contentSize, options: .new) { (_, change) in
            guard let height = change.newValue?.height else { return }
            self.tableViewNewsHeight.constant = height
        }
        
        collectionViewNewsObserver = collectionViewNews.observe(\.contentSize, options: .new) { (_, change) in
            guard let height = change.newValue?.height else { return }
            self.collectionViewNewsHeight.constant = height
        }
        collectionViewHeader.selectItem(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .left)
        refreshControl = UIRefreshControl()
        refreshControl?.tintColor = .clear
        refreshControl?.addTarget(self, action: #selector(refreshViews), for: .valueChanged)
        tableViewNews.refreshControl = refreshControl
        setupViews()
        viewModel.delegate = self
        viewModel.getNews(page: newsPage)
        viewModel.getVideos(page: videoPage)
        
        
    }
    
    func setupViews(){
        if selectedHeaderIndex == 0{
            lblHeader1.text = "Trending"
            lblHeader2.text = "Recommended for you"
        }else{
            lblHeader1.text = "Match Highlights"
            lblHeader2.text = "Latest Videos"
        }
        collectionViewNews.reloadData()
        tableViewNews.reloadData()
    }
    
    @objc func refreshViews(){
        newsPage = 1
        videoPage = 1
        viewModel.getNews(page: newsPage)
        viewModel.getVideos(page: videoPage)
    }

}

//MARK: NewsViewModelDelegates
extension NewsViewController:NewsViewModelDelegates{
    
func didFinishFetchNews() {
    newsPage += 1
    tableViewNews.reloadData()
    collectionViewNews.reloadData()
    if viewModel.newsList?.count ?? 0 > 0{
        emptyView.isHidden = true
    }
    else{
        emptyView.isHidden = false
    }
    
}

func didFinishFetchVideos() {
    videoPage += 1
    tableViewNews.reloadData()
    collectionViewNews.reloadData()
    if viewModel.videoList?.count ?? 0 > 0{
        emptyView.isHidden = true
    }
    else{
        emptyView.isHidden = false
    }
    
}
}

