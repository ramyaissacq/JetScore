//
//  ScoresTableViewCell.swift
//  775775Sports
//
//  Created by Remya on 9/5/22.
//

import UIKit


class ScoresTableViewCell: UITableViewCell {
    //MARK: - IBOutlets
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
    
    @IBOutlet weak var quartersStack: UIStackView!
    @IBOutlet weak var tableViewQuarters: UITableView!
    
    //MARK: - Variables
    var callIndexSelection:(()->Void)?
    var callAnalysisSelection:(()->Void)?
    var callEventSelection:(()->Void)?
    var callBriefingSelection:(()->Void)?
    var callLeagueSelection:(()->Void)?
    var callLongPress:(()->Void)?
    var quarters = ["","1Q","2Q","3Q","4Q","F"]
    var homeScores = [String]()
    var awayScores = [String]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        tableViewQuarters.delegate = self
        tableViewQuarters.dataSource = self
        tableViewQuarters.register(UINib(nibName: "GeneralRowTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapIndex))
        viewIndex.addGestureRecognizer(tap)
        
        let tapAnls = UITapGestureRecognizer(target: self, action: #selector(tapAnalysis))
        viewAnalysis.addGestureRecognizer(tapAnls)
        
        let tapEvnt = UITapGestureRecognizer(target: self, action: #selector(tapEvent))
        viewEvent.addGestureRecognizer(tapEvnt)
        
        let tapBrf = UITapGestureRecognizer(target: self, action: #selector(tapBriefing))
        viewBriefing.addGestureRecognizer(tapBrf)
        
        let tapLg = UITapGestureRecognizer(target: self, action: #selector(tapLeague))
        viewLeague.addGestureRecognizer(tapLg)
        
        let tapLong = UILongPressGestureRecognizer(target: self, action: #selector(actionLongPress))
        self.addGestureRecognizer(tapLong)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func actionLongPress(){
        callLongPress?()
    }
    
    @objc func tapIndex(){
        callIndexSelection?()
        
    }
    
    
    @objc func tapAnalysis(){
        callAnalysisSelection?()
        
    }
    
    @objc func tapEvent(){
        callEventSelection?()
        
    }
    
    @objc func tapBriefing(){
        callBriefingSelection?()
        
    }
    
    @objc func tapLeague(){
        callLeagueSelection?()
        
    }
    
    func configureCell(obj:MatchList?){
        quartersStack.isHidden = true
        cornerStack.isHidden = false
        cornerView.isHidden = false
        lblName.text = obj?.leagueName
        lblHomeName.text = obj?.homeName
        lblAwayName.text = obj?.awayName
        lblScore.text = "\(obj?.homeScore ?? 0 ) : \(obj?.awayScore ?? 0)"
        let timeDifference = Date() - Utility.getSystemTimeZoneTime(dateString: obj?.startTime ?? "")
        let mins = ScoresTableViewCell.getMinutesFromTimeInterval(interval: timeDifference)
        lblDate.text = "\(ScoresTableViewCell.getStatus(state: obj?.state ?? 0)) \(mins)'"
        if obj?.state == 0{
            lblScore.text = "SOON"
            let date = Utility.getSystemTimeZoneTime(dateString: obj?.matchTime ?? "")
            lblDate.text = Utility.formatDate(date: date, with: .eddmmm)
        }
        let matchDate = Utility.getSystemTimeZoneTime(dateString: obj?.matchTime ?? "")
        lblTime.text = Utility.formatDate(date: matchDate, with: .hhmm2)
        lblHalfScore.text = "\(obj?.homeHalfScore ?? "") : \(obj?.awayHalfScore ?? "")"
        lblCorner.text = "\(obj?.homeCorner ?? "") : \(obj?.awayCorner ?? "")"
        if obj?.homeHalfScore == "" && obj?.awayHalfScore == "" && obj?.homeCorner == "" && obj?.awayCorner == ""{
            cornerView.isHidden = true
            cornerStack.isHidden = true
        }
        else{
            cornerView.isHidden = false
            cornerStack.isHidden = false
        }
        
        if obj?.odds?.handicap?.count ?? 0 > 7{
        lblHandicap1.text = String(obj?.odds?.handicap?[6] ?? 0)
        lblHandicap2.text = String(obj?.odds?.handicap?[5] ?? 0)
        lblHandicap3.text = String(obj?.odds?.handicap?[7] ?? 0)
            odds1Stack.isHidden = false
        }
        else{
            odds1Stack.isHidden = true
        }
        if obj?.odds?.overUnder?.count ?? 0 > 7{
        lblOverUnder1.text = String(obj?.odds?.overUnder?[6] ?? 0)
        lblOverUnder2.text = String(obj?.odds?.overUnder?[5] ?? 0)
        lblOverUnder3.text = String(obj?.odds?.overUnder?[7] ?? 0)
            odds2Stack.isHidden = false
        }
        else{
            odds2Stack.isHidden = true
        }
        
        if (obj?.odds?.overUnder?.isEmpty ?? true) && (obj?.odds?.handicap?.isEmpty ?? true){
            indexViewYellow.isHidden = true
        }
        else{
            indexViewYellow.isHidden = false
        }
        if obj?.havOdds ?? false{
            viewIndex.isHidden = false
        }
        else{
            viewIndex.isHidden = true
            
        }
        
        if obj?.havEvent ?? false{
            viewEvent.isHidden = false
        }
        else{
            viewEvent.isHidden = true
            
        }
        
        if obj?.havBriefing ?? false{
            viewBriefing.isHidden = false
        }
        else{
            viewBriefing.isHidden = true
            
        }
        
    }
    
    
    func configureCell(obj:BasketballMatchList?){
        cornerStack.isHidden = true
        cornerView.isHidden = true
        lblName.text = obj?.leagueNameEn
        lblHomeName.text = obj?.homeTeamNameEn
        lblAwayName.text = obj?.awayTeamNameEn
        if obj?.matchState == 0{
            lblScore.text = "SOON"
        }
        else{
        lblScore.text = "\(obj?.homeScore ?? "" ) : \(obj?.awayScore ?? "")"
        }
        let date = Utility.getSystemTimeZoneTime(dateString: obj?.matchTime ?? "")
        lblDate.text = Utility.formatDate(date: date, with: .eddmmm)
        
        let matchDate = Utility.getSystemTimeZoneTime(dateString: obj?.matchTime ?? "")
        lblTime.text = Utility.formatDate(date: matchDate, with: .hhmm2)
       
            lblHandicap1.text = String(obj?.odds?.moneyLineAverage?.liveHomeWinRate ?? 0)
        if obj?.odds?.spread?.count ?? 0 > 9{
            lblHandicap2.text = String(obj?.odds?.spread?[9] ?? 0)
        }
        if obj?.odds?.total?.count ?? 0 > 9{
        lblHandicap3.text = String(obj?.odds?.total?[9] ?? 0)
        }
        
        lblOverUnder1.text = String(obj?.odds?.moneyLineAverage?.liveAwayWinRate ?? 0)
        if obj?.odds?.spread?.count ?? 0 > 10{
        lblOverUnder2.text = String(obj?.odds?.spread?[10] ?? 0)
        }
        if obj?.odds?.total?.count ?? 0 > 10{
        lblOverUnder3.text = String(obj?.odds?.total?[10] ?? 0)
        }
       
        if obj?.havBriefing ?? false{
            viewBriefing.isHidden = false
        }
        else{
            viewBriefing.isHidden = true
            
        }
        homeScores = ["Home",obj?.home1 ?? "",obj?.home2 ?? "",obj?.home3 ?? "",obj?.home4 ?? "",obj?.homeScore ?? ""]
        awayScores = ["Away",obj?.away1 ?? "",obj?.away2 ?? "",obj?.away3 ?? "",obj?.away4 ?? "",obj?.awayScore ?? ""]
        tableViewQuarters.reloadData()
        quartersStack.isHidden = false
        
        
    }
}
    
