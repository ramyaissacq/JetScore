//
//  EventTechnicTableViewCell.swift
//  775775Sports
//
//  Created by Remya on 9/13/22.
//

import UIKit

class EventTechnicTableViewCell: UITableViewCell {

    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAwayCount: UILabel!
    @IBOutlet weak var lblHomeCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(obj:EventTechnic?){
        lblName.text = EventTechnicTableViewCell.getTechnicName(index: obj?.id ?? 0)
        if obj?.type == .percent{
        lblHomeCount.text = "\(obj?.homeCount ?? 0) %"
        lblAwayCount.text = "\(obj?.awayCount ?? 0) %"
        }
        else{
            lblHomeCount.text = "\(obj?.homeCount ?? 0)"
            lblAwayCount.text = "\(obj?.awayCount ?? 0)"
        }
        let tot = (obj?.homeCount ?? 0) + (obj?.awayCount ?? 0)
        let per:Float = Float(obj?.homeCount ?? 0) / Float(tot)
        progressView.progress = per
        
    }
    
    static func getTechnicName(index:Int)->String{
        switch index{
        case 1:
            return "Tee off First"
        case 2:
            return "First Corner Kick"
        case 3:
            return "First Yellow Card"
        case 4:
            return "Number of Shots"
        case 5:
            return "Number of Shots on target"
        case 6:
            return "Number of Fouls"
        case 7:
            return "Number of Corners"
        case 8:
            return "Number of Corners (Overtime)"
        case 9:
            return "Free Kicks"
        case 10:
            return "Number of Offsides"
        case 11:
            return  "Own Goals"
        case 12:
            return "Yellow Cards"
        case 13:
            return "Yellow Cards (Overtime)"
        case 14:
            return  "Red Cards"
        case 15:
            return  "Ball Control"
        case 16:
            return  "Header"
        case 17:
            return  "Save the Ball"
        case 18:
            return  "Goalkeeper Strikes"
        case 19:
            return  "Lose the Ball"
        case 20:
            return "Successful Steal"
        case 21:
            return  "Block"
        case 22:
            return  "Long Pass"
        case 23:
            return  "Short Pass"
        case 24:
            return  "Assist"
        case 25:
            return  "Successful Pass"
        case 26:
            return  "First Substitution"
        case 27:
            return  "Last Substitution"
        case 28:
            return  "First Offside"
        case 29:
            return  "Last Offside"
        case 30:
            return  "Change the number of players"
        case 31:
            return   "Last Corner Kick"
        case 32:
            return  "Last Yellow Card"
        case 33:
            return "Change The number of players (Overtime)"
        case 34:
            return  "Number of Offsides (Overtime)"
        case 35:
            return  "Missing a Goal"
        case 36:
            return  "Middle Column"
        case 37:
            return  "Number of Successful headers"
        case 38:
            return  "Blocked Shots"
        case 39:
            return   "Tackles"
        case 40:
            return  "Exceeding Times"
        case 41:
            return  "Out-of-Bounds"
        case 42:
            return  "Number of Passes"
        case 43:
            return  "Pass Success Rate"
        case 44:
            return  "Number of Attacks"
        case 45:
            return  "Number of Dangerous Attacks"
        case 46:
            return  "Half-Time Corner Kick"
        case 47:
            return  "Half Court Possession"
            
        default:
            return ""
        }
    }
    
}
