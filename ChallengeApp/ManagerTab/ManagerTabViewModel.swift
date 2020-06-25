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
import Alamofire

protocol ManagerProtocol {
    func getCurrentWeek()
    func getScoresFor(week: Int, post: Bool)
    func getLeaguesFor(user: User)
}

class ManagerTabViewModel: ManagerProtocol, ObservableObject, Identifiable {
    private let webScraper = WebScraper()
    private let firebaseManager = FirebaseManager()
    private var subscriptions = Set<AnyCancellable>()
        
    @Published var weekError: AFError? = nil
    @Published var currentAvailableWeek = ""
    @Published var challengerScoreError: AFError? = nil
    @Published var leagues = [League]()
    @Published var league: League?
    @Published var managers = [Manager]()
    @Published var leagueName = ""
    @Published var isLoading = true
    @Published var week2ScoresPosted = false
    @Published var weekPost2ScoresPosted = false

    // MARK: - Get Week
    func getCurrentWeek() {
        webScraper
            .getCurrentWeek()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
            }, receiveValue: { [weak self] weekResponse in
                guard let self = self else { return }
    
                if let htmlRaw = weekResponse.value {
                    self.parseForCurrentWeek(htmlRaw: htmlRaw)
                    self.weekError = nil
                } else if let error = weekResponse.error {
                    self.weekError = error
                }
            })
        .store(in: &subscriptions)
    }
    
    private func parseForCurrentWeek(htmlRaw: String) {
        var weeksAvailable = [String]()
        
        if let doc = try? HTML(html: htmlRaw, encoding: .utf8) {
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
        // sort string ints least to greatest
        let ans = weeksAvailable.sorted {
            (s1, s2) -> Bool in return s1.localizedStandardCompare(s2) == .orderedAscending
        }
        if let currentWeek = ans.last {
            self.currentAvailableWeek = currentWeek
            self.compare(week: currentWeek)
        } else {
            self.currentAvailableWeek = "Loading..."
        }
    }
    
    private func compare(week: String) {
        guard let intWeek = Int(week) else { return }
        
        firebaseManager.getChallengersWith(week: intWeek, success: { snap in
            // Parse for week
            if let values = snap.value as? [NSString : Any],
                let firebaseWeek = values["week"] as? Int {
                
                // compare
                if intWeek > firebaseWeek {
                    print("we have a new week, get new week scores from web scraper, send out a APNS to all users")
                    self.getScoresFor(week: intWeek, post: true)
                } else {
                    print("no new week scores yet, :(")
                }
            }
        }) { (failure) in
            print("failure, handle")
        }
    }
    
    // MARK: - Get Manager's Scores
    func getScoresFor(week: Int, post: Bool) {
        webScraper
            .getScoresFor(week: week)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                
            }, receiveValue: { [weak self] response in
                guard let self = self else { return }
                
                if let html = response.value {
                    self.parseRawChallenger(html: html, week: week, post: post)
                } else if let error = response.error {
                    self.challengerScoreError = error
                }
            }).store(in: &subscriptions)
    }
    
    private func parseRawChallenger(html: String, week: Int, post: Bool) {
        var challenger = Challenger(forTest: 0, name: "", score: 0, active: true)
        var challengers = [Challenger]()
        var names = [NSString]()
        var scores = [NSNumber]()
        var actives = [Bool]()
        var currentName = ""
        var counter = 1
        var previousName = ""
        var namePopulated = false
        var scorePopulated = false
           
        if let doc = try? HTML(html: html, encoding: .utf8) {
            for header in doc.css("a, h4, span") {
                if let headerValue = header.text {
                    // Add the player
                    if Challenger.challengers.contains(headerValue) {
                        challenger.id = counter
                        challenger.name = headerValue
                        actives.append(true)
                        names.append(headerValue as NSString)
                        counter += 1
                        namePopulated = true
                        scorePopulated = false
                        currentName = headerValue
                    } else {
                        // the next one after will be their score
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
                    challengers.append(challenger)
                    previousName = currentName
                }
            }
        }
        // Optionally post to Firebase
        if post {
            self.postToFirebase(challengers: challengers, week: week, names: names, scores: scores, actives: actives)
        }
    }
    
    private func postToFirebase(challengers: [Challenger], week: Int, names: [NSString], scores: [NSNumber], actives: [Bool]) {
        if challengers.count > 0 {
            if week == 2 {
                self.firebaseManager.postForWeek2(names: names, scores: scores, actives: actives) { (success) in
                    if success {
                        self.week2ScoresPosted = true
                    }
                }
            } else {
                // After week 2 we only need the next week's score
                self.firebaseManager.postPostWeek2(challengers: challengers, names: names, week: week) { (snap) in
                    if let snapshot = snap {
                        self.sumScoresAndPostUpdated(challengers: challengers, snapshot: snapshot, names: names, week: week)
                    }
                }
            }
        }
    }
    
    private func sumScoresAndPostUpdated(challengers: [Challenger], snapshot: DataSnapshot, names: [NSString], week: Int) {
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
                self.leagueName = singleLeague.name
            }
            // Default name not set for first time user
        } else if DefaultsManager.getDefaultLeagueName() == nil && self.leagues.count > 0 {
            if let firstLeague = self.leagues.first {
                DefaultsManager.saveDefaultLeague(name: firstLeague.name)
                if self.league == nil {
                    self.league = firstLeague
                    self.leagueName = firstLeague.name
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
        } else {
            // User has no leauegs associated with them, no need to populate users
            self.isLoading = false
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
