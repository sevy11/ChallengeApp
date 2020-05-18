//
//  DefaultsManager.swift
//  ChallengeApp
//
//  Created by Michael Sevy on 4/21/20.
//  Copyright © 2020 Michael Sevy. All rights reserved.
//

import Foundation
import Combine


class DefaultsManager: ObservableObject {
    @Published var challengers = [Challenger]()
    @Published var challengersPresentInCache = false

    
    // MARK: - Challengers
    public func saveChallengersFor(week: Int, names: [NSString], scores: [NSNumber]) {
        UserDefaults.standard.set(names, forKey: "\("kNamesForWeek")/\(week)")
        UserDefaults.standard.set(scores, forKey: "\("kScoresForWeek")/\(week)")
    }
    
    public func getChallengersFor(week: Int) {
        if let names = UserDefaults.standard.array(forKey: "\("kNamesForWeek")/\(week)"),
           let scores = UserDefaults.standard.array(forKey: "\("kScoresForWeek")/\(week)") {
            
           // create challenger object from arrays
            if let nameArr = names as? [NSString],
                let scoreArr = scores as? [NSNumber] {
                var counter = 0

                for n in nameArr {
                    let name = n as String

                    let challenger = Challenger.init(id: counter, name: name, score: Int(truncating: scoreArr[counter]))
                    self.challengers.append(challenger)
                    counter += 1
                }
            }
        }
        self.challengersPresentInCache = self.challengers.count > 0 ? true : false
    }

}
