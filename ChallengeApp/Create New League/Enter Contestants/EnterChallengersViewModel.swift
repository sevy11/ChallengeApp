//
//  EnterChallengersViewModel.swift
//  ChallengeApp
//
//  Created by Michael Sevy on 6/1/20.
//  Copyright © 2020 Michael Sevy. All rights reserved.
//

import Foundation
import Combine

protocol EnterChallengersProtocol {
    func getContestantsFor(league: League)
    func update(league: League, managerEmail: String)
}

final class EnterChallengersViewModel: EnterChallengersProtocol, ObservableObject, Identifiable {
    // MARK: - Instance Variables
    @Published var challengers:  [String] = Challenger.challengers
    @Published var challengersForManager = [String]()
    private let firebase = FirebaseManager()

    // MARK: - Functions
    public func getContestantsFor(league: League) {
        switch league.show.title {
        case .challenge:
            self.challengers = Challenger.challengers
        case .survivor:
            self.challengers = Challenger.survivors
        case .bachelor:
            print("todo add bachlor contestants")
        case .bachelorette:
            print("todo add bachlorette contestants")
        case .none:
            print("no action here")
        }
    }
    
    public func update(league: League, managerEmail: String) {
        firebase.updateLeagueWith(contestantNames: self.challengersForManager, managerEmail: managerEmail, leagueName: league.name, success: { (success) in
            print("Successfully updated the manager's contestant names.")
        }) { (error) in
            print("failed to update contestant names with error: \(error)")
        }
    }
}

