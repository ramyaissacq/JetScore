//
//  BriefingViewController.swift
//  775775Sports
//
//  Created by Remya on 9/14/22.
//

import UIKit

class BriefingViewController: UIViewController {
    @IBOutlet weak var textView:UITextView!
    
    //MARK: - Variables
    var viewModel = BreifingViewModel()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()

    }
    
    func initialSetup(){
        viewModel.delegate = self
        viewModel.getBriefingDetails()
    }
    


}

extension BriefingViewController:BreifingViewModelDelegate{
    func didFinishFetch() {
        textView.attributedText = viewModel.briefingData?.recommendEn?.htmlToAttributedString
    }
    
    
}
