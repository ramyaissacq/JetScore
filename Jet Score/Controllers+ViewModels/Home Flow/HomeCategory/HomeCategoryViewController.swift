//
//  HomeCategoryViewController.swift
//  775775Sports
//
//  Created by Remya on 9/7/22.
//

import UIKit

enum HomeCategory{
    case index
    case analysis
    case league
    case event
    case breifing
    
}

class HomeCategoryViewController: BaseViewController {
    //MARK: - IBOutlets
    //TopView outlets starts
    @IBOutlet weak var viewIndex: UIView!
    
    @IBOutlet weak var viewAnalysis: UIView!
    
    @IBOutlet weak var viewLeague: UIView!
    
    @IBOutlet weak var viewEvent: UIView!
    
    @IBOutlet weak var viewBriefing: UIView!
    
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var lblHomeName: UILabel!
    
    @IBOutlet weak var lblAwayName: UILabel!
    
    @IBOutlet weak var lblScore: UILabel!
    
    @IBOutlet weak var lblDate: UILabel!
    
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblHalfScore: UILabel!
    @IBOutlet weak var lblCorner: UILabel!
    @IBOutlet weak var lblHandicap1: UILabel!
    @IBOutlet weak var lblHandicap2: UILabel!
    @IBOutlet weak var lblHandicap3: UILabel!
    @IBOutlet weak var lblOverUnder1: UILabel!
    @IBOutlet weak var lblOverUnder2: UILabel!
    @IBOutlet weak var lblOverUnder3: UILabel!
    @IBOutlet weak var indexViewYellow: UIView!
    @IBOutlet weak var odds2Stack: UIStackView!
    @IBOutlet weak var odds1Stack: UIStackView!
    @IBOutlet weak var cornerStack: UIStackView!
    @IBOutlet weak var cornerView: UIView!
    //topView outlets ends..
    
    @IBOutlet weak var indexContainerView: UIView!
    
    @IBOutlet weak var analysisContainerView: UIView!
    
    @IBOutlet weak var eventContainerView: UIView!
    
    @IBOutlet weak var briefingView: UIView!
    
    @IBOutlet weak var leagueView: UIView!
    
    //MARK: - Variables
    static var matchID:Int?
    var selectedMatch:MatchList?
    var selectedCategory = HomeCategory.index
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
       

