//
//  ChooseLeagueViewModel.swift
//  ChallengeApp
//
//  Created by Michael Sevy on 5/31/20.
//  Copyright © 2020 Michael Sevy. All rights reserved.
//

import Foundation
import Firebase

final class ChooseLeagueViewModel: ObservableObject, Identifiable {
    @Published var leagues = [League]()
    @Published var isLoading = true
    @Published var noLeagues = false
    @Published var league: League?
    private let firebaseManager = FirebaseManager()

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
                                // Add Managers to league
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
            }
        }
        
        if self.leagues.count == 0 {
            self.noLeagues = true
        }
        self.isLoading = false
    }
}
