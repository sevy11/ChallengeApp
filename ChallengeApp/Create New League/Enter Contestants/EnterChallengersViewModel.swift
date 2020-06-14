//
//  EnterChallengersViewModel.swift
//  ChallengeApp
//
//  Created by Michael Sevy on 6/1/20.
//  Copyright © 2020 Michael Sevy. All rights reserved.
//

import Foundation
import Combine

final class EnterChallengersViewModel: ObservableObject, Identifiable {
    let firebase = FirebaseManager()
    @Published var challengers:  [String] = Challenger.challengers
    @Published var challengersForManager = [String]()
    
    // @TODO constant Challengers for now
    func getContestantsFor(league: League) {
        if league.program.title == .challenge {
            self.challengers = Challenger.challengers
        } else if league.program.title == .survivor {
            self.challengers = Challenger.survivors
        } else {
            // @TODO more shows
        }
    }
    
    func update(league: League, manager: String) {
        firebase.updateLeagueWith(contestantNames: self.challengersForManager, managerEmail: manager, leagueName: league.name, success: { (success) in
            print("Successfully updated the manager's contestant names.")
        }) { (error) in
            print("failed to update contestant names with error: \(error)")
        }
    }
}

