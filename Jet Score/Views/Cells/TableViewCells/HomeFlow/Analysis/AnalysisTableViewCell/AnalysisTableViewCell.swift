//
//  AnalysisTableViewCell.swift
//  775775Sports
//
//  Created by Remya on 9/12/22.
//

import UIKit

class AnalysisTableViewCell: UITableViewCell {

    @IBOutlet weak var lblCorner: UILabel!
    @IBOutlet weak var lblLeague: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblAway: UILabel!
    @IBOutlet weak var lblHome: UILabel!
    @IBOutlet weak var lblHT: UILabel!
    @IBOutlet weak var lblScore: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(match:String?){
        let arr = match?.components(separatedBy: ",")
        let scoreArray = arr?[9].components(separatedBy: "^")
        let dateArray = arr?[3].components(separatedBy: "^")
        lblLeague.text = arr?[2]
        lblHome.text = arr?[5]
        lblAway.text = arr?[8]
        lblScore.text = "\(scoreArray?[1] ?? "") : \(scoreArray?[2] ?? "")"
        lblCorner.text = "\(scoreArray?[7] ?? "") : \(scoreArray?[8] ?? "")"
        lblHT.text = "\(scoreArray?[3] ?? "") : \(scoreArray?[4] ?? "")"
        lblDate.text = dateArray?[1]
        
    }
    
}
