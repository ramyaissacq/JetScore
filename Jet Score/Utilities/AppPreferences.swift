

import UIKit
import SwiftyJSON

class AppPreferences {
    private enum Keys : String {
        
//        case token = "Token"
//        case userData = "userData"
       // case APPLE_LANGUAGE_KEY = "AppleLanguages"
        case matchHighlights = "matchHighlights"
        
        
    }
    
    class func addToHighlights(obj:MatchList)
       {
           let userDefaults = UserDefaults.standard
           var matches = getMatchHighlights()
           if !matches.filter({$0.matchId == obj.matchId}).isEmpty{
               matches.remove(at: matches.firstIndex(where: {$0.matchId == obj.matchId})!)
           }
           matches.append(obj)
           var dict = [[String:Any]]()
           for m in matches{
               dict.append(m.toDictionary())
           }
           
           userDefaults.set(dict, forKey: Keys.matchHighlights.rawValue)
       }
   
       class func getMatchHighlights() -> [MatchList]
       {
           let userDefaults = UserDefaults.standard
           var matches = [MatchList]()
           if let matchData = userDefaults.object(forKey: Keys.matchHighlights.rawValue) as? [[String:Any]]
                   {
               for m in matchData{
                   let match = MatchList(JSON(m))
                   matches.append(match)
                 }
                       
                   }
                   return matches
       }
    
//    class func setToken(withToken token: String)
//    {
//        let userDefaults = UserDefaults.standard
//        userDefaults.setValue(token, forKey: Keys.token.rawValue)
//    }
//
//    class func getToken() -> String
//    {
//        let userDefaults = UserDefaults.standard
//        if let token = userDefaults.string(forKey: Keys.token.rawValue)
//        {
//            return token
//        }
//        return ""
//    }
//
//
//
//    class func setUserData(withUserData userData : User){
//        let userDefaults = UserDefaults.standard
//        userDefaults.set(userData.toDictionary(), forKey: Keys.userData.rawValue)
//    }
//
//    class func getUserData() -> User{
//        let userDefaults = UserDefaults.standard
//        if let userData = userDefaults.object(forKey: Keys.userData.rawValue) as? [String:Any]
//        {
//            let userDataModel = User.init(fromJson: JSON(userData))
//            return userDataModel
//        }
//        return User()
//    }
//
//    class func clearPreferences(clear: @escaping () -> Void)
//    {
//        let defaults = UserDefaults.standard
//        let dictionary = defaults.dictionaryRepresentation()
//        dictionary.keys.forEach { key in
//            if(key != Keys.APPLE_LANGUAGE_KEY.rawValue)
//            {
//                defaults.removeObject(forKey: key)
//            }
//        }
//        clear()
//    }
}
