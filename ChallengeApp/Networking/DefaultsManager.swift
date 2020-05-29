//
//  DefaultsManager.swift
//  ChallengeApp
//
//  Created by Michael Sevy on 4/21/20.
//  Copyright © 2020 Michael Sevy. All rights reserved.
//

import Foundation
import Combine


let kDefaultLeagueName      = "defaultLeagueName"
let kDefaultLeagueExists    = "defaultLeagueExists"

let kLeagueNames            = "leagueNames"

let kContestantNames        = "contestantNames"
let kContestantScores       = "contestantScores"




class DefaultsManager: ObservableObject {


    // MARK: - Leagues
    static var defaultLeagueExists: Bool {
        return UserDefaults.standard.bool(forKey: kDefaultLeagueExists)
    }
        
    static func saveDefaultLeague(name: String) {
        UserDefaults.standard.set(name, forKey: kDefaultLeagueName)
        // After setting the default league name, also turn on the Bool that it exists
        UserDefaults.standard.set(true, forKey: kDefaultLeagueExists)
        
        print("default league changed to: \(name)")
    }
    
    public func setDefaultLeaguesExists(flag : Bool) {
        UserDefaults.standard.set(flag, forKey: kDefaultLeagueExists)
    }
    
    static func getDefaultLeagueName() -> String? {
        if let leagueName = UserDefaults.standard.object(forKey: kDefaultLeagueName) as? String {
            return leagueName
        }
        return nil
    }
       
    // MARK: - Challengers
    static func saveChallengersFor(week: Int, names: [NSString], scores: [NSNumber]) {
        UserDefaults.standard.set(names, forKey: kContestantNames)
        UserDefaults.standard.set(scores, forKey: kContestantScores)
    }

}
