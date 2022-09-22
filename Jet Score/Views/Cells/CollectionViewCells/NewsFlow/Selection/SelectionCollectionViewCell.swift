//
//  SelectionCollectionViewCell.swift
//  775775Sports
//
//  Created by Remya on 9/1/22.
//

import UIKit

class SelectionCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var underLineView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var stack: UIStackView!
    
    var callSelection:(()->Void)?
    var underLineColor:UIColor?{
        didSet{
            underLineView.backgroundColor = underLineColor
        }
    }
    
    var titleColor:UIColor?{
        didSet{
            lblTitle.textColor = .black
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        let tap = UITapGestureRecognizer(target: self, action: #selector(tapCall))
//        stack.addGestureRecognizer(tap)
    }
    
    override var isSelected: Bool{
        didSet{
          handleSelection()
        }
        
    }
    
    @objc func tapCall(){
         callSelection?()
    }
    
    func handleSelection(){
        if isSelected{
            self.underLineView.isHidden = false
        }
        else{
            self.underLineView.isHidden = true
        }
    }

}
