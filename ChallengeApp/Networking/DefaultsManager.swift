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

class DefaultsManager {
    // MARK: - Leagues
    static func saveDefaultLeague(name: String) {
        UserDefaults.standard.set(name, forKey: kDefaultLeagueName)
        // After setting the default league name, also turn on the Bool that it exists
        UserDefaults.standard.set(true, forKey: kDefaultLeagueExists)
        print("default league changed to: \(name)")
    }
    
    static func getDefaultLeagueName() -> String? {
        if let leagueName = UserDefaults.standard.object(forKey: kDefaultLeagueName) as? String {
            return leagueName
        }
        return nil
    }
       
    // MARK: - Challengers
//    static func saveChallengersFor(week: Int, names: [NSString], scores: [NSNumber]) {
//        UserDefaults.standard.set(names, forKey: kContestantNames)
//        UserDefaults.standard.set(scores, forKey: kContestantScores)
//    }

}

@propertyWrapper
public struct DefaultSynced<Value> {
    public let key: String
    public let defaultValue: Value
    public var wrappedValue: Value {
        get {
            UserDefaults.standard.object(forKey: key) as? Value ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}

public struct Defaults {
    @DefaultSynced(key: kDefaultLeagueName, defaultValue: "")
    public var leagueName: String
}
