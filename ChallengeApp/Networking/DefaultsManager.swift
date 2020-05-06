//
//  DefaultsManager.swift
//  ChallengeApp
//
//  Created by Michael Sevy on 4/21/20.
//  Copyright © 2020 Michael Sevy. All rights reserved.
//

import Foundation

class DefaultsManager {
    static let kCurrentWeek         = "kCurrentWeek"
    static let kScoresForWeek       = "kScoresForWeek"
    static let kCurrentChallengers  = "kCurrentChallengers"
    
    
    var currentWeek: Int? {
        return UserDefaults.standard.integer(forKey: DefaultsManager.kCurrentWeek)
    }
    // Current Week
    func updateCurrent(week: Int) {
        UserDefaults.standard.setValue(week, forKey: DefaultsManager.kCurrentWeek)
    }
    
//    func currentWeek() -> Int? {
//        return UserDefaults.standard.integer(forKey: DefaultsManager.kCurrentWeek)
//    }
    
    // Scores
    func updateWeeks(scores: [Int]) {
        UserDefaults.standard.setValue(scores, forKey: DefaultsManager.kScoresForWeek)
    }
    
    func currentWeeksScores() -> [Int]? {
        if let scores = UserDefaults.standard.array(forKey: DefaultsManager.kScoresForWeek) as? [Int] {
            return scores
        }
        return nil
    }
    
    // MARK: - Challengers
    static func saveScoresFor(week: Int, scores: [NSNumber]) {
        UserDefaults.standard.set(scores, forKey: "\(DefaultsManager.kScoresForWeek)/\(week)")
    }
    
    static func getScoresFor(week: Int) -> [Int]? {
        if let scores = UserDefaults.standard.array(forKey: "\(DefaultsManager.kScoresForWeek)/\(week)") {
            return scores as? [Int]
        }
        return nil
    }
    
    func addNewWeek(scores: [Int]) {
        var ids = [Int]()
        var newScores = [Int]()
        var names = [String]()
        
        // challengers re-create chs to add score on the end
        if let chs = getCurrentChallengers() {
            for c in chs {
                ids.append(c.id)
                names.append(c.name)
                
                for s in scores {
                    newScores.append(c.score + s)
                }
            }
        }
    }
    
    func getLastSavedWeek() -> Int? {
        if let scores = UserDefaults.standard.array(forKey: DefaultsManager.kCurrentChallengers) {
            return scores.count
        }
        return nil
    }
    
//    func save(challengers: [Challenger], week: Int) {
//        if week
//        UserDefaults.standard.setValue(challengers, forKey: DefaultsManager.kCurrentChallengers)
//    }
    
    func getCurrentChallengers() -> [Challenger]? {
        if let challengers = UserDefaults.standard.array(forKey: DefaultsManager.kCurrentChallengers) {
            return challengers as? [Challenger]
        }
        return nil
    }
    
}
