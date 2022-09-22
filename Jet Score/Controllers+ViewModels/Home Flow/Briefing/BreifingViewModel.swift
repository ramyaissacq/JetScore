//
//  BreifingViewModel.swift
//  775775Sports
//
//  Created by Remya on 9/14/22.
//

import Foundation

protocol BreifingViewModelDelegate{
    func didFinishFetch()
}

class BreifingViewModel{
    var delegate:BreifingViewModelDelegate?
    var briefingData:BreiefingResponse?
    
    func getBriefingDetails(){
       // Utility.showProgress()
        HomeAPI().getBriefing(id: HomeCategoryViewController.matchID!) { response in
            self.briefingData = response
            self.delegate?.didFinishFetch()
        } failed: { msg in
            //Utility.showErrorSnackView(message: msg)
        }

    }
    
}
