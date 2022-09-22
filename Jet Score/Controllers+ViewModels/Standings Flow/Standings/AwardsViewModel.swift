//
//  AwardsViewModel.swift
//  775775Sports
//
//  Created by Remya on 9/9/22.
//

import Foundation

protocol AwardsViewModeldelegate{
    func didFinishTeamStandingsFetch()
    func didFinishPlayerStandingsFetch()
}

class AwardsViewModel{
    var delegate:AwardsViewModeldelegate?
    var teamStandings:TeamStandingsResponse?
    var playerStandings:[PlayerStandings]?
    
    func getTeamStandings(leagueID:Int,subLeagueID:Int){
        Utility.showProgress()
        AwardsAPI().getTeamStandingsList(leagueID: leagueID, subLeagueID: subLeagueID) { response in
            self.teamStandings = response
            self.delegate?.didFinishTeamStandingsFetch()
        } failed: { msg in
            Utility.showErrorSnackView(message: msg)
        }

    }
    
    func getPlayerStandings(leagueID:Int){
        Utility.showProgress()
        AwardsAPI().getPlayerStandingsList(leagueID: leagueID, subLeagueID: 0) { response in
            self.playerStandings = response.list
            self.delegate?.didFinishPlayerStandingsFetch()
        } failed: { msg in
            Utility.showErrorSnackView(message: msg)
        }

    }
    
    //Methods for handling teamstandings display
    
    func getTeamRowByIndex(index:Int)->[String]{
        var standings = [String]()
        let obj = teamStandings?.totalStandings?[index]
        standings.append("\(obj?.rank ?? 0)")
        var team = ""
        if let teamID = obj?.teamId{
            let teamObj = teamStandings?.teamInfo?.filter{$0.teamId == teamID}.first
            team = (teamObj?.nameEn ?? "") + "," + (teamObj?.flag ?? "")
        }
        standings.append(team)
        standings.append("\(obj?.totalCount ?? 0)")
        standings.append("\(obj?.winCount ?? 0)")
        standings.append("\(obj?.drawCount ?? 0)")
        standings.append("\(obj?.loseCount ?? 0)")
        standings.append("\(obj?.getScore ?? 0)")
        standings.append("\(obj?.loseScore ?? 0)")
        standings.append("\(obj?.integral ?? 0)")
        
        return standings
    }
    
    func getResultsPercentageStringByIndex(index:Int)->String{
        let obj = teamStandings?.totalStandings?[index]
        let percentageString = "W%=\(obj?.winRate ?? "")% / L%=\(obj?.loseRate ?? "")% / AVA=\(obj?.loseAverage ?? 0) / D%=\(obj?.drawRate ?? "")% / AVF=\(obj?.winAverage ?? 0)"
        return percentageString
    }
    
    func getResultsArrayByIndex(index:Int)->[String]{
        var results = [String]()
        let obj = teamStandings?.totalStandings?[index]
        if let status = Int(obj?.recentFirstResult ?? ""){
            results.append(getStatusName(status: status))
        }
        if let status = Int(obj?.recentSecondResult ?? ""){
            results.append(getStatusName(status: status))
        }
        if let status = Int(obj?.recentThirdResult ?? ""){
            results.append(getStatusName(status: status))
        }
        if let status = Int(obj?.recentFourthResult ?? ""){
            results.append(getStatusName(status: status))
        }
        if let status = Int(obj?.recentFifthResult ?? ""){
            results.append(getStatusName(status: status))
        }
        if let status = Int(obj?.recentSixthResult ?? ""){
            results.append(getStatusName(status: status))
        }
        return results
    }
    
    func getStatusName(status:Int)->String{
        switch status{
        case 0:
            return "W"
        case 1:
            return "D"
        case 2:
            return "L"
        case 3:
            return "TBD"
        default:
            return ""
        }
    }
    
    //Methods for handling player standings display
    
    func getPlayerRowByIndex(index:Int)->[String]{
        var standings = [String]()
        let obj = playerStandings?[index]
        standings.append("\(index+1)")
        standings.append(obj?.teamNameEn ?? "")
        standings.append(obj?.playerNameEn ?? "")
        standings.append("\(obj?.goals ?? 0)")
        standings.append("\(obj?.homeGoals ?? 0)")
        standings.append("\(obj?.awayGoals ?? 0)")
        return standings
    }
    
    func getPlayerPointsByIndex(index:Int)->[String]{
        var points = [String]()
        let obj = playerStandings?[index]
        points.append("Home Penalty : \(obj?.homePenalty ?? 0)")
        points.append("Away Penalty : \(obj?.awayPenalty ?? 0)")
        points.append("Match Number : \(obj?.matchNum ?? 0)")
        points.append("Sub Number : \(obj?.subNum ?? 0)")
        return points
    }
    
}
