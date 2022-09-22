//
//  HomeViewController.swift
//  775775Sports
//
//  Created by Remya on 9/2/22.
//

import UIKit
import DropDown

enum SportsType{
    case soccer
    case basketball
}

class HomeViewController: BaseViewController {
    //MARK: - IBOutlets
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var collectionViewCategory: UICollectionView!
    @IBOutlet weak var noDataView: UIView!
    @IBOutlet weak var leagueView: UIView!
    @IBOutlet weak var timeView: UIView!
    @IBOutlet weak var lblLeague: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var highlightsStack: UIStackView!
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var collectionViewHighlights: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    //MARK: - Variables
    var viewModel = HomeVieModel()
    var page = 1
    var refreshControl:UIRefreshControl?
    var categorySizes = [CGFloat]()
    var selectedType = 0
    var leagueDropDown:DropDown?
    var timeDropDown:DropDown?
    var selectedLeagueID:Int?
    var selectedTimeIndex = 0
    var selectedDate = ""
    var longPressId:Int?
    var current = 0
    var selectedSportsType = SportsType.soccer
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSettings()
    }
    
    //IBActions
    @IBAction func actionTapSoccer(){
        selectedSportsType = SportsType.soccer
        if AppPreferences.getMatchHighlights().count > 0{
            highlightsStack.isHidden = false
        }
        prepareDisplays()
        
    }
    
    @IBAction func actionTapBasketball(){
        selectedSportsType = SportsType.basketball
        highlightsStack.isHidden = true
        prepareDisplays()
    }
    
    
    func initialSettings(){
        
        UNUserNotificationCenter.current().delegate = self
        Utility.scheduleLocalNotificationNow(time: 1, title: "Hon Kong Vs Myanmar", subTitle: "", body: "Scores - 2:1, C - 3:1, HT - 1:0")
        Utility.scheduleLocalNotificationNow(time: 5, title: "Hon Kong Vs Myanmar", subTitle: "GOAL!!", body: "Scores - 3:1, C - 3:1, HT - 1:0")
        setupNavButtons()
        setupGestures()
        // FootballLeague.populateFootballLeagues()
        configureTimeDropDown()
        configureLeagueDropDown()
        viewModel.categories = viewModel.todayCategories
        collectionViewCategory.registerCell(identifier: "RoundSelectionCollectionViewCell")
        collectionViewHighlights.registerCell(identifier: "HighlightsCollectionViewCell")
        collectionViewCategory.selectItem(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .left)
        tableView.register(UINib(nibName: "ScoresTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        refreshControl = UIRefreshControl()
        refreshControl?.tintColor = .clear
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        if AppPreferences.getMatchHighlights().isEmpty{
            highlightsStack.isHidden = true
        }
        else{
            pageControl.numberOfPages = AppPreferences.getMatchHighlights().count
            highlightsStack.isHidden = false
        }
        
        viewModel.delegate = self
        viewModel.getMatchesList(page: page)
        viewModel.getBasketballScores()
    }
    
    @objc func leftAction(){
        print("Left")
    }
    
    
    func configureLeagueDropDown(){
        leagueDropDown = DropDown()
        leagueDropDown?.anchorView = lblLeague
        //        var arr:[String] = FootballLeague.leagues?.map{"League: " + ($0.name ?? "") } ?? []
        //        arr.insert("All Leagues", at: 0)
        //        leagueDropDown?.dataSource = arr
        //        lblLeague.text = arr.first
        lblLeague.text = "All Leagues"
        leagueDropDown?.selectionAction = { [unowned self] (index: Int, item: String) in
            lblLeague.text = item
            if index == 0{
                selectedLeagueID = nil
                if selectedTimeIndex == 0{
                    page = 1
                    viewModel.getMatchesList(page: page)
                }
            }
            else{
                selectedLeagueID = viewModel.scoreResponse?.todayHotLeague?[index-1].leagueId
                //FootballLeague.leagues?[index-1].id
                viewModel.getMatchesByLeague(leagueID: selectedLeagueID!)
            }
        }
        
    }
    
    
    func configureTimeDropDown(){
        timeDropDown = DropDown()
        timeDropDown?.anchorView = lblTime
        timeDropDown?.dataSource = ["Today","Result","Schedule"]
        lblTime.text = "Today"
        lblHeader.text = "Today"
        timeDropDown?.selectionAction = { [unowned self] (index: Int, item: String) in
            lblTime.text = item
            lblHeader.text = item
            selectedTimeIndex = index
            switch index{
            case 0:
                viewModel.categories = viewModel.todayCategories
                var arr:[String] = viewModel.scoreResponse?.todayHotLeague?.map{$0.leagueName ?? ""} ?? []
                arr.insert("All Leagues", at: 0)
                self.leagueDropDown?.dataSource = arr
                lblLeague.text = arr.first
                page = 1
                viewModel.getMatchesList(page: page)
            case 1:
                viewModel.categories = viewModel.pastDates
                leagueDropDown?.dataSource = ["All Leagues"]
                lblLeague.text = "All Leagues"
            case 2:
                viewModel.categories = viewModel.futureDates
                leagueDropDown?.dataSource = ["All Leagues"]
                lblLeague.text = "All Leagues"
                
            default:
                break
            }
            categorySizes.removeAll()
            collectionViewCategory.reloadData()
            collectionViewCategory.selectItem(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .centeredHorizontally)
            collectionViewCategory.delegate?.collectionView?(collectionViewCategory, didSelectItemAt: IndexPath(row: 0, section: 0))
            
        }
        
    }
    
    func setupGestures(){
        let tapLg = UITapGestureRecognizer(target: self, action: #selector(tapLeague))
        leagueView.addGestureRecognizer(tapLg)
        
        let tapTm = UITapGestureRecognizer(target: self, action: #selector(tapTime))
        timeView.addGestureRecognizer(tapTm)
        
        let left = UISwipeGestureRecognizer(target: self, action: #selector(swipe(sender:)))
        left.direction = .left
        left.delegate = self
        collectionViewHighlights.addGestureRecognizer(left)
        
        let right = UISwipeGestureRecognizer(target: self, action: #selector(swipe(sender:)))
        right.direction = .right
        right.delegate = self
        collectionViewHighlights.addGestureRecognizer(right)
    }
    
    
    @objc func tapLeague(){
        leagueDropDown?.show()
        
    }
    
    @objc func tapTime(){
        timeDropDown?.show()
    }
    
    @objc func swipe(sender:UISwipeGestureRecognizer){
        if sender.direction == .left{
            let total = AppPreferences.getMatchHighlights().count
            if current < (total - 1){
              current += 1
                collectionViewHighlights.scrollToItem(at: IndexPath(row: current, section: 0), at: .centeredHorizontally, animated: true)
                pageControl.currentPage = current
            }
        }
        else{
            if current > 0{
                current -= 1
                collectionViewHighlights.scrollToItem(at: IndexPath(row: current, section: 0), at: .centeredHorizontally, animated: true)
                pageControl.currentPage = current
                
            }
        }
        
    }
    
    @objc func refresh(){
        if selectedTimeIndex == 0 && selectedLeagueID == nil{
            page = 1
            viewModel.getMatchesList(page: page)
            refreshControl?.endRefreshing()
        }
    }
    
    func setupNavButtons(){
        let leftBtn = getButton(image: UIImage(named: "menu")!)
        leftBtn.addTarget(self, action: #selector(menuTapped), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBtn)
        
        let rightBtn = getButton(image: UIImage(named: "search")!)
        rightBtn.addTarget(self, action: #selector(searchTapped), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBtn)
    }
    
    @objc func menuTapped(){
        
    }
    
    @objc func searchTapped(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        vc.viewModel.originals = viewModel.originals
        vc.viewModel.pageData = viewModel.pageData
        vc.page = page
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
}