        // Do any additional setup after loading the view.
    }
    

    func initialSetup(){
        setBackButton()
        configureTopView()
        configureContainers()
        FootballCompany.populateFootballCompanies()
    }
    
    func configureContainers(){
        analysisContainerView.isHidden = true
        eventContainerView.isHidden = true
        briefingView.isHidden = true
        leagueView.isHidden = true
        indexContainerView.isHidden = true
        
        viewAnalysis.backgroundColor = .white
        viewEvent.backgroundColor = .white
        viewBriefing.backgroundColor = .white
        viewLeague.backgroundColor = .white
        viewIndex.backgroundColor = .white
        
        switch selectedCategory{
        case .index:
            indexContainerView.isHidden = false
            viewIndex.backgroundColor = Colors.accentColor()
            
        case .analysis:
            
            analysisContainerView.isHidden = false
            viewAnalysis.backgroundColor = Colors.accentColor()
            
        case .league:
            
            leagueView.isHidden = false
            viewLeague.backgroundColor = Colors.accentColor()
            
        case .event:
           
            eventContainerView.isHidden = false
            viewEvent.backgroundColor = Colors.accentColor()
        case .breifing:
            
            briefingView.isHidden = false
            viewBriefing.backgroundColor = Colors.accentColor()
            
        }
        
    }
    
    
    
    func configureTopView(){
        lblName.text = selectedMatch?.leagueName
        lblHomeName.text = selectedMatch?.homeName
        lblAwayName.text = selectedMatch?.awayName
        lblScore.text = "\(selectedMatch?.homeScore ?? 0 ) : \(selectedMatch?.awayScore ?? 0)"
        let timeDifference = Date() - Utility.getSystemTimeZoneTime(dateString: selectedMatch?.startTime ?? "")
        let mins = ScoresTableViewCell.getMinutesFromTimeInterval(interval: timeDifference)
        lblDate.text = "\(ScoresTableViewCell.getStatus(state: selectedMatch?.state ?? 0)) \(mins)'"
        if selectedMatch?.state == 0{
            lblScore.text = "SOON"
            let date = Utility.getSystemTimeZoneTime(dateString: selectedMatch?.matchTime ?? "")
            lblDate.text = Utility.formatDate(date: date, with: .eddmmm)
        }
        let matchDate = Utility.getSystemTimeZoneTime(dateString: selectedMatch?.matchTime ?? "")
        lblTime.text = Utility.formatDate(date: matchDate, with: .hhmm2)
        lblHalfScore.text = "\(selectedMatch?.homeHalfScore ?? "") : \(selectedMatch?.awayHalfScore ?? "")"
        lblCorner.text = "\(selectedMatch?.homeCorner ?? "") : \(selectedMatch?.awayCorner ?? "")"
        if selectedMatch?.homeHalfScore == "" && selectedMatch?.awayHalfScore == "" && selectedMatch?.homeCorner == "" && selectedMatch?.awayCorner == ""{
            cornerView.isHidden = true
            cornerStack.isHidden = true
        }
        else{
            cornerView.isHidden = false
            cornerStack.isHidden = false
        }
        if selectedMatch?.odds?.handicap?.count ?? 0 > 7{
            lblHandicap1.text = String(selectedMatch?.odds?.handicap?[6] ?? 0)
        lblHandicap2.text = String(selectedMatch?.odds?.handicap?[5] ?? 0)
        lblHandicap3.text = String(selectedMatch?.odds?.handicap?[7] ?? 0)
            odds1Stack.isHidden = false
        }
        else{
            odds1Stack.isHidden = true
        }
        if selectedMatch?.odds?.overUnder?.count ?? 0 > 7{
        lblOverUnder1.text = String(selectedMatch?.odds?.overUnder?[6] ?? 0)
        lblOverUnder2.text = String(selectedMatch?.odds?.overUnder?[5] ?? 0)
        lblOverUnder3.text = String(selectedMatch?.odds?.overUnder?[7] ?? 0)
            odds2Stack.isHidden = false
        }
        else{
            odds2Stack.isHidden = true
        }
        if (selectedMatch?.odds?.overUnder?.isEmpty ?? true) && (selectedMatch?.odds?.handicap?.isEmpty ?? true){
            indexViewYellow.isHidden = true
        }
        else{
            indexViewYellow.isHidden = false
        }
        
        if selectedMatch?.havOdds ?? false{
            viewIndex.isHidden = false
        }
        else{
            viewIndex.isHidden = true
            
        }
        
        if selectedMatch?.havEvent ?? false{
            viewEvent.isHidden = false
        }
        else{
            viewEvent.isHidden = true
            
        }
        
        if selectedMatch?.havBriefing ?? false{
            viewBriefing.isHidden = false
        }
        else{
            viewBriefing.isHidden = true
            
        }
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(indexTapped))
        viewIndex.addGestureRecognizer(tap)
        
        let tapAnls = UITapGestureRecognizer(target: self, action: #selector(analysisTapped))
        viewAnalysis.addGestureRecognizer(tapAnls)
        
        let tapEvnt = UITapGestureRecognizer(target: self, action: #selector(eventTapped))
        viewEvent.addGestureRecognizer(tapEvnt)
        
        let tapBrf = UITapGestureRecognizer(target: self, action: #selector(briefingTapped))
        viewBriefing.addGestureRecognizer(tapBrf)
        
        let tapLg = UITapGestureRecognizer(target: self, action: #selector(leagueTapped))
        viewLeague.addGestureRecognizer(tapLg)
    }
    
    
    @objc func indexTapped(){
        selectedCategory = .index
        configureContainers()
    }
    @objc func eventTapped(){
        selectedCategory = .event
        configureContainers()
    }
    @objc func leagueTapped(){
        selectedCategory = .league
        configureContainers()
    }
    @objc func analysisTapped(){
        selectedCategory = .analysis
        configureContainers()
    }
    @objc func briefingTapped(){
        selectedCategory = .breifing
        configureContainers()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEvents"{
            let vc = segue.destination as? EventViewController
                vc?.homeName = selectedMatch?.homeName
                vc?.awayName = selectedMatch?.awayName
            
        }
        else if segue.identifier == "league"{
            let vc = segue.destination as? LeagueViewController
            vc?.groupID = selectedMatch?.groupId ?? 0
            vc?.leagueID = selectedMatch?.leagueId ?? 0
            vc?.subLeagueID = Int(selectedMatch?.subLeagueId ?? "") ?? 0
            
    }
    }
    

}
