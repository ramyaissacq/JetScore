//
//  FoodballCompany.swift
//  775775Sports
//
//  Created by Remya on 9/8/22.
//

import Foundation

struct FootballCompany{
let id:Int?
let name:String?
    init(id:Int,name:String){
        self.id = id
        self.name = name
    }
    static var companies:[FootballCompany]?

    static func populateFootballCompanies(){
        let ids = [1,3,4,7,8,9,12,14,17,19,22,23,24,31,35,42,45,47,48]
        let names = ["Macauslot","Crown","Ladbrokes","SNAI","Bet365","William Hill","Easybets","Vcbet","Mansion88","Interwetten","10BET","188Bet","12bet","SBOBET","Wewbet","18bet","ManbetX","Pinnacle","HK Jockey Club"]
        var companies = [FootballCompany]()
        for i in 0 ... ids.count - 1{
            let obj = FootballCompany(id: ids[i], name: names[i])
            companies.append(obj)
        }
        FootballCompany.companies = companies
    }
    
    static func getCompanyName(id:Int)->String?{
       return companies?.filter{$0.id == id}.first?.name
        
    }
    
}
