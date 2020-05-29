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
import Kanna
import Alamofire

let kChallengersNamesEndpoint   = "challengers/names/"
let kChallengersScoresEndpoint  = "challengers/scores/"
let kChallengersEndpoint        = "challengers/"
let kLeagueEndpoint             = "leagues/"
let kChallengersWeeksEndpoint   = "challengers/weeks/"
let kTotalMadnessWeeklyEndpoint = "https://www.realtvfantasy.com/shows/scores/mtv-the-challenge-total-madness/"


class FirebaseManager: ObservableObject {
    @Published var scores: [Int]?
    @Published var challengers = [Challenger]()
    @Published var leaguePostedSuccessfully = false
    @Published var updatedLeagueSuccessfully = false
    @Published var leagues = [League]()
    @Published var league: League?
    @Published var leagueName = ""
    @Published var managers = [Manager]()
    @Published var currentWeek = 0

    var defaultsManager = DefaultsManager()


    // MARK: - POST League
    func createLeagueWith(name: String, managerEmails: [String], user: User) {
        let db = Database.database()
        let reference = db.reference().child("\(kLeagueEndpoint)\(name)").childByAutoId()
        
        guard let email = user.email else { return }
        
        let payload: [NSString : Any] = ["emails" : managerEmails, "creator_email" : email]
        reference.setValue(payload) { error, ref in
            if let error = error {
                print("error posting league: \(error)")
            } else {
                print("reference succeeds posting league: \(ref)")
                self.leaguePostedSuccessfully = true
            }
        }
    }
    
    func updateLeagueWith(contestants: [String], name: NSString, leagueName: NSString) {
        let db = Database.database()
        let reference = db.reference().child("\(kLeagueEndpoint)\(leagueName)/").childByAutoId()
        
        let contestantMeta: [NSString : Any] = ["contestants" : contestants, "email" : name]
        reference.setValue(contestantMeta) { (error, reference) in
            
            if let error = error {
                print("error for contestant updating: \(error)")
            } else {
                print("updated contestants for manager successfully")
                self.updatedLeagueSuccessfully = true
            }
        }
    }
            
    private func parseChallengers(snapshot: DataSnapshot) -> [Challenger]? {
        var challengers = [Challenger]()
        
        if let values = snapshot.value as? [NSString : Any],
            let names   = values["names"] as? [String],
            let scores  = values["scores"] as? [Int],
            let week    = values["week"] as? Int,
            let actives = values["actives"] as? [Bool] {
            
            var counter = 0
            var ch = Challenger.init(id: 0, name: "", score: 0, active: true)
            ch.week = week

            for n in names {
                ch.id = counter
                ch.name = n
                ch.score = scores[counter]
                ch.active = actives[counter]
                counter += 1
                
                challengers.append(ch)
            }
        }
        return challengers
    }
        
    
    // MARK: - GET
    func getLeaguesFor(user: User) {
        let db = Database.database()
        let reference = db.reference().child("\(kLeagueEndpoint)")
        
        reference.observeSingleEvent(of: .value) { [weak self] (snapshot) in
            guard let self = self else { return }
            
            if snapshot.children.allObjects.count == 0 {
                print("no league objects yet :(, handle condition")
                return
            } else {
                self.parseAndAssignLeague(dataSnapshot: snapshot, user: user)
            }
        }
    }
    
