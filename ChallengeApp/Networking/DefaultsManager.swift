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


let kContestantNames        = "contestantNames"
let kContestantScores       = "contestantScores"




class DefaultsManager: ObservableObject {
    @Published var challengers = [Challenger]()
    @Published var challengersPresentInCache = false

    
    // MARK: - Leagues
    static var defaultLeagueExists: Bool {
        return UserDefaults.standard.bool(forKey: kDefaultLeagueExists)
    }
        
    static func saveDefaultLeague(name: String) {
        UserDefaults.standard.set(name, forKey: kDefaultLeagueName)
        // After setting the default league name, also turn on the Bool that it exists
        UserDefaults.standard.set(true, forKey: kDefaultLeagueExists)
    }
    
    static func getDefaultLeagueName() -> String? {
        if let leagueName = UserDefaults.standard.object(forKey: kDefaultLeagueName) as? String {
            return leagueName
        }
        return nil
    }
    
    static func saveChallengersFor(week: Int, names: [NSString], scores: [NSNumber]) {
        UserDefaults.standard.set(names, forKey: kContestantNames)
        UserDefaults.standard.set(scores, forKey: kContestantScores)
    }
    
//    static func getChallengersFor(week: Int) {
//        if let names = UserDefaults.standard.array(forKey: "\("kNamesForWeek")/\(week)"),
//           let scores = UserDefaults.standard.array(forKey: "\("kScoresForWeek")/\(week)") {
//            
//           // create challenger object from arrays
//            if let nameArr = names as? [NSString],
//                let scoreArr = scores as? [NSNumber] {
//                var counter = 0
//
//                for n in nameArr {
//                    let name = n as String
//
//                    let challenger = Challenger.init(id: counter, name: name, score: Int(truncating: scoreArr[counter]))
//                    self.challengers.append(challenger)
//                    counter += 1
//                }
//            }
//        }
//        self.challengersPresentInCache = self.challengers.count > 0 ? true : false
//    }
    
    
    // MARK: - Get

}
