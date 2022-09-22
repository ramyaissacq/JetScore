//
//  AwardsViewController.swift
//  775775Sports
//
//  Created by Remya on 9/2/22.
//

import UIKit
import DropDown

class AwardsViewController: BaseViewController {
    //MARK: - IBOutlets
    @IBOutlet weak var lblSports: UILabel!
    @IBOutlet weak var lblLeague: UILabel!
    @IBOutlet weak var collectionViewTop: UICollectionView!
    @IBOutlet weak var collectionViewHeading: UICollectionView!
    @IBOutlet weak var tableViewStandings: UITableView!
    @IBOutlet weak var tableViewStandingsHeight: NSLayoutConstraint!
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var lblSelectedLeague: UILabel!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var leagueView: UIView!
    
    //MARK: - Variables
    var tableViewStandingsObserver: NSKeyValueObservation?
    var topTitles = ["Team Standings","Player Standings"]
    var headings1 = ["Ranking","Team Name","MP","W","D","L","GF","GA","PTs","More"]
    var headings2 = ["Rank","Team Name","Player Name","Goals","Home","Away","More"]
    var firstHeaderSizes = [CGFloat]()
    var secondHeaderSizes = [CGFloat]()
    var headers = [String]()
    var headerSizes = [CGFloat]()
    var selectedTopTitleIndex = 0
    var sportsDropDown:DropDown?
    var leagueDropDown:DropDown?
    static var selectedPlayerMoreIndices = [Int]()
    static var selectedTeamMoreIndices = [Int]()
    var selectedLeagueID:Int?
    var viewModel = AwardsViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        initialSettings()

    }
    
    //MARK: - IBActions
    
    @IBAction func actionTapSports(_ sender: Any) {
        sportsDropDown?.show()
    }
    
    
    @IBAction func actionTapLeague(_ sender: Any) {
        leagueDropDown?.show()
        
    }
    
    func initialSettings(){
        FootballLeague.populateFootballLeagues()
        configureSportsDropDown()
        configureLeagueDropDown()
        lblSports.text = "Football"
        lblLeague.text = FootballLeague.leagues?.first?.name
        selectedLeagueID = FootballLeague.leagues?.first?.id
        headers = headings1
        collectionViewTop.registerCell(identifier: "SelectionCollectionViewCell")
        collectionViewHeading.registerCell(identifier: "TitleCollectionViewCell")
        tableViewStandings.register(UINib(nibName: "StandingsTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        tableViewStandingsObserver = tableViewStandings.observe(\.contentSize, options: .new) { (_, change) in
            guard let height = change.newValue?.height else { return }
            self.tableViewStandingsHeight.constant = height
        }
        collectionViewTop.selectItem(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .left)
        
        //Calculating cell widths for headings1
        firstHeaderSizes = [40,85,15,15,15,15,15,15,20,25]
        var itemSpacing:CGFloat = CGFloat((headings1.count - 1) * 5)
        var total_widths:CGFloat = firstHeaderSizes.reduce(0, +)
        var totalSpace:CGFloat = total_widths + itemSpacing
        var balance = (UIScreen.main.bounds.width - totalSpace)/CGFloat(headings1.count)
        firstHeaderSizes = firstHeaderSizes.map{$0+balance}
        headerSizes = firstHeaderSizes
        
        //Calculating cell widths for headings2
        secondHeaderSizes = [25,85,85,25,25,25,25]
       itemSpacing = CGFloat((headings2.count - 1) * 5)
        total_widths = secondHeaderSizes.reduce(0, +)
        totalSpace = total_widths + itemSpacing
        balance = (UIScreen.main.bounds.width - totalSpace)/CGFloat(headings2.count)
        secondHeaderSizes = secondHeaderSizes.map{$0+balance}
        viewModel.delegate = self
        viewModel.getTeamStandings(leagueID: selectedLeagueID!, subLeagueID: 0)
        viewModel.getPlayerStandings(leagueID: selectedLeagueID!)
        
    }
    
    func setupViews(){
        if selectedTopTitleIndex == 0{
            headers = headings1
            headerSizes = firstHeaderSizes
            imgLogo.isHidden = false
            
        }
        else{
            headers = headings2
            headerSizes = secondHeaderSizes
            imgLogo.isHidden = true
            
        }
        collectionViewHeading.reloadData()
        tableViewStandings.reloadData()
        emptyChecks()
        
    }
    
    func emptyChecks(){
        if selectedTopTitleIndex == 0{
            if viewModel.teamStandings?.totalStandings?.count ?? 0 > 0{
                collectionViewHeading.isHidden = false
                tableViewStandings.isHidden = false
                leagueView.isHidden = false
                emptyView.isHidden = true
            }
            else{
                collectionViewHeading.isHidden = true
                tableViewStandings.isHidden = true
                leagueView.isHidden = true
                emptyView.isHidden = false
                
            }
        }
        else{
            if viewModel.playerStandings?.count ?? 0 > 0{
                collectionViewHeading.isHidden = false
                tableViewStandings.isHidden = false
                leagueView.isHidden = false
                emptyView.isHidden = true
            }
            else{
                collectionViewHeading.isHidden = true
                tableViewStandings.isHidden = true
                leagueView.isHidden = true
                emptyView.isHidden = false
                
            }
        }
        
    }
    
    func configureSportsDropDown(){
        sportsDropDown = DropDown()
        sportsDropDown?.dataSource = ["Football"]
        sportsDropDown?.anchorView = lblSports
        sportsDropDown?.selectionAction = { [unowned self] (index: Int, item: String) in
          print("Selected item: \(item) at index: \(index)")
            lblSports.text = item
        }
    }
    
    func configureLeagueDropDown(){
        leagueDropDown = DropDown()
        leagueDropDown?.dataSource = FootballLeague.leagues?.map{$0.name ?? ""} ?? []
        leagueDropDown?.anchorView = lblLeague
        leagueDropDown?.selectionAction = { [unowned self] (index: Int, item: String) in
          print("Selected item: \(item) at index: \(index)")
            lblLeague.text = item
            selectedLeagueID = FootballLeague.leagues?[index].id
            viewModel.getTeamStandings(leagueID: selectedLeagueID!, subLeagueID: 0)
            viewModel.getPlayerStandings(leagueID: selectedLeagueID!)
        }
    }
    

}

