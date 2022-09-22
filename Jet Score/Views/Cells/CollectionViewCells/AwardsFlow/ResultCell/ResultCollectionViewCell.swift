//
//  ResultCollectionViewCell.swift
//  775775Sports
//
//  Created by Remya on 9/3/22.
//

import UIKit

class ResultCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var backView:UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(status:String){
        lblTitle.text = status
        backView.backgroundColor = getColor(status: status)
    }
    
    func getColor(status:String)->UIColor?{
        switch status{
        case "L":
            return UIColor(named: "red1")
        case "W":
            return UIColor(named: "blue4")
        case "D":
            return UIColor(named: "brown")
        case "TBD":
            return UIColor(named: "green1")
            
        default:
            return UIColor(named: "green1")
        }
    }

}
