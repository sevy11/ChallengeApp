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

class FirebaseManager: ObservableObject {
    @Published var scores: [Int]?
    @Published var challengers = [Challenger]()
    @Published var leaguePostedSuccessfully = false
    @Published var updatedLeagueSuccessfully = false
    @Published var leagues = [League]()
    @Published var league: League?
    @Published var leagueName = ""
    @Published var managers = [Manager]()
    var defaults = DefaultsManager()


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
            
    private func parseData(snapshot: DataSnapshot) -> [Challenger]? {
        var challengers = [Challenger]()
        
        if let values = snapshot.value as? [NSString : Any],
            let names  = values["names"] as? [String],
            let scores = values["scores"] as? [Int],
            let week   = values["week"] as? Int {
            
            var counter = 0
            var ch = Challenger.init(id: 0, name: "", score: 0)
            ch.week = week

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
                self.parseLeague(dataSnapshot: snapshot, user: user)
            }
        }
    }
    
    func compareScraperAndFetchScoresIfNecesary(week: String, user: User) {
        let db = Database.database()
        let reference = db.reference().child(kChallengersEndpoint)
        
        reference.observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.children.allObjects.count == 0 {
                print("no challengers from firebase")
                return
            } else {
                if let firebaseWeek = self.getWeek(snapshot: snapshot) {
                    if let weekInt = Int(week) {
                        if weekInt > firebaseWeek {
                            // Comment out this line when manaually updating the weeks in Firebase
                            self.getScoresFor(week: weekInt, post: true, user: user)
                        }
                    }
                }
            }
        }
    }
    
    private func getWeek(snapshot: DataSnapshot) -> Int? {
        if let values = snapshot.value as? [NSString : Any],
            let week   = values["week"] as? Int {
            return week
        } else {
            return nil
        }
    }
    
    private func parseLeague(dataSnapshot: DataSnapshot, user: User) {
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
            self.leaguesFor(user: user, leagues: leagues)
        } else {
            print("could not interprept snapshot value")
        }
    }
    
    private func leaguesFor(user: User, leagues: [League]) {
        for league in leagues {
            if let email = user.email,
               let leagueEmail = league.creatorEmail {
                
                if email == leagueEmail {
                    self.leagues.append(league)
                }
                
                // get league
                for league in self.leagues {
                    if league.name == DefaultsManager.getDefaultLeagueName() {
                        self.league = league
                        self.leagueName = league.name
                    }
                }
                
                // now get the managers with full challengers for the league
                if let unwrappedLeague = self.league {
                    self.getChallengersFor(league: unwrappedLeague)
                }
            }
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
                if let fireChallengers = self.parseData(snapshot: snapshot) {
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
        // Remake the manager with fully form challenger objects
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
      func postForWeek2(names: [NSString], scores: [NSNumber]) {
          let db = Database.database()
          let reference = db.reference().child(kChallengersEndpoint)
          // @TODO update hard coded week here
          let payload: [String : Any] = ["names" : names, "scores" : scores, "week" : 2]
          
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
    func postPostWeek2(challengers: [Challenger], names: [NSString], week: Int, user: User?) {
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
                  if let fireChallengers = self.parseData(snapshot: snapshot) {
                      
                      var summedScores = [Int]()
                      var cloudNames = [String]()
                      
                      for cloudChallenger in fireChallengers {
                          cloudNames.append(cloudChallenger.name)
                          
                          if names.contains(cloudChallenger.name as NSString) {
                              for currentChallenger in challengers {
                                  if cloudChallenger.name == currentChallenger.name {
                                      // they scored this week so add there scores together
                                      let newScore = cloudChallenger.score + currentChallenger.score
                                      summedScores.append(newScore)
                                  }
                              }
                          } else {
                              summedScores.append(cloudChallenger.score)
                              print("you didn't make it sucker(\(cloudChallenger.name))")
                          }
                      }
                        self.postSummed(scores: summedScores, names: cloudNames, week: week, user: user)
                  } else {
                      print("error parsing challenger")
                  }
              }
          }
      }
      
    private func postSummed(scores: [Int], names: [String], week: Int, user: User?) {
        let db = Database.database()
        let reference = db.reference().child(kChallengersEndpoint)
        
        let payload: [String : Any] = ["names" : names, "scores" : scores, "week" : week]
        
        reference.setValue(payload) { error, ref in
            
            if let error = error {
                print("error for scores post: \(error)")
            } else {
                print("post updated challengers scores for week \(week) successfully")
                // And now return the managers to the UI, with:
                NotificationCenter.default.post(name: NSNotification.Name("UpdatedChallengerScores"), object: nil)
                // @TODO
                //self.defaults.saveChallengersFor(week: week, names: names, scores: scores)
                //DefaultsManager.saveScoresFor(week: week, scores: scores)
            }
        }
    }
    
    
}

extension FirebaseManager {
    public func getScoresFor(week: Int, post: Bool, user: User?) {
          AF.request("https://www.realtvfantasy.com/shows/scores/mtv-the-challenge-total-madness/\(week)").responseString { [weak self] response in
              guard let self = self else { return }
              
            // clear the array first:
            self.challengers = [Challenger]()
            var challenger = Challenger(forTest: 0, name: "", score: 0)
            var names = [NSString]()
            var scores = [NSNumber]()
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
                        self.postForWeek2(names: names, scores: scores)
                    } else {
                        // after week 2 we only need the next week's score
                        self.postPostWeek2(challengers: self.challengers, names: names, week: week, user: user)
                    }
                }
            }
        }
    }
    
}