    func compareScraperAndFetchScoresIfNecesary(week: String) {
        let db = Database.database()
        let reference = db.reference().child(kChallengersEndpoint)
        
        reference.observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.children.allObjects.count == 0 {
                print("no challengers from firebase")
                return
            } else {
                if let firebaseWeek = self.parseWeek(snapshot: snapshot) {
                    if let weekInt = Int(week) {
                        if weekInt > firebaseWeek {
                            // Comment out this line when manaually updating the weeks in Firebase
                            self.getScoresFor(week: weekInt, post: true)
                        }
                    }
                }
            }
        }
    }
    
    private func parseWeek(snapshot: DataSnapshot) -> Int? {
        if let values = snapshot.value as? [NSString : Any],
            let week   = values["week"] as? Int {
            return week
        } else {
            return nil
        }
    }
    
    private func parseAndAssignLeague(dataSnapshot: DataSnapshot, user: User) {
        if let dataValue = dataSnapshot.value as? [NSString : Any] {

            var leagues = [League]()

            for (key, value) in dataValue {
                // Add Leagues
                let leagueName = key as String
                var league = League.init(name: leagueName)
                
                var managers = [Manager]()
                
                if let contestantDict = value as? [NSString : Any] {
                    
                    for (_, valueForManger) in contestantDict {
                        if let managerDict = valueForManger as? [NSString : Any] {
                            if let contestantNames = managerDict["contestants"] as? [String],
                                let email = managerDict["email"] as? String {
                                let manager = Manager.init(email: email, contestantNames: contestantNames)
                                managers.append(manager)
                            }
                            
                            if let creatorEmail = managerDict["creator_email"] as? String {
                                league.creatorEmail = creatorEmail
                            }
                        }
                    }
                    league.managers = managers
                    leagues.append(league)
                }
            }
            
            // for user
            self.leaguesFor(user: user, allLeagues: leagues)
        } else {
            print("could not interprept snapshot value")
        }
    }
    
    private func leaguesFor(user: User, allLeagues: [League]) {
        var userIsCreator = false

        for league in allLeagues {
            if let userEmail = user.email,
               let creatorEmail = league.creatorEmail {
                // Creator added to user leagues
                if userEmail.isEqualToCaseInsensitive(string: creatorEmail) {
                    self.leagues.append(league)
                    userIsCreator = true
                }
                // Managers who's not creator added to leagues
                if !userIsCreator {
                    if let managers = league.managers {
                        for manager in managers {
                            if userEmail.isEqualToCaseInsensitive(string: manager.firebaseEmail) {
                                self.leagues.append(league)
                            }
                        }
                    }
                }
            }
        }
        
        // Set League
        for league in self.leagues {
            if league.name == DefaultsManager.getDefaultLeagueName() {
                self.league = league
                self.leagueName = league.name
            }
        }
        
        // Inflate Managers with full Challenger Object
        if let unwrappedLeague = self.league {
            self.getChallengersFor(league: unwrappedLeague)
        }        
    }
    
    private func getChallengersFor(league: League) {
        let db = Database.database()
        let reference = db.reference().child(kChallengersEndpoint)
        
        reference.observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.children.allObjects.count == 0 {
                print("no challengers from firebase")
                return
            } else {
                if let fireChallengers = self.parseChallengers(snapshot: snapshot) {
                    var managersPreSort = [Manager]()
                    
                    if let managers = league.managers {
                        for manager in managers {
                            managersPreSort.append(self.populateManagersWithChallengers(manager: manager, challengers: fireChallengers))
                        }
                        let managersSorted = managersPreSort.sorted(by: { $0.score > $1.score })
                        self.managers = managersSorted
                    }
                }
            }
        }
    }
    
    private func populateManagersWithChallengers(manager: Manager, challengers: [Challenger]) -> Manager {
        // Remake the manager with fully formed challenger objects
        var newManager = Manager(email: manager.firebaseEmail, contestantNames: manager.contestantNames!)
        var newChallengers = [Challenger]()
        
        if let contestantNames = manager.contestantNames {
            for name in contestantNames {
                for fireCh in challengers {
                    if name == fireCh.name {
                        newChallengers.append(fireCh)
                    }
                }
            }
        }
        newManager.challengers = newChallengers
        return newManager
    }
}
    

// MARK: - Post Challengers
extension FirebaseManager {
    // MARK: - Week 2 only
    func postForWeek2(names: [NSString], scores: [NSNumber], actives: [Bool]) {
          let db = Database.database()
          let reference = db.reference().child(kChallengersEndpoint)
        
        let payload: [String : Any] = ["names" : names, "scores" : scores, "actives" : actives, "week" : 2]
          
          reference.setValue(payload) { error, ref in
              
              if let error = error {
                  print("error for scores post: \(error)")
              } else {
                  print("post challengers for week 2 successful")
                // @TODO
                  //self.defaults.saveChallengersFor(week: week, names: names, scores: scores)
                  //DefaultsManager.saveScoresFor(week: week, scores: scores)
                  //self.postedScores = true
              }
          }
      }
    
