//
//  LeagueViewModel.swift
//  775775Sports
//
//  Created by Remya on 9/14/22.
//

import Foundation
import SwiftyJSON

protocol LeagueViewModelProtocol{
    func didFinishFetch()
}
class LeagueViewModel{
    var delegate:LeagueViewModelProtocol?
    var leaguDetails:LeagueResponse?
    var leagueInfoArray:[League]?
    var normalStandings:TeamStandingsResponse?
    var leaguStanding:LeagueStanding?
    var isNormalStanding = true
    
    func getLeagueDetails(id:Int,subID:Int,grpID:Int){
       // Utility.showProgress()
        HomeAPI().getLeagueDetails(id: id, subID: subID, grpID: grpID) { json in
            let leagueJson = json?["leagueStanding"]
            self.analyseResponseJson(json: leagueJson)
            self.leaguDetails = LeagueResponse(json!)
            self.populateData()
            self.delegate?.didFinishFetch()
        } failed: { _ in
            
        }

    }
    
    func analyseResponseJson(json:JSON?){
        if json?.arrayValue.first?["totalStandings"].isEmpty ?? true{
            print("Empty json")
            leaguStanding = json?.arrayValue.map { LeagueStanding($0) }.first
            isNormalStanding = false
        }
        else{
        normalStandings =  json?.arrayValue.map { TeamStandingsResponse($0) }.first
            isNormalStanding = true
        }
    }
    
    
    
    func populateData(){
        var tmpArr = [League]()
        let keys = ["Full Name :","Abbreviation :","Type :","Current Sub-League :","Total Rounds :","Current Round :","Current Season :","Country :"]
        var values = [String]()
        values.append(leaguDetails?.leagueData01?.first?.nameEn ?? "")
        values.append(leaguDetails?.leagueData01?.first?.nameEnShort ?? "")
        values.append("League")
        values.append(leaguDetails?.leagueData02?.first?.subNameEn ?? "")
        values.append(leaguDetails?.leagueData02?.first?.totalRound ?? "")
        values.append(leaguDetails?.leagueData02?.first?.currentRound ?? "")
        values.append(leaguDetails?.leagueData02?.first?.currentSeason ?? "")
        values.append(leaguDetails?.leagueData01?.first?.countryEn ?? "")
        
        for i in 0...values.count-1{
            let obj = League(key: keys[i], value: values[i])
            tmpArr.append(obj)
        }
        leagueInfoArray = tmpArr
        
    }
    
    //Methods for handling teamstandings display
    func getTeamRowByIndex(index:Int)->[String]{
        var standings = [String]()
        let obj = normalStandings?.totalStandings?[index]
        standings.append("\(obj?.rank ?? 0)")
        var team = ""
        if let teamID = obj?.teamId{
            let teamObj = normalStandings?.teamInfo?.filter{$0.teamId == teamID}.first
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
        let obj = normalStandings?.totalStandings?[index]
        let percentageString = "W%=\(obj?.winRate ?? "")% / L%=\(obj?.loseRate ?? "")% / AVA=\(obj?.loseAverage ?? 0) / D%=\(obj?.drawRate ?? "")% / AVF=\(obj?.winAverage ?? 0)"
        return percentageString
    }
    
    func getResultsArrayByIndex(index:Int)->[String]{
        var results = [String]()
        let obj = normalStandings?.totalStandings?[index]
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
    
    
    //Methods for handling rare standing onject display
    func getRareStandingRowByIndex(section:Int,row:Int)->[String]{
        var standings = [String]()
        let obj = leaguStanding?.list?.first?.score?.first?.groupScore?[section].scoreItems?[row]
        standings.append(obj?.rank ?? "0")
        standings.append(obj?.teamNameEn ?? "")
        standings.append(obj?.totalCount ?? "0")
        standings.append(obj?.winCount ?? "0")
        standings.append(obj?.drawCount ?? "0")
        standings.append(obj?.loseCount ?? "0")
        standings.append(obj?.getScore ?? "0")
        standings.append(obj?.loseScore ?? "0")
        standings.append(obj?.integral ?? "0")
        
        return standings
    }
    
    func getGroupName(section:Int)->String?{
        let obj = leaguStanding?.list?.first?.score?.first?.groupScore?[section]
        return obj?.groupEn
        
    }
}
