//
//  HomeViewModel.swift
//  775775Sports
//
//  Created by Remya on 9/7/22.
//

import Foundation
protocol HomeViewModelDelegate{
    
    func diFinisfFetchMatches()
    func getCurrentPage()->Int
    func didFinishFetchRecentMatches()
    func didFinishFilterByLeague()
    func didFinishFetchBasketballScores()
    
}

class HomeVieModel{
    var delegate:HomeViewModelDelegate?
    var matches:[MatchList]?
    var originals:[MatchList]?
    var pageData:Meta?
    var scoreResponse:ScoresResponse?
    var pastDates = getRecentDates(isPast: true, limit: 10)
    var futureDates = getRecentDates(isPast: false, limit: 10)
    var todayCategories = ["ALL","LIVE","SOON","FT"]
    //,"OTHER"
    var categories = [String]()
    
    //basketball models
    var basketballMatches:[BasketballMatchList]?
    
    
    func getMatchesList(page:Int){
        // Utility.showProgress()
        HomeAPI().getScores(page: page) { response in
            self.scoreResponse = response
            if page > 1 {
                var tempMatches = self.originals ?? []
                tempMatches.append(contentsOf: response.matchList ?? [])
                self.originals = tempMatches
            }
            else{
               
                self.originals?.removeAll()
                self.originals = response.matchList
            }
            self.pageData = response.meta
            self.delegate?.diFinisfFetchMatches()
            print("count::\(self.matches?.count ?? 0)")
        } failed: { msg in
            Utility.showErrorSnackView(message: msg)
        }
        
    }
    
    
    
    func getRecentMatches(date:String){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Utility.dateFormat.ddMMyyyy.rawValue
        let dt = dateFormatter.date(from: date)
        let date = Utility.formatDate(date: dt, with: .yyyyMMdd)
        HomeAPI().getScoresPastFuture(date: date) { response in
            self.matches = response.matchList?.map{MatchList(obj: $0)}
            self.originals = self.matches
            self.delegate?.didFinishFetchRecentMatches()
        } failed: { msg in
            Utility.showErrorSnackView(message: msg)
        }
        
    }
    
    
    func getBasketballScores(){
        HomeAPI().getBasketballScores { response in
            self.basketballMatches = response.matchList
        } failed: { msg in
            Utility.showErrorSnackView(message: msg)
        }

    }
    
    
    
}


extension HomeVieModel{
    func getMatchesByLeague(leagueID:Int){
        self.originals?.removeAll()
        self.matches?.removeAll()
        self.originals = scoreResponse?.todayHotLeagueList?.filter{$0.leagueId == leagueID}
        self.matches = self.originals
        delegate?.didFinishFilterByLeague()
    }
    
    
    func getModelCount(sport:SportsType)->Int{
        if sport == .soccer{
        return matches?.count ?? 0
        }
        else if sport == .basketball{
            return basketballMatches?.count ?? 0
        }
        return 0
    }
    
    func filterMatches(type:Int){
        matches?.removeAll()
        switch type{
        case 0:
            matches = originals
        case 1:
            matches = originals?.filter{!($0.state == 0 || $0.state == -1)}
        case 2:
            matches = originals?.filter{$0.state == 0}
        case 3:
            matches = originals?.filter{$0.state == -1}
            let page = delegate!.getCurrentPage()
            if matches?.count == 0 && page <= (pageData?.lastPage ?? 0){
                getMatchesList(page: page)
                
            }
        default:
            break
        }
        
    }
    
    class func getRecentDates(isPast:Bool,limit:Int) -> [String]{
        let calendar = Calendar.current as NSCalendar
        var dates = [String]()
        if isPast{
            for i in -limit ... -1{
                let dt = calendar.date(byAdding: .day, value: i, to: Date(), options: [])!
                let date = Utility.formatDate(date: dt, with: .ddMMyyyy)
                dates.append(date)
            }
            dates = dates.reversed()
            
        }
        else{
            for i in 1...limit{
                let dt = calendar.date(byAdding: .day, value: i, to: Date(), options: [])!
                let date = Utility.formatDate(date: dt, with: .ddMMyyyy)
                dates.append(date)
            }
            
        }
        
        return dates
        
        
    }
}
