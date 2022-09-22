//
//  FootballLeague.swift
//  775775Sports
//
//  Created by Remya on 9/9/22.
//

import Foundation

class FootballLeague{
    let id:Int?
    let name:String?
        init(id:Int,name:String){
            self.id = id
            self.name = name
        }
        static var leagues:[FootballLeague]?

        static func populateFootballLeagues(){
            if leagues?.count ?? 0 == 0{
            let ids = [36,31,34,8,11,60,192,648,652,650,75,67,88,224]
            let names = ["Premier League", "La Liga", "Serie A","Bundesliga", "Ligue 1", "Chinese Super League", "AFC Champions League", "Asian Qualifiers", "South American Qualifier", "European Qualifier", "World Cup", "European Cup", "Confederations Cup", " America's Cup"]
            var leagues = [FootballLeague]()
            for i in 0 ... ids.count - 1{
                let obj = FootballLeague(id: ids[i], name: names[i])
                leagues.append(obj)
            }
            FootballLeague.leagues = leagues
            }
        }
        
       
    
}
