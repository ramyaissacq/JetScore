//
//  ScoresView.swift
//  775775Sports
//
//  Created by Remya on 9/12/22.
//

import UIKit



class ScoresView: UIView {
    @IBOutlet var contentView: UIView!
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
    
    var callBackIndex:(()->Void)?
    var callBackEvent:(()->Void)?
    var callBackLeague:(()->Void)?
    var callBackAnalysis:(()->Void)?
    var callBackBreifing:(()->Void)?
    
    
    override init(frame: CGRect) {
           super.init(frame: frame)
           commonInit()
       }
       
       required init?(coder aDecoder: NSCoder) {
           super.init(coder: aDecoder)
           commonInit()
       }
       
       func commonInit() {
           Bundle.main.loadNibNamed("ScoresView", owner: self, options: nil)
           contentView.fixInView(self)
       }
    
    func configureView(obj:MatchList?){
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
       callBackIndex?()
    }
    @objc func eventTapped(){
        callBackEvent?()
    }
    @objc func leagueTapped(){
       callBackLeague?()
    }
    @objc func analysisTapped(){
        callBackAnalysis?()
    }
    @objc func briefingTapped(){
        callBackBreifing?()
    }
    
}


extension UIView
{
    func fixInView(_ container: UIView!) -> Void{
        self.translatesAutoresizingMaskIntoConstraints = false;
        self.frame = container.frame;
        container.addSubview(self);
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }
}
