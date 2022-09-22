//
//  AnalysisViewModel.swift
//  775775Sports
//
//  Created by Remya on 9/12/22.
//

import Foundation

protocol AnalysisViewModelDelegate{
    func didFinishFetch()
}

class AnalysisViewModel{
    var delegate:AnalysisViewModelDelegate?
    var analysisData:ScoreAnalysis?
    
    func fetchAnalysisData(){
        //Utility.showProgress()
        HomeAPI().getScoresByAnalysis(id: HomeCategoryViewController.matchID!) { response in
            self.analysisData = response.list?.first
            if self.analysisData?.homeOdds?.count ?? 0 > 3{
            self.analysisData?.homeOdds?.remove(at: 3)
            }
            if self.analysisData?.awayOdds?.count ?? 0 > 3{
            self.analysisData?.awayOdds?.remove(at: 3)
            }
            self.delegate?.didFinishFetch()
            
        } failed: { msg in
            //Utility.showErrorSnackView(message: msg)
        }

    }
    
}