    // MARK: - All other weeks will add the new scores on
    func postPostWeek2(challengers: [Challenger], names: [NSString], week: Int) {
          /*
           Fetch names, compare with incoming names
           */
          let db = Database.database()
          let reference = db.reference().child(kChallengersEndpoint)
          
          reference.observeSingleEvent(of: .value) { [weak self] (snapshot) in
            guard let self = self else { return }

              if snapshot.children.allObjects.count == 0 {
                  return
              } else {
                  if let fireChallengers = self.parseChallengers(snapshot: snapshot) {
                      
                      var summedScores = [Int]()
                      var cloudNames = [String]()
                      var actives = [Bool]()
                    
                      for cloudChallenger in fireChallengers {
                          cloudNames.append(cloudChallenger.name)

                          if names.contains(cloudChallenger.name as NSString) {
                            // Add the names of the remaining
                            actives.append(true)
                            
                              for currentChallenger in challengers {
                                  if cloudChallenger.name == currentChallenger.name {
                                      // they scored this week so add there scores together
                                      let newScore = cloudChallenger.score + currentChallenger.score
                                      summedScores.append(newScore)
                                  }
                              }
                          } else {
                            print("\(cloudChallenger.name) see ya!")
                            actives.append(false)
                            summedScores.append(cloudChallenger.score)
                          }
                      }
                        self.postSummed(scores: summedScores, names: cloudNames, actives: actives, week: week)
                  } else {
                      print("error parsing challenger")
                  }
              }
          }
      }
      
    private func postSummed(scores: [Int], names: [String], actives: [Bool], week: Int) {
        let db = Database.database()
        let reference = db.reference().child(kChallengersEndpoint)
        
        let payload: [String : Any] = ["names" : names, "scores" : scores, "actives" : actives, "week" : week]
        
        reference.setValue(payload) { error, ref in
            
            if let error = error {
                print("error for scores post: \(error)")
            } else {
                print("post updated challengers scores for week \(week) successfully")
                // And now return the managers to the UI, with:
                NotificationCenter.default.post(name: Notification.Name.UpdatedChallengerScores, object: nil)
                // @TODO
                //self.defaults.saveChallengersFor(week: week, names: names, scores: scores)
                //DefaultsManager.saveScoresFor(week: week, scores: scores)
            }
        }
    }
    
    
}

extension FirebaseManager {
    public func getScoresFor(week: Int, post: Bool) {
          AF.request("\(kTotalMadnessWeeklyEndpoint)\(week)").responseString { [weak self] response in
              guard let self = self else { return }
              
            self.challengers = [Challenger]()
            var challenger = Challenger(forTest: 0, name: "", score: 0, active: true)
            var names = [NSString]()
            var scores = [NSNumber]()
            var actives = [Bool]()
            var currentName = ""
            var counter = 1
            var previousName = ""
            var namePopulated = false
            var scorePopulated = false
            
            if let doc = try? HTML(html: response.description, encoding: .utf8) {
                for header in doc.css("a, h4") {
                    if let headerValue = header.text {
                        // Add the player
                        if Challenger.challengers.contains(headerValue) { // this is a challenger's name
                            challenger.id = counter
                            challenger.name = headerValue
                            actives.append(true)
                            names.append(headerValue as NSString)
                            counter += 1
                            namePopulated = true
                            scorePopulated = false
                            currentName = headerValue
                        } else { // the next one after will be their score
                            if headerValue.contains("Total:") {
                                // get the number out and convert to Int
                                if let scoreInt = Int(headerValue.replacingOccurrences(of: "Total: ", with: "")) {
                                    challenger.score = scoreInt
                                    scores.append(scoreInt as NSNumber)
                                    scorePopulated = true
                                }
                            }
                        }
                    }
                    if scorePopulated && namePopulated && currentName != previousName {
                        self.challengers.append(challenger)
                        previousName = currentName
                    }
                }
            }
            if post {
                // send to firebase
                if self.challengers.count > 0 {
                    if week == 2 {
                        self.postForWeek2(names: names, scores: scores, actives: actives)
                    } else {
                        // after week 2 we only need the next week's score
                        self.postPostWeek2(challengers: self.challengers, names: names, week: week)
                    }
                }
            }
        }
    }
    
}

