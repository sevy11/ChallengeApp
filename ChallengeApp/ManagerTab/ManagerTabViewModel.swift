//
//  ManagerTabViewModel.swift
//  ChallengeApp
//
//  Created by Michael Sevy on 5/29/20.
//  Copyright © 2020 Michael Sevy. All rights reserved.
//

import Foundation
import Combine
import Firebase
import Kanna
import SwiftUI

class ManagerTabViewModel: ObservableObject, Identifiable {
    private let webScraper = WebScraper()
    private let firebaseManager = FirebaseManager()

    @Published var currentAvailableWeek: String = ""
    @Published var challengers = [Challenger]()
    @Published var leagues = [League]()
    @Published var league: League?
    @Published var managers = [Manager]()
    @Published var leagueName = ""
    @Published var isLoading = true
    @Published var week2ScoresPosted = false
    @Published var weekPost2ScoresPosted = false
    // unused
    private var disposables = Set<AnyCancellable>()

    func getCurrentWeek(user: User) {
        webScraper.getCurrentWeek { (responseDescription) in
            self.parseForCurrentWeek(html: responseDescription)
        }
    }
    
    private func parseForCurrentWeek(html: String) {
        var weeksAvailable = [String]()

        if let doc = try? HTML(html: html, encoding: .utf8) {
            for header in doc.css("a, h4") {
                if let headerValue = header.text {
                    if headerValue.contains("Episode ") && headerValue.contains("Scores") {
                        // get the number out and convert to Int
                        let result = headerValue.trimmingCharacters(in: CharacterSet(charactersIn: "0123456789.").inverted)
                        weeksAvailable.append(result)
                    }
                }
            }
        }
        
        let sorted = weeksAvailable.sorted { $0 > $1 }
        if let currentWeek = sorted.first {
            self.currentAvailableWeek = currentWeek
            self.compare(week: currentWeek)
        } else {
            self.currentAvailableWeek = "Loading..."
        }
    }
    
    func compare(week: String) {
        guard let intWeek = Int(week) else { return }
        
        firebaseManager.getChallengersWith(week: intWeek, success: { snap in
            // Parse for week
            if let values = snap.value as? [NSString : Any],
                let firebaseWeek = values["week"] as? Int {
                
                // compare
                if intWeek > firebaseWeek {
                    self.getScoresFor(week: intWeek, post: true)
                }
            }
        }) { (failure) in
            print("failure, handle")
        }
    }
    
    public func getScoresFor(week: Int, post: Bool) {
        self.webScraper.getScoresFor(week: week, success: { [weak self] (responseDescription) in
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
            
            if let doc = try? HTML(html: responseDescription, encoding: .utf8) {
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
                                // Get the number out and convert to Int
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
            // Post to Firebase
            if post {
                if self.challengers.count > 0 {
                    if week == 2 {
                        self.firebaseManager.postForWeek2(names: names, scores: scores, actives: actives) { (success) in
                            if success {
                                self.week2ScoresPosted = true
                            }
                        }
                    } else {
                        // After week 2 we only need the next week's score
                        self.firebaseManager.postPostWeek2(challengers: self.challengers, names: names, week: week) { (snap) in
                            if let snapshot = snap {
                                self.sumScoresAndPostUpdatedChallengers(snapshot: snapshot, names: names, week: week)
                            }
                        }
                    }
                }
            }
        }) { (failed) in
            print("failed to fetch from web scraper")
        }
    }
    
    func sumScoresAndPostUpdatedChallengers(snapshot: DataSnapshot, names: [NSString], week: Int) {
        if let fireChallengers = Challenger.parseWith(snapshot: snapshot) {
            
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
            
            self.firebaseManager.postSummed(scores: summedScores, names: cloudNames, actives: actives, week: week) { (success) in
                if success {
                    // Posted summed scores and updated the Challenger in Firebase, reload
                    NotificationCenter.default.post(name: Notification.Name.UpdatedChallengerScores, object: nil)
                }
            }
        } else {
            print("error parsing challenger")
        }
    
    }
    
    public func getLeaguesFor(user: User) {
        self.firebaseManager.getLeagues(success: { (snapshot) in
            self.parseAndAssignLeague(dataSnapshot: snapshot, user: user)
        }) { (failed) in
            print("failed to fetch leagues for user, handle by setting publisher")
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
            self.setLeaguesFor(user: user, allLeagues: leagues)
        } else {
            print("could not interprept snapshot value")
        }
    }
    
    private func setLeaguesFor(user: User, allLeagues: [League]) {
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
        
        if self.leagues.count == 1 {
            if let singleLeague = self.leagues.first {
                DefaultsManager.saveDefaultLeague(name: singleLeague.name)
                self.league = singleLeague
            }
            // Default name not set for first time user
        } else if DefaultsManager.getDefaultLeagueName() == nil && self.leagues.count > 0 {
            if let firstLeague = self.leagues.first {
                DefaultsManager.saveDefaultLeague(name: firstLeague.name)
                if self.league == nil {
                    self.league = firstLeague
                }
            }
        }
        // League was deleted from database purge
        if self.league == nil && self.leagues.count > 0 {
            self.league = self.leagues.first!
            DefaultsManager.saveDefaultLeague(name: self.league!.name)
        }
        
        // Inflate Managers with full Challenger Object
        if let unwrappedLeague = self.league {
            self.getChallengersFor(league: unwrappedLeague)
        }
    }
    
    private func getChallengersFor(league: League) {
        self.firebaseManager.getChallengersFor(league: league, success: { (snapshot) in
            if let fireChallengers = Challenger.parseWith(snapshot: snapshot) {
                var managersPreSort = [Manager]()
                
                if let managers = league.managers {
                    for manager in managers {
                        managersPreSort.append(self.populateManagersWithChallengers(manager: manager, challengers: fireChallengers))
                    }
                    let managersSorted = managersPreSort.sorted(by: { $0.score > $1.score })
                    self.managers = managersSorted
                    self.isLoading = false
                }
            }
        }) { (failed) in
            print("failed")
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
