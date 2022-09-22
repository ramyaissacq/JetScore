//
//  EventsHomeTableViewCell.swift
//  775775Sports
//
//  Created by Remya on 9/13/22.
//

import UIKit

class EventsHomeTableViewCell: UITableViewCell {
    @IBOutlet weak var lblEvent: UILabel!
    @IBOutlet weak var imgType: UIImageView!
    @IBOutlet weak var lblTime: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(index:Int,obj:Event?){
        lblEvent.text = "\(obj?.nameEn ?? "") (\(EventsHomeTableViewCell.getType(kind: obj?.kind ?? 0)))"
        lblTime.text = obj?.time
        imgType.image = EventsHomeTableViewCell.getEventSectionImage(index: index)
    }
    
    static func getEventSectionImage(index:Int)->UIImage?{
        switch index{
        case 0:
            return UIImage(named: "goal")
        case 1:
            return UIImage(named: "subsitute")
        case 2:
            return UIImage(named: "whistle")
        default:
            return nil
        }
        
    }
    
    static func getType(kind:Int) -> String{
        switch kind{
        case 1:
            return "Goal"
        case 2:
            return "Red card"
        case 3:
            return "Yellow card"
        case 7:
            return "Penalty kick"
        case 8:
            return "Own goals"
        case 9:
            return "Two yellow to red"
        case 11:
            return "Substitution"
        case 13:
            return "Missed Penalty"
        default:
            return ""
        }
    }
    
   
    
  
}
