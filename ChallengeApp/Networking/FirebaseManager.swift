//
//  FirebaseManager.swift
//  ChallengeApp
//
//  Created by Michael Sevy on 4/12/20.
//  Copyright © 2020 Michael Sevy. All rights reserved.
//

import Foundation
import Combine
import Firebase

let kChallengersEndpoint    = "challengers/week/"

class FirebaseManager: ObservableObject {
    
    var publisher: AnyPublisher<Void, Never>! = nil

    @Published var dataIsLoaded: Bool = false

    @Published var postedScores: Bool?// = [Challenger]()
    @Published var scores: [Int]?
    @Published var names: [String]?
    @Published var challengers: [Challenger]?
    
    // MARK: - POST
    func postScoresFor(week: Int, scores: [NSNumber], names: [NSString]) {
        let db = Database.database()
        let reference = db.reference().child("\(kChallengersEndpoint)\(week)")
        
        let payload: [String : Any] = ["names" : names, "scores" : scores]
        
        reference.setValue(payload) { [weak self] error, ref in
            guard let self = self else { return }
            
            if let error = error {
                print("error for scores post: \(error)")
            } else {
                print("reference succeeds posting: \(ref)")
                DefaultsManager.saveScoresFor(week: week, scores: scores)
                self.postedScores = true
            }
        }
    }
    
    
    func update(scores: [Int], week: Int) {
        let db = Database.database()
        let reference = db.reference().child("\(kChallengersEndpoint)\(week)")
        reference.child("scores").setValue(scores)
        reference.child("scores").setValue(scores) { (error, reference) in
            
            if let error = error {
                print("error for scores post: \(error)")
            } else {
                print("scores update for week send to defaults")
            }
        }
    }

    
    // MARK: - GET
    func getChallengersFor(week: Int, success: @escaping (_ challengers: [Challenger]?) -> Void) {
        let db = Database.database()
        let referece = db.reference().child("\(kChallengersEndpoint)\(week)")
        
        referece.observeSingleEvent(of: .value) { [weak self] (snapshot) in
            guard let self = self else { return }
            
            if snapshot.children.allObjects.count == 0 {
                // week hasn't been sent to firebase yet
                self.scores = nil
                success(nil)
                return
            } else {
                if let chs = self.parseData(snapshot: snapshot) {
                    success(chs)
                }
            }
        }
    }

    func getSumScoresFor(week: Int, challengers: [Challenger]) {
        /*
            First week hard coded here but we will add this later in the settings for
            different peoples leagues, something like: start scoring with week:
         */
        if week == 2 {
            var scores = [NSNumber]()
            var names = [NSString]()
            
            for c in challengers {
                let name = c.name as NSString
                let score = c.score as NSNumber
                names.append(name)
                scores.append(score)
            }
            self.postScoresFor(week: week, scores: scores, names: names)
            return
        }
        // Weeks 3-16 that have previous week
        let previousWeek = week - 1
        
        self.getChallengersFor(week: previousWeek) { (previousWeekChallengers) in
            var summedScores = [NSNumber]()
            var names = [NSString]()
            
            if let chs = previousWeekChallengers {
                
                for pre in chs {
                    for ch in challengers {
                        if pre.name == ch.name {
                            let score = pre.score + ch.score
                            let scoreNumber = score as NSNumber
                            summedScores.append(scoreNumber)
                            let name = ch.name as NSString
                            names.append(name)
                        }
                    }
                }
                self.postScoresFor(week: week, scores: summedScores, names: names)
            } else {
                print("no previous challenger")
            }
        }
    }
    
    func getScoresFor(week: Int, success: @escaping (_ scores: [Int]?) -> Void) {
          let db = Database.database()
          let reference = db.reference().child("\(kChallengersEndpoint)\(week)")
          
          reference.observeSingleEvent(of: .value) { (snapshot) in
              if snapshot.children.allObjects.count == 0 {
                  success(nil)
                  return
              } else {
                  if let values = snapshot.value as? [NSString : [Int]] {
                      let scores = values["scores"]
                    success(scores)
                }
            }
        }
    }
        
    func parseData(snapshot: DataSnapshot) -> [Challenger]? {
        var challengers = [Challenger]()
        
        if let values = snapshot.value as? [NSString : Any],
            let names = values["names"] as? [String],
            let scores = values["scores"] as? [Int] {
            
            var counter = 0
            var ch = Challenger.init(id: 0, name: "", score: 0)
            
            for n in names {
                ch.id = counter
                ch.name = n
                ch.score = scores[counter]
                counter += 1
                
                challengers.append(ch)
            }
        }
        return challengers
    }

}
